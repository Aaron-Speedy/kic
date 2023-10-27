#include <stdarg.h>
#define TB_IMPL
#include "termbox2.h"

typedef enum {
  MODE_NORMAL,
  MODE_INSERT,
  MODE_GOTO,
  NUM_MODES,
} Mode;

typedef struct {
  char *content;
  size_t len;
  size_t cap;
} Line;

typedef struct {
  size_t x;
  size_t saved_x;
  size_t y;
} Cursor;

typedef struct {
  Cursor anchor;
  Cursor cursor;
} Selection;

typedef struct {
  Line *lines;
  size_t num_lines;
  size_t cap_lines;

  size_t view_top;

  Selection *sels;
  size_t num_sels;
  size_t cap_sels;
  size_t primary_sel;

  size_t num_arg;

  Mode mode;

  const char *file_path;
} Buffer;

typedef void (*BufferOperation)();

typedef struct {
  BufferOperation *ops;
  size_t num_ops;
} OperationList;

BufferOperation *buf_op_arena;
size_t num_buf_ops = 0;
size_t cap_buf_ops = 1000;

struct tb_event tb_event;

enum {
  FILE_EDIT_MODE,
  MENU_EDIT_MODE,
} edit_mode = FILE_EDIT_MODE;
enum {
  COMMAND_MENU_MODE,
  SEARCH_MENU_MODE,
} menu_mode = 0;

Buffer *buffer;
Buffer *file_buffer_global;
Buffer *menu_buffer_global;

void init_operation_list(OperationList *op_list, int num_ops, ...) {
  if (num_buf_ops > cap_buf_ops) {
    cap_buf_ops *= 2;
    BufferOperation *new_arena = realloc(buf_op_arena, sizeof(BufferOperation) * cap_buf_ops);
    if (new_arena == NULL) {
      perror("Could not realloc buf_op_arena for appending");
      exit(EXIT_FAILURE);
    }
    buf_op_arena = new_arena;
  }
  num_buf_ops += 1;
  op_list->ops = &buf_op_arena[num_buf_ops - 1];

  va_list args;
  va_start(args, num_ops);
  for (int i = 0; i < num_ops; i++) {
    op_list->ops[i] = va_arg(args, BufferOperation);
  }
  op_list->num_ops = num_ops;

  va_end(args);
}

void get_ordered_cursors(Selection *sel, Cursor **buf) {
  if (sel->anchor.y < sel->cursor.y) { buf[0] = &sel->anchor; buf[1] = &sel->cursor; return; };
  if (sel->anchor.y > sel->cursor.y) { buf[0] = &sel->cursor; buf[1] = &sel->anchor; return; };
  if (sel->anchor.x <= sel->cursor.x) { buf[0] = &sel->anchor; buf[1] = &sel->cursor; return; };
  buf[0] = &sel->cursor, buf[1] = &sel->anchor;
}

void insert(Line *line, char *str, size_t str_len, size_t x) {
  if (line->len + str_len >= line->cap) {
    line->cap = line->len * 2 + str_len;
    char *new_content = realloc(line->content, sizeof(char) * line->cap);
    if (new_content == NULL) {
      perror("Could not realloc line->content for inserting");
      exit(EXIT_FAILURE);
    }

    line->content = new_content;
  }

  memmove(&line->content[x + str_len], &line->content[x], sizeof(char) * (line->len - x));
  memcpy(&line->content[x], str, sizeof(char) * str_len);
  line->len += str_len;
}

void insert_line(Buffer *buffer, Line *line, size_t y) {
  if (buffer->num_lines + 1 >= buffer->cap_lines) {
    buffer->cap_lines = buffer->num_lines * 2 + 1;
    Line *new_buffer_lines = realloc(buffer->lines, sizeof(Line) * buffer->cap_lines);
    if (new_buffer_lines == NULL) {
      perror("Could not realloc buffer->lines for inserting a line");
    }

    buffer->lines = new_buffer_lines;
  }

  memmove(&buffer->lines[y + 1], &buffer->lines[y], sizeof(Line) * (buffer->num_lines - y));
  buffer->lines[y].content = line->content;
  buffer->lines[y].len = line->len;
  buffer->lines[y].cap = line->len;
  buffer->num_lines += 1;
}

