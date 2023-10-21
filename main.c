#include <stdarg.h>

#define TB_IMPL
#include "termbox2.h"

typedef enum {
  MODE_NORMAL,
  MODE_INSERT,
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

  Mode mode;

  const char *file_path;
} Buffer;

typedef void (*BufferOperation)(Buffer *buffer);
typedef struct {
  BufferOperation *ops;
  size_t num_ops;
} OperationList;
void init_operation_list(OperationList *op_list, int num_ops, ...) {
  op_list->ops = malloc(sizeof(BufferOperation) * num_ops);

  va_list args;
  va_start(args, num_ops);
  for (int i = 0; i < num_ops; i++) {
    op_list->ops[i] = va_arg(args, BufferOperation);
  }
  op_list->num_ops = num_ops;

  va_end(args);
}

struct tb_event tb_event;

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

void draw_terminal(Buffer *buffer) {
  tb_clear();

  for (int i = buffer->view_top; i < buffer->view_top + tb_height() && i < buffer->num_lines; i++) {
    tb_print_len(0, i - buffer->view_top, TB_WHITE, 0, buffer->lines[i].content, buffer->lines[i].len);
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
        if (x == buffer->lines[y].len) tb_set_cell(x, y - buffer->view_top, 0, 0, color);
        else tb_set_cell(x, y - buffer->view_top, buffer->lines[y].content[x], 0, color);
      }
      x = 0;
    }
    // TODO: You could probably pull out the y from the first for loop and reuse the code with no alterations, but I'm tired
    for (; x <= ends[1]->x; x++) { 
      if (x == buffer->lines[ends[1]->y].len) tb_set_cell(x, ends[1]->y - buffer->view_top, 0, 0, color);
      else tb_set_cell(x, ends[1]->y - buffer->view_top, buffer->lines[ends[1]->y].content[x], 0, color);
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

void shutdown(Buffer *buffer) {
  tb_shutdown();

  exit(EXIT_SUCCESS);
}

void enter_insert_mode(Buffer *buffer) {
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

void enter_normal_mode(Buffer *buffer) {
  buffer->mode = MODE_NORMAL;
}

void enter_insert_in_new_line_below(Buffer *buffer) {
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
  buffer->mode = MODE_INSERT;
}

void remove_selected_text(Buffer *buffer) {
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

void move_cursors_down(Buffer *buffer) {
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

void move_cursors_up(Buffer *buffer) {
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

void reduce_selections_to_cursor(Buffer *buffer) {
  for (int i = 0; i < buffer->num_sels; i++) {
    buffer->sels[i].anchor.x = buffer->sels[i].cursor.x;
    buffer->sels[i].anchor.saved_x = buffer->sels[i].cursor.saved_x;
    buffer->sels[i].anchor.y = buffer->sels[i].cursor.y;
  }
}

void extend_selections_left(Buffer *buffer) {
  for (int i = 0; i < buffer->num_sels; i++) {
    Cursor *cursor = &buffer->sels[i].cursor;
    if (cursor->x > 0) {
      set_cursor_x(cursor, cursor->x - 1);
    }
  }
  // TODO: merge_overlapping_selections()
}

void extend_selections_right(Buffer *buffer) {
  for (int i = 0; i < buffer->num_sels; i++) {
    Cursor *cursor = &buffer->sels[i].cursor;
    if (cursor->x < buffer->lines[cursor->y].len) {
      set_cursor_x(cursor, cursor->x + 1);
    }
  }
  // TODO: merge_overlapping_selections()
}

void move_cursors_left(Buffer *buffer) {
  extend_selections_left(buffer);
  reduce_selections_to_cursor(buffer);
}

void move_cursors_right(Buffer *buffer) {
  extend_selections_right(buffer);
  reduce_selections_to_cursor(buffer);
}

void insert_at_every_cursor(Buffer *buffer) {
  for (int i = 0; i < buffer->num_sels; i++) {
    Cursor *cursor = &buffer->sels[i].cursor;
    insert(&buffer->lines[cursor->y], (char *)&tb_event.ch, 1, cursor->x);
    set_cursor_x(cursor, cursor->x + 1);
    set_cursor_x(&buffer->sels[i].anchor, buffer->sels[i].anchor.x + 1);
  }
}

void backspace_at_every_cursor(Buffer *buffer) {
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
  }
}

void write_buffer_to_file(Buffer *buffer) {
  int fd = open(buffer->file_path, O_CREAT | O_WRONLY | O_TRUNC);
  for (int i = 0; i < buffer->num_lines; i++) {
    write(fd, buffer->lines[i].content, buffer->lines[i].len);
    write(fd, "\n", 1);
  }
  close(fd);
}

// Does not support unicode
OperationList mappings_ch[NUM_MODES][TB_MOD_ALT + TB_MOD_CTRL + 1][95];
OperationList mappings_backspace[NUM_MODES];

int main(int argc, char **argv) {
  for (int i = ' '; i <= '~'; i++) {
    init_operation_list(&mappings_ch[MODE_INSERT][0][i - ' '], 1, insert_at_every_cursor);
  }
  init_operation_list(&mappings_ch[MODE_NORMAL][0]['i' - ' '], 1, enter_insert_mode);
  init_operation_list(&mappings_ch[MODE_NORMAL][0]['o' - ' '], 1, enter_insert_in_new_line_below);
  init_operation_list(&mappings_ch[MODE_NORMAL][0]['d' - ' '], 1, remove_selected_text);
  init_operation_list(&mappings_ch[MODE_NORMAL][0]['c' - ' '], 2, remove_selected_text, enter_insert_mode);
  init_operation_list(&mappings_ch[MODE_NORMAL][0]['j' - ' '], 1, move_cursors_down);
  init_operation_list(&mappings_ch[MODE_NORMAL][0]['k' - ' '], 1, move_cursors_up);
  init_operation_list(&mappings_ch[MODE_NORMAL][0]['h' - ' '], 1, move_cursors_left);
  init_operation_list(&mappings_ch[MODE_NORMAL][0]['H' - ' '], 1, extend_selections_left);
  init_operation_list(&mappings_ch[MODE_NORMAL][0]['l' - ' '], 1, move_cursors_right);
  init_operation_list(&mappings_ch[MODE_NORMAL][0]['L' - ' '], 1, extend_selections_right);
  init_operation_list(&mappings_ch[MODE_NORMAL][TB_MOD_CTRL]['q' - ' '], 1, shutdown);
  init_operation_list(&mappings_ch[MODE_NORMAL][TB_MOD_CTRL]['q' - ' '], 1, shutdown);
  init_operation_list(&mappings_ch[MODE_NORMAL][TB_MOD_CTRL]['{' - ' '], 1, write_buffer_to_file); // Escape
  init_operation_list(&mappings_ch[MODE_INSERT][TB_MOD_CTRL]['{' - ' '], 1, enter_normal_mode); // Escape
  init_operation_list(&mappings_backspace[MODE_INSERT], 1, backspace_at_every_cursor);

  if (argc > 2 || argc < 2) {
    printf("Invalid parameters\n");
    printf("Usage: %s [FILE]\n", argv[0]);
    exit(EXIT_FAILURE);
  }

  Buffer buffer = {
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

  {
    FILE *file = fopen(buffer.file_path, "a+");
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
        insert_line(&buffer, &line, current_y);
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
      insert_line(&buffer, &line, current_y);
    }
    fclose(file);

  }

  int tb_init_ret = tb_init();
  if (tb_init_ret) {
    fprintf(stderr, "tb_init() failed with error code %d\n", tb_init_ret);
    exit(EXIT_FAILURE);
  }

  tb_set_input_mode(TB_INPUT_ALT | TB_INPUT_MOUSE);

  draw_terminal(&buffer);
  while (tb_poll_event(&tb_event) == TB_OK) {
    switch (tb_event.type) {
      case TB_EVENT_KEY: {
        if (tb_event.ch >= ' ' && tb_event.ch <= '~') {
          OperationList *op_list = &mappings_ch[buffer.mode][tb_event.mod][tb_event.ch - ' '];
          if (op_list->num_ops > 0) {
            for (int i = 0; i < op_list->num_ops; i++) {
              op_list->ops[i](&buffer);
            }
          }
        }
        else if (tb_event.key >= TB_KEY_CTRL_A && tb_event.key <= TB_KEY_SPACE) {
          OperationList *op_list = &mappings_ch[buffer.mode][tb_event.mod][tb_event.key + 'A' - 1];
          if (op_list->num_ops > 0) {
            for (int i = 0; i < op_list->num_ops; i++) {
              op_list->ops[i](&buffer);
            }
          }
        }
        else if (tb_event.key == TB_KEY_BACKSPACE2) {
          OperationList *op_list = &mappings_backspace[buffer.mode];
          if (op_list->num_ops > 0) {
            for (int i = 0; i < op_list->num_ops; i++) {
              op_list->ops[i](&buffer);
            }
          }
        }
      } break;
    }
    draw_terminal(&buffer);
  }

  shutdown(&buffer);
}

// TODO: Support Unicode
// TODO: Make mappings contiguous in memory
// TODO: Improve input handling in termbox2.h
// TODO: Fix program closing when window resizes