void remove_span(Buffer *buffer, size_t len, size_t x, size_t y) {
  if (x - 1 + len == buffer->lines[y].len) {
    if (y < buffer->num_lines - 1) {
      insert(&buffer->lines[y], buffer->lines[y + 1].content, buffer->lines[y + 1].len, x);
      free(buffer->lines[y + 1].content);
      memmove(&buffer->lines[y + 1], &buffer->lines[y + 2], sizeof(Line) * (buffer->num_lines - y));
      buffer->num_lines -= 1;
    }
    len -= 1;
  }
  memmove(&buffer->lines[y].content[x], &buffer->lines[y].content[x + len], sizeof(char) * (buffer->lines[y].len - x - len));
  buffer->lines[y].len -= len;
}

void draw_buffer(Buffer *buffer, size_t draw_x, size_t draw_y, size_t height) {
  size_t view_top = buffer->view_top;

  for (int i = view_top; i < view_top + height && i < buffer->num_lines; i++) {
    tb_print_len(draw_x, i - view_top + draw_y, TB_WHITE, 0, buffer->lines[i].content, buffer->lines[i].len);
  }

  uintattr_t color = 0;
  if (buffer->mode == MODE_INSERT) color = TB_RED;
  if (buffer->mode == MODE_NORMAL) color = TB_BLUE;
  for (int i = 0; i < buffer->num_sels; i++) {
    Cursor *ends[2] = { 0 };
    get_ordered_cursors(&buffer->sels[i], ends);
    int x = ends[0]->x;
    for (int y = ends[0]->y; y < ends[1]->y; y++) {
      for (; x <= buffer->lines[y].len; x++) {
        if (x == buffer->lines[y].len) tb_set_cell(x + draw_x, y - view_top + draw_y, 0, 0, color);
        else tb_set_cell(x + draw_x, y - view_top + draw_y, buffer->lines[y].content[x], 0, color);
      }
      x = 0;
    }
    // TODO: You could probably pull out the y from the first for loop and reuse the code with no alterations, but I'm tired
    for (; x <= ends[1]->x; x++) { 
      if (x == buffer->lines[ends[1]->y].len) tb_set_cell(x + draw_x, ends[1]->y - view_top + draw_y, 0, 0, color);
      else tb_set_cell(x + draw_x, ends[1]->y - view_top + draw_y, buffer->lines[ends[1]->y].content[x], 0, color);
    }
  }

  tb_present();
}

void set_cursor_x(Cursor *cursor, size_t new_cursor_x) {
  cursor->x = new_cursor_x;
  cursor->saved_x = cursor->x;
}

void set_cursor_y(Cursor *cursor, size_t new_cursor_y, size_t new_line_len) {
  cursor->y = new_cursor_y;
  cursor->x = cursor->saved_x > new_line_len ? new_line_len : cursor->saved_x;
}

void shutdown() {
  tb_shutdown();

  exit(EXIT_SUCCESS);
}

void reduce_selections_to_cursor() {
  for (int i = 0; i < buffer->num_sels; i++) {
    buffer->sels[i].anchor.x = buffer->sels[i].cursor.x;
    buffer->sels[i].anchor.saved_x = buffer->sels[i].cursor.saved_x;
    buffer->sels[i].anchor.y = buffer->sels[i].cursor.y;
  }
}

void reduce_selections_to_primary() {
  buffer->num_sels = 1;
  buffer->sels[0].cursor.x = buffer->sels[buffer->primary_sel].cursor.x;
  buffer->sels[0].cursor.saved_x = buffer->sels[buffer->primary_sel].cursor.saved_x;
  buffer->sels[0].cursor.y = buffer->sels[buffer->primary_sel].cursor.y;
  buffer->sels[0].anchor.x = buffer->sels[buffer->primary_sel].anchor.x;
  buffer->sels[0].anchor.saved_x = buffer->sels[buffer->primary_sel].anchor.saved_x;
  buffer->sels[0].anchor.y = buffer->sels[buffer->primary_sel].anchor.y;
}

void enter_insert_mode() {
  for (int i = 0; i < buffer->num_sels; i++) {
    Cursor *ends[2] = { 0 };
    get_ordered_cursors(&buffer->sels[i], ends);

    size_t x = ends[1]->x, saved_x = ends[1]->x, y = ends[1]->y;
    buffer->sels[i].cursor.x = ends[0]->x;
    buffer->sels[i].cursor.saved_x = ends[0]->saved_x;
    buffer->sels[i].cursor.y = ends[0]->y;
    buffer->sels[i].anchor.x = x;
    buffer->sels[i].anchor.saved_x = saved_x;
    buffer->sels[i].anchor.y = y;
  }
  buffer->mode = MODE_INSERT;
}

void enter_normal_mode() {
  buffer->mode = MODE_NORMAL;
}

void enter_command_mode() {
  edit_mode = MENU_EDIT_MODE;
  menu_mode = COMMAND_MENU_MODE;
  buffer = menu_buffer_global;
  buffer->mode = MODE_INSERT;
}

void enter_search_mode() {
  edit_mode = MENU_EDIT_MODE;
  menu_mode = SEARCH_MENU_MODE;
  buffer = menu_buffer_global;
  buffer->mode = MODE_INSERT;
}

void process_menu_input() {
  switch (menu_mode) {
    case COMMAND_MENU_MODE: {
      // TODO
    } break;
    case SEARCH_MENU_MODE: {
      // TODO
    } break;
  }

  edit_mode = FILE_EDIT_MODE;
  buffer = file_buffer_global;
}

void enter_goto_mode_or_goto_line() {
  if (buffer->num_arg > 0) {
    if (buffer->num_arg + 1 >= buffer->num_lines) {
      buffer->num_arg = buffer->num_lines;
    }
    reduce_selections_to_primary();
    set_cursor_x(&buffer->sels[0].cursor, 0);
    set_cursor_x(&buffer->sels[0].anchor, 0);
    buffer->sels[0].cursor.y = buffer->num_arg - 1;
    buffer->sels[0].anchor.y = buffer->num_arg - 1;

    if (buffer->num_arg > tb_height()) {
      buffer->view_top = buffer->num_arg - tb_height();
    }
    else {
      buffer->view_top = 0;
    }
  }
  else {
    buffer->mode = MODE_GOTO;
  }
}

void goto_file_end() {
  buffer->num_arg = buffer->num_lines;
  enter_goto_mode_or_goto_line();
  buffer->mode = MODE_NORMAL;
}

void goto_file_start() {
  buffer->num_arg = 1;
  enter_goto_mode_or_goto_line();
  buffer->mode = MODE_NORMAL;
}

void enter_insert_in_new_line_below() {
  switch (edit_mode) {
    case FILE_EDIT_MODE: {
      Line new_line = {
        .content = malloc(sizeof(char) * 1),
        .len = 0,
        .cap = 1,
      };
      for (int i = 0; i < buffer->num_sels; i++) {
        insert_line(buffer, &new_line, buffer->sels[i].cursor.y + 1);
        buffer->sels[i].cursor.saved_x = 0;
        buffer->sels[i].cursor.x = 0;
        buffer->sels[i].cursor.y += 1;
      }
      reduce_selections_to_cursor();
      buffer->mode = MODE_INSERT;
    } break;

    case MENU_EDIT_MODE:
      return;
  }
}

void remove_selected_text() {
  for (int i = 0; i < buffer->num_sels; i++) {
    Cursor *ends[2] = { 0 };
    get_ordered_cursors(&buffer->sels[i], ends);
    int x = ends[0]->x;
    for (int y = ends[0]->y; y < ends[1]->y; y++) {
      remove_span(buffer, buffer->lines[y].len - x + 1, x, y);
      x = 0;
    }
    remove_span(buffer, ends[1]->x - x + 1, x, ends[1]->y);
    ends[1]->x = ends[0]->x;
    ends[1]->saved_x = ends[0]->saved_x;
    ends[1]->y = ends[0]->y;
  }
}

void move_cursors_down() {
  for (int i = 0; i < buffer->num_sels; i++) {
    Cursor *cursor = &buffer->sels[i].cursor;
    if (cursor->y < buffer->num_lines - 1) {
      set_cursor_y(cursor, cursor->y + 1, buffer->lines[cursor->y + 1].len);
      buffer->sels[i].anchor.x = cursor->x;
      buffer->sels[i].anchor.saved_x = cursor->saved_x;
      buffer->sels[i].anchor.y = cursor->y;
      if (cursor->y >= buffer->view_top + tb_height()) {
        buffer->view_top += 1;
      }
    }
  }
  // TODO: merge_overlapping_selections()
}

void move_cursors_up() {
  for (int i = 0; i < buffer->num_sels; i++) {
    Cursor *cursor = &buffer->sels[i].cursor;
    if (cursor->y > 0) {
      set_cursor_y(cursor, cursor->y - 1, buffer->lines[cursor->y - 1].len);
      buffer->sels[i].anchor.x = cursor->x;
      buffer->sels[i].anchor.saved_x = cursor->saved_x;
      buffer->sels[i].anchor.y = cursor->y;
      if (cursor->y < buffer->view_top) {
        buffer->view_top -= 1;
      }
    }
  }
  // TODO: merge_overlapping_selections()
}

void extend_selections_left() {
  for (int i = 0; i < buffer->num_sels; i++) {
    Cursor *cursor = &buffer->sels[i].cursor;
    if (cursor->x > 0) {
      set_cursor_x(cursor, cursor->x - 1);
    }
  }
  // TODO: merge_overlapping_selections()
}

void extend_selections_right() {
  for (int i = 0; i < buffer->num_sels; i++) {
    Cursor *cursor = &buffer->sels[i].cursor;
    if (cursor->x < buffer->lines[cursor->y].len) {
      set_cursor_x(cursor, cursor->x + 1);
    }
  }
  // TODO: merge_overlapping_selections()
}

void move_cursors_left() {
  extend_selections_left();
  reduce_selections_to_cursor();
}

void move_cursors_right() {
  extend_selections_right();
  reduce_selections_to_cursor();
}

void insert_at_every_cursor() {
  for (int i = 0; i < buffer->num_sels; i++) {
    Cursor *cursor = &buffer->sels[i].cursor;
    insert(&buffer->lines[cursor->y], (char *)&tb_event.ch, 1, cursor->x);
    set_cursor_x(cursor, cursor->x + 1);
    set_cursor_x(&buffer->sels[i].anchor, buffer->sels[i].anchor.x + 1);
  }
}

void backslash_n() {
  switch (edit_mode) {
    case FILE_EDIT_MODE: {
      for (int i = 0; i < buffer->num_sels; i++) {
        Cursor *cursor = &buffer->sels[i].cursor;
        Line line = {
          .content = malloc(sizeof(char) * cursor->x),
          .len = cursor->x,
          .cap = cursor->x,
        };
        memcpy(line.content, buffer->lines[cursor->y].content, cursor->x);
        remove_span(buffer, cursor->x, 0, cursor->y);
        insert_line(buffer, &line, cursor->y);

        set_cursor_x(cursor, 0);
        set_cursor_x(&buffer->sels[i].anchor, 0);
        buffer->sels[i].anchor.y += 1;
        cursor->y += 1;
      }
    } break;

    case MENU_EDIT_MODE: {
      switch (menu_mode) {
        case COMMAND_MENU_MODE: {
          // TODO
        } break;
        case SEARCH_MENU_MODE: {
          // TODO
        } break;
      }

      edit_mode = FILE_EDIT_MODE;
      buffer = file_buffer_global;
    } break;
  }
}

void backspace_at_every_cursor() {
  for (int i = 0; i < buffer->num_sels; i++) {
    Cursor *cursor = &buffer->sels[i].cursor;
    Cursor *anchor = &buffer->sels[i].anchor;
    if (cursor->x > 0) {
      remove_span(buffer, 1, cursor->x - 1, cursor->y);
      cursor->x -= 1;
      cursor->saved_x = cursor->x;
      anchor->x -= 1;
      anchor->saved_x = anchor->x;
    }
    else if (cursor->y > 0) {
      size_t saved_len = buffer->lines[buffer->sels[i].cursor.y - 1].len;
      remove_span(buffer, 1, saved_len, buffer->sels[i].cursor.y - 1);
      buffer->sels[i].cursor.y -= 1;
      buffer->sels[i].anchor.y -= 1;
      buffer->sels[i].cursor.x = saved_len;
      buffer->sels[i].cursor.saved_x = saved_len;
      buffer->sels[i].anchor.x = saved_len;
      buffer->sels[i].anchor.saved_x = saved_len;
    }
  }
}

void select_current_line() {
  for (int i = 0; i < buffer->num_sels; i++) {
    Cursor *ends[2];
    get_ordered_cursors(&buffer->sels[i], ends);
    set_cursor_x(ends[0], 0);
    set_cursor_x(ends[1], buffer->lines[ends[1]->y].len);
  }
}

void write_buffer_to_file() {
  int fd = open(file_buffer_global->file_path, O_CREAT | O_WRONLY | O_TRUNC);
  for (int i = 0; i < file_buffer_global->num_lines; i++) {
    write(fd, file_buffer_global->lines[i].content, file_buffer_global->lines[i].len);
    write(fd, "\n", 1);
  }
  close(fd);
}

// Does not support unicode
OperationList mappings_ch[NUM_MODES][TB_MOD_ALT + TB_MOD_CTRL + 1][95];
OperationList mappings_backspace[NUM_MODES];

int main(int argc, char **argv) {
  buf_op_arena = malloc(sizeof(BufferOperation) * cap_buf_ops);

  for (int i = ' '; i <= '~'; i++) {
    init_operation_list(&mappings_ch[MODE_INSERT][0][i - ' '], 1, insert_at_every_cursor);
  }
  init_operation_list(&mappings_ch[MODE_NORMAL][0]['i' - ' '], 1, enter_insert_mode);
  init_operation_list(&mappings_ch[MODE_NORMAL][0]['g' - ' '], 1, enter_goto_mode_or_goto_line);
  init_operation_list(&mappings_ch[MODE_NORMAL][0][':' - ' '], 1, enter_command_mode);
  init_operation_list(&mappings_ch[MODE_NORMAL][0]['/' - ' '], 1, enter_search_mode);
  init_operation_list(&mappings_ch[MODE_NORMAL][0]['o' - ' '], 1, enter_insert_in_new_line_below);
  init_operation_list(&mappings_ch[MODE_NORMAL][0]['d' - ' '], 1, remove_selected_text);
  init_operation_list(&mappings_ch[MODE_NORMAL][0]['c' - ' '], 2, remove_selected_text, enter_insert_mode);
  init_operation_list(&mappings_ch[MODE_NORMAL][0]['j' - ' '], 1, move_cursors_down);
  init_operation_list(&mappings_ch[MODE_NORMAL][0]['k' - ' '], 1, move_cursors_up);
  init_operation_list(&mappings_ch[MODE_NORMAL][0]['h' - ' '], 1, move_cursors_left);
  init_operation_list(&mappings_ch[MODE_NORMAL][0]['H' - ' '], 1, extend_selections_left);
  init_operation_list(&mappings_ch[MODE_NORMAL][0]['l' - ' '], 1, move_cursors_right);
  init_operation_list(&mappings_ch[MODE_NORMAL][0]['L' - ' '], 1, extend_selections_right);
  init_operation_list(&mappings_ch[MODE_NORMAL][0]['x' - ' '], 1, select_current_line);
  init_operation_list(&mappings_ch[MODE_NORMAL][TB_MOD_CTRL]['q' - ' '], 1, shutdown);
  init_operation_list(&mappings_ch[MODE_NORMAL][TB_MOD_CTRL]['{' - ' '], 1, write_buffer_to_file); // Escape
  init_operation_list(&mappings_ch[MODE_INSERT][TB_MOD_CTRL]['{' - ' '], 1, enter_normal_mode); // Escape
  init_operation_list(&mappings_ch[MODE_INSERT][TB_MOD_CTRL]['{' - ' '], 1, enter_normal_mode); // Escape
  init_operation_list(&mappings_ch[MODE_INSERT][TB_MOD_CTRL]['m' - ' '], 1, backslash_n); // Enter
  init_operation_list(&mappings_ch[MODE_INSERT][TB_MOD_CTRL]['m' - ' '], 1, process_menu_input); // Enter
  init_operation_list(&mappings_backspace[MODE_INSERT], 1, backspace_at_every_cursor);
  init_operation_list(&mappings_ch[MODE_GOTO][0]['e' - ' '], 1, goto_file_end);
  init_operation_list(&mappings_ch[MODE_GOTO][0]['g' - ' '], 1, goto_file_start);

  if (argc > 2 || argc < 2) {
    printf("Invalid parameters\n");
    printf("Usage: %s [FILE]\n", argv[0]);
    exit(EXIT_FAILURE);
  }

  Buffer file_buffer = {
    .lines = malloc(sizeof(Line) * 1),
    .num_lines = 0,
    .cap_lines = 1,
    .sels = calloc(1, sizeof(Selection)),
    .num_sels = 1,
    .cap_sels = 1,
    .view_top = 0,
    .mode = MODE_NORMAL,
    .file_path = argv[1],
  };
  Buffer menu_buffer = {
    .lines = malloc(sizeof(Line) * 1),
    .num_lines = 1,
    .cap_lines = 1,
    .sels = calloc(1, sizeof(Selection)),
    .num_sels = 1,
    .cap_sels = 1,
    .view_top = 0,
    .mode = MODE_NORMAL,
    .file_path = argv[1],
  };
  menu_buffer.lines[0].content = malloc(sizeof(char) * 1);
  menu_buffer.lines[0].len = 0;
  menu_buffer.lines[0].cap = 1;

  buffer = &file_buffer;
  file_buffer_global = &file_buffer;
  menu_buffer_global = &menu_buffer;

  {
    FILE *file = fopen(buffer->file_path, "a+");
    if (file == NULL) {
      perror("Couldn't open file for reading");
      exit(1);
    }
    Line line = {
     .content = malloc(sizeof(char) * 1),
     .len = 0,
     .cap = 1,
    };

    size_t current_y = 0;
    size_t current_x = 0;
    char c;
    int messed_with = 0;
    while ((c = fgetc(file)) != EOF) {
      messed_with = 1;
      if (c == '\r') continue;
      if (c == '\n' || c == '\0') {
        insert_line(buffer, &line, current_y);
        current_y += 1;
        current_x = 0;

        line.len = 0;
        line.cap = 0;
        line.content = malloc(sizeof(char) * 1);
        continue;
      }
      insert(&line, &c, 1, current_x);
      current_x += 1;
    }
    if (!messed_with) {
      insert_line(buffer, &line, current_y);
    }
    fclose(file);
  }

  int tb_init_ret = tb_init();
  if (tb_init_ret) {
    fprintf(stderr, "tb_init() failed with error code %d\n", tb_init_ret);
    exit(EXIT_FAILURE);
  }

  tb_set_input_mode(TB_INPUT_ALT | TB_INPUT_MOUSE);

  draw_buffer(&file_buffer, 0, 0, tb_height() - 1);

  while (tb_poll_event(&tb_event) == TB_OK) {
    switch (tb_event.type) {
      case TB_EVENT_KEY: {
        if (tb_event.ch >= '0' && tb_event.ch <= '9' && buffer->mode == MODE_NORMAL) {
          buffer->num_arg *= 10;
          buffer->num_arg += tb_event.ch - '0';
        }
        else if (tb_event.ch >= ' ' && tb_event.ch <= '~') {
          OperationList *op_list = &mappings_ch[buffer->mode][tb_event.mod][tb_event.ch - ' '];
          if (op_list->num_ops > 0) {
            for (int i = 0; i < op_list->num_ops; i++) {
              op_list->ops[i]();
            }
          }
          buffer->num_arg = 0;
        }
        else if (tb_event.key >= TB_KEY_CTRL_A && tb_event.key <= TB_KEY_SPACE) {
          OperationList *op_list = &mappings_ch[buffer->mode][tb_event.mod][tb_event.key + 'A' - 1];
          if (op_list->num_ops > 0) {
            for (int i = 0; i < op_list->num_ops; i++) {
              op_list->ops[i]();
            }
          }
          buffer->num_arg = 0;
        }
        else if (tb_event.key == TB_KEY_BACKSPACE2) {
          OperationList *op_list = &mappings_backspace[buffer->mode];
          if (op_list->num_ops > 0) {
            for (int i = 0; i < op_list->num_ops; i++) {
              op_list->ops[i]();
            }
          }
          buffer->num_arg = 0;
        }
      } break;
    }

    tb_clear();
    draw_buffer(&file_buffer, 0, 0, tb_height() - 1);
    if (edit_mode == MENU_EDIT_MODE) {
      switch (menu_mode) {
        case COMMAND_MENU_MODE:
          tb_printf(0, tb_height() - 1, TB_WHITE, 0, ":");
          draw_buffer(&menu_buffer, 1, tb_height() - 1, 1);
          break;
        case SEARCH_MENU_MODE:
          tb_printf(0, tb_height() - 1, TB_WHITE, 0, "Search:");
          draw_buffer(&menu_buffer, 7, tb_height() - 1, 1);
          break;
      }
    }
  }

  tb_shutdown();

  return 0;
}

// TODO: Support Unicode
// TODO: Make mappings contiguous in memory
// TODO: Improve input handling in termbox2.h
// TODO: Fix program closing when window resizes
// TODO: Support Kitty's input protocol
// TODO: Make moving back or forth past line edges go to next/previous lines
