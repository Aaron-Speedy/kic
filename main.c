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
  char *str;
  size_t len;
  size_t cap;
} Line;

typedef struct {
  size_t x;
  size_t sx;
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

typedef void (*Operation)();

typedef struct {
  Operation *ops;
  size_t num_ops;
} OpList;

typedef struct {
  char *name;
  size_t len_name;
  OpList op_list;
} Command;

Buffer *buf;
Buffer *file_buf_global;
Buffer *menu_buf_global;

Command *cmd_list;
size_t num_cmds = 0;
size_t cap_cmds = 1000;

Operation *op_arena;
size_t op_arena_len = 0;
size_t op_arena_cap = 1000;

enum {
  FILE_EDIT_MODE,
  MENU_EDIT_MODE,
} edit_mode = FILE_EDIT_MODE;

enum {
  COMMAND_MENU_MODE,
  SEARCH_MENU_MODE,
} menu_mode = 0;

struct tb_event tb_event;

void v_init_op_list(OpList *op_list, size_t num_ops, va_list ops) {
  if (op_arena_len > op_arena_cap) {
    op_arena_cap *= 2;
    Operation *new_arena = realloc(op_arena, sizeof(Operation) * op_arena_cap);
    if (new_arena == NULL) {
      perror("Could not realloc op_arena for appending");
      exit(EXIT_FAILURE);
    }
    op_arena = new_arena;
  }
  op_arena_len += 1;

  op_list->ops = &op_arena[op_arena_len - 1];
  for (int i = 0; i < num_ops; i++) {
    op_list->ops[i] = va_arg(ops, Operation);
  }
  op_list->num_ops = num_ops;
}

void init_op_list(OpList *op_list, size_t num_ops, ...) {
  va_list ops;
  va_start(ops, num_ops);
  v_init_op_list(op_list, num_ops, ops);
  va_end(ops);
}

#define szstr(str) str, sizeof(str) - 1
void push_command(char *name, size_t len_name, size_t num_ops, ...) {
  if (num_cmds > cap_cmds) {
    cap_cmds *= 2;
    Command *new_cmd_list = realloc(cmd_list, sizeof(Command) * cap_cmds);
    if (new_cmd_list == NULL) {
      perror("Could not realloc cmd_list for appending");
      exit(EXIT_FAILURE);
    }
    cmd_list = new_cmd_list;
  }
  num_cmds += 1;

  va_list ops;
  va_start(ops, num_ops);
  v_init_op_list(&cmd_list[num_cmds - 1].op_list, num_ops, ops);
  va_end(ops);
  cmd_list[num_cmds - 1].name = name;
  cmd_list[num_cmds - 1].len_name = len_name;
}

// TODO: pop_command

void get_ordered_cursors(Selection *sel, Cursor **buf) {
  if (sel->anchor.y < sel->cursor.y) {
    buf[0] = &sel->anchor;
    buf[1] = &sel->cursor;
    return;
  };
  if (sel->anchor.y > sel->cursor.y) {
    buf[0] = &sel->cursor;
    buf[1] = &sel->anchor;
    return;
  };
  if (sel->anchor.x <= sel->cursor.x) {
    buf[0] = &sel->anchor;
    buf[1] = &sel->cursor;
    return;
  };
  buf[0] = &sel->cursor, buf[1] = &sel->anchor;
}

void insert(Line *line, char *str, size_t str_len, size_t x) {
  if (line->len + str_len >= line->cap) {
    line->cap = line->len * 2 + str_len;
    char *new_str = realloc(line->str, sizeof(char) * line->cap);

    if (new_str == NULL) {
      perror("Could not realloc line->str for inserting");
      exit(EXIT_FAILURE);
    }

    line->str = new_str;
  }

  memmove(
    &line->str[x + str_len],
    &line->str[x],
    sizeof(char) * (line->len - x)
  );
  memcpy(&line->str[x], str, sizeof(char) * str_len);
  line->len += str_len;
}

void insert_line(Buffer *buf, Line *line, size_t y) {
  if (buf->num_lines + 1 >= buf->cap_lines) {
    buf->cap_lines = buf->num_lines * 2 + 1;
    Line *new_buf_lines = realloc(
      buf->lines, 
      sizeof(Line) * buf->cap_lines
    );
    if (new_buf_lines == NULL) {
      perror("Could not realloc buf->lines for inserting a line");
    }

    buf->lines = new_buf_lines;
  }

  memmove(
    &buf->lines[y + 1],
    &buf->lines[y],
    sizeof(Line) * (buf->num_lines - y)
  );
  buf->lines[y].str = line->str;
  buf->lines[y].len = line->len;
  buf->lines[y].cap = line->len;
  buf->num_lines += 1;
}

void remove_span(Buffer *buf, size_t len, size_t x, size_t y) {
  if (x - 1 + len == buf->lines[y].len) {
    if (y < buf->num_lines - 1) {
      insert(
        &buf->lines[y],
        buf->lines[y + 1].str,
        buf->lines[y + 1].len,
        x
      );
      free(buf->lines[y + 1].str);
      memmove(
        &buf->lines[y + 1],
        &buf->lines[y + 2],
        sizeof(Line) * (buf->num_lines - y)
      );
      buf->num_lines -= 1;
    }
    len -= 1;
  }
  memmove(
    &buf->lines[y].str[x],
    &buf->lines[y].str[x + len],
    sizeof(char) * (buf->lines[y].len - x - len));
  buf->lines[y].len -= len;
}

void draw_buf(Buffer *buf, size_t draw_x, size_t draw_y, size_t height) {
  size_t view_top = buf->view_top;

  for (int i = view_top; i < view_top + height && i < buf->num_lines; i++) {
    tb_print_len(
      draw_x, i - view_top + draw_y, 
      TB_WHITE, 0, 
      buf->lines[i].str,
      buf->lines[i].len
    );
  }

  uintattr_t color = 0;
  if (buf->mode == MODE_INSERT) color = TB_RED;
  if (buf->mode == MODE_NORMAL) color = TB_BLUE;
  for (int i = 0; i < buf->num_sels; i++) {
    Cursor *ends[2] = { 0 };
    get_ordered_cursors(&buf->sels[i], ends);
    int x = ends[0]->x;
    for (int y = ends[0]->y; y < ends[1]->y; y++) {
      for (; x <= buf->lines[y].len; x++) {
        if (x == buf->lines[y].len) {
          tb_set_cell(x + draw_x, y - view_top + draw_y, 0, 0, color);
        }
        else {
          tb_set_cell(
            x + draw_x, y - view_top + draw_y,
            buf->lines[y].str[x],
            0, color
          );
        }
      }
      x = 0;
    }
    // TODO: You could probably pull out the y from the first for loop and reuse the code with no alterations, but I'm tired
    for (; x <= ends[1]->x; x++) { 
      if (x == buf->lines[ends[1]->y].len) {
        tb_set_cell(
          x + draw_x, ends[1]->y - view_top + draw_y, 
          0, 0,
          color
        );
      }
      else {
        tb_set_cell(
          x + draw_x, ends[1]->y - view_top + draw_y, 
          buf->lines[ends[1]->y].str[x],
          0, color
        );
      }
    }
  }

  tb_present();
}

void set_cursor_x(Cursor *cursor, size_t new_cursor_x) {
  cursor->x = new_cursor_x;
  cursor->sx = cursor->x;
}

void set_cursor_y(Cursor *cursor, size_t new_cursor_y, size_t new_line_len) {
  cursor->y = new_cursor_y;
  cursor->x = cursor->sx > new_line_len ? new_line_len : cursor->sx;
}

void shutdown() {
  tb_shutdown();

  exit(EXIT_SUCCESS);
}

void reduce_selections_to_cursor() {
  for (int i = 0; i < buf->num_sels; i++) {
    buf->sels[i].anchor.x = buf->sels[i].cursor.x;
    buf->sels[i].anchor.sx = buf->sels[i].cursor.sx;
    buf->sels[i].anchor.y = buf->sels[i].cursor.y;
  }
}

void reduce_selections_to_primary() {
  buf->num_sels = 1;
  buf->sels[0].cursor.x = buf->sels[buf->primary_sel].cursor.x;
  buf->sels[0].cursor.sx = buf->sels[buf->primary_sel].cursor.sx;
  buf->sels[0].cursor.y = buf->sels[buf->primary_sel].cursor.y;
  buf->sels[0].anchor.x = buf->sels[buf->primary_sel].anchor.x;
  buf->sels[0].anchor.sx = buf->sels[buf->primary_sel].anchor.sx;
  buf->sels[0].anchor.y = buf->sels[buf->primary_sel].anchor.y;
}

void enter_insert_mode() {
  for (int i = 0; i < buf->num_sels; i++) {
    Cursor *ends[2] = { 0 };
    get_ordered_cursors(&buf->sels[i], ends);

    size_t x = ends[1]->x, sx = ends[1]->x, y = ends[1]->y;
    buf->sels[i].cursor.x = ends[0]->x;
    buf->sels[i].cursor.sx = ends[0]->sx;
    buf->sels[i].cursor.y = ends[0]->y;
    buf->sels[i].anchor.x = x;
    buf->sels[i].anchor.sx = sx;
    buf->sels[i].anchor.y = y;
  }
  buf->mode = MODE_INSERT;
}

void enter_normal_mode() {
  buf->mode = MODE_NORMAL;
}

void enter_command_mode() {
  edit_mode = MENU_EDIT_MODE;
  menu_mode = COMMAND_MENU_MODE;
  buf = menu_buf_global;
  buf->mode = MODE_INSERT;
}

void enter_search_mode() {
  edit_mode = MENU_EDIT_MODE;
  menu_mode = SEARCH_MENU_MODE;
  buf = menu_buf_global;
  buf->mode = MODE_INSERT;
}

void process_menu_input() {
  switch (menu_mode) {
    case COMMAND_MENU_MODE: {
      int found = 0;
      for (int i = num_cmds - 1; i >= 0 && !found; i--) {
        if (!strncmp(menu_buf_global->lines[0].str, 
                     cmd_list[i].name, cmd_list[i].len_name)) {
          found = 1;
          for (int j = 0; j < cmd_list[i].op_list.num_ops; j++) {
            cmd_list[i].op_list.ops[j]();
          }
        }
      }
    } break;
    case SEARCH_MENU_MODE: {
      // TODO
    } break;
  }

  edit_mode = FILE_EDIT_MODE;
  buf = file_buf_global;
}

void enter_goto_mode_or_goto_line() {
  if (buf->num_arg > 0) {
    if (buf->num_arg + 1 >= buf->num_lines) {
      buf->num_arg = buf->num_lines;
    }
    reduce_selections_to_primary();
    set_cursor_x(&buf->sels[0].cursor, 0);
    set_cursor_x(&buf->sels[0].anchor, 0);
    buf->sels[0].cursor.y = buf->num_arg - 1;
    buf->sels[0].anchor.y = buf->num_arg - 1;

    if (buf->num_arg > tb_height()) {
      buf->view_top = buf->num_arg - tb_height();
    }
    else {
      buf->view_top = 0;
    }
  }
  else {
    buf->mode = MODE_GOTO;
  }
}

void goto_file_end() {
  buf->num_arg = buf->num_lines;
  enter_goto_mode_or_goto_line();
  buf->mode = MODE_NORMAL;
}

void goto_file_start() {
  buf->num_arg = 1;
  enter_goto_mode_or_goto_line();
  buf->mode = MODE_NORMAL;
}

void enter_insert_in_new_line_below() {
  switch (edit_mode) {
    case FILE_EDIT_MODE: {
      Line new_line = {
        .str = malloc(sizeof(char) * 1),
        .len = 0,
        .cap = 1,
      };
      for (int i = 0; i < buf->num_sels; i++) {
        insert_line(buf, &new_line, buf->sels[i].cursor.y + 1);
        buf->sels[i].cursor.sx = 0;
        buf->sels[i].cursor.x = 0;
        buf->sels[i].cursor.y += 1;
      }
      reduce_selections_to_cursor();
      buf->mode = MODE_INSERT;
    } break;

    case MENU_EDIT_MODE:
      return;
  }
}

void remove_selected_text() {
  for (int i = 0; i < buf->num_sels; i++) {
    Cursor *ends[2] = { 0 };
    get_ordered_cursors(&buf->sels[i], ends);
    int x = ends[0]->x;
    for (int y = ends[0]->y; y < ends[1]->y; y++) {
      remove_span(buf, buf->lines[y].len - x + 1, x, y);
      x = 0;
    }
    remove_span(buf, ends[1]->x - x + 1, x, ends[1]->y);
    ends[1]->x = ends[0]->x;
    ends[1]->sx = ends[0]->sx;
    ends[1]->y = ends[0]->y;
  }
}

void move_cursors_down() {
  for (int i = 0; i < buf->num_sels; i++) {
    Cursor *cursor = &buf->sels[i].cursor;
    if (cursor->y < buf->num_lines - 1) {
      set_cursor_y(cursor, cursor->y + 1, buf->lines[cursor->y + 1].len);
      buf->sels[i].anchor.x = cursor->x;
      buf->sels[i].anchor.sx = cursor->sx;
      buf->sels[i].anchor.y = cursor->y;
      if (cursor->y >= buf->view_top + tb_height()) {
        buf->view_top += 1;
      }
    }
  }
  // TODO: merge_overlapping_selections()
}

void move_cursors_up() {
  for (int i = 0; i < buf->num_sels; i++) {
    Cursor *cursor = &buf->sels[i].cursor;
    if (cursor->y > 0) {
      set_cursor_y(cursor, cursor->y - 1, buf->lines[cursor->y - 1].len);
      buf->sels[i].anchor.x = cursor->x;
      buf->sels[i].anchor.sx = cursor->sx;
      buf->sels[i].anchor.y = cursor->y;
      if (cursor->y < buf->view_top) {
        buf->view_top -= 1;
      }
    }
  }
  // TODO: merge_overlapping_selections()
}

void extend_selections_left() {
  for (int i = 0; i < buf->num_sels; i++) {
    Cursor *cursor = &buf->sels[i].cursor;
    if (cursor->x > 0) {
      set_cursor_x(cursor, cursor->x - 1);
    }
  }
  // TODO: merge_overlapping_selections()
}

void extend_selections_right() {
  for (int i = 0; i < buf->num_sels; i++) {
    Cursor *cursor = &buf->sels[i].cursor;
    if (cursor->x < buf->lines[cursor->y].len) {
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
  for (int i = 0; i < buf->num_sels; i++) {
    Cursor *cursor = &buf->sels[i].cursor;
    insert(&buf->lines[cursor->y], (char *)&tb_event.ch, 1, cursor->x);
    set_cursor_x(cursor, cursor->x + 1);
    set_cursor_x(&buf->sels[i].anchor, buf->sels[i].anchor.x + 1);
  }
}

void backslash_n() {
  switch (edit_mode) {
    case FILE_EDIT_MODE: {
      for (int i = 0; i < buf->num_sels; i++) {
        Cursor *cursor = &buf->sels[i].cursor;
        Line line = {
          .str = malloc(sizeof(char) * cursor->x),
          .len = cursor->x,
          .cap = cursor->x,
        };
        memcpy(line.str, buf->lines[cursor->y].str, cursor->x);
        remove_span(buf, cursor->x, 0, cursor->y);
        insert_line(buf, &line, cursor->y);

        set_cursor_x(cursor, 0);
        set_cursor_x(&buf->sels[i].anchor, 0);
        buf->sels[i].anchor.y += 1;
        cursor->y += 1;
      }
    } break;

    case MENU_EDIT_MODE: {
      process_menu_input();
    } break;
  }
}

void backspace_at_every_cursor() {
  for (int i = 0; i < buf->num_sels; i++) {
    Cursor *cursor = &buf->sels[i].cursor;
    Cursor *anchor = &buf->sels[i].anchor;
    if (cursor->x > 0) {
      remove_span(buf, 1, cursor->x - 1, cursor->y);
      cursor->x -= 1;
      cursor->sx = cursor->x;
      anchor->x -= 1;
      anchor->sx = anchor->x;
    }
    else if (cursor->y > 0) {
      size_t saved_len = buf->lines[buf->sels[i].cursor.y - 1].len;
      remove_span(buf, 1, saved_len, buf->sels[i].cursor.y - 1);
      buf->sels[i].cursor.y -= 1;
      buf->sels[i].anchor.y -= 1;
      buf->sels[i].cursor.x = saved_len;
      buf->sels[i].cursor.sx = saved_len;
      buf->sels[i].anchor.x = saved_len;
      buf->sels[i].anchor.sx = saved_len;
    }
  }
}

void select_current_line() {
  for (int i = 0; i < buf->num_sels; i++) {
    Cursor *ends[2];
    get_ordered_cursors(&buf->sels[i], ends);
    set_cursor_x(ends[0], 0);
    set_cursor_x(ends[1], buf->lines[ends[1]->y].len);
  }
}

void write_buf_to_file() {
  int fd = open(file_buf_global->file_path, O_CREAT | O_WRONLY | O_TRUNC);
  for (int i = 0; i < file_buf_global->num_lines; i++) {
    write(fd, file_buf_global->lines[i].str, file_buf_global->lines[i].len);
    write(fd, "\n", 1);
  }
  close(fd);
}

// Does not support unicode
OpList maps_ch[NUM_MODES][TB_MOD_ALT + TB_MOD_CTRL + 1][95];
OpList maps_backspace[NUM_MODES];

int main(int argc, char **argv) {
  op_arena = malloc(sizeof(Operation) * op_arena_cap);
  cmd_list = malloc(sizeof(Command) * cap_cmds);

  for (int i = ' '; i <= '~'; i++) {
    init_op_list(&maps_ch[MODE_INSERT][0][i - ' '], 1, insert_at_every_cursor);
  }
  init_op_list(&maps_ch[MODE_NORMAL][0]['i' - ' '], 1, enter_insert_mode);
  init_op_list(&maps_ch[MODE_NORMAL][0]['g' - ' '], 1, enter_goto_mode_or_goto_line);
  init_op_list(&maps_ch[MODE_NORMAL][0][':' - ' '], 1, enter_command_mode);
  init_op_list(&maps_ch[MODE_NORMAL][0]['/' - ' '], 1, enter_search_mode);
  init_op_list(&maps_ch[MODE_NORMAL][0]['o' - ' '], 1, enter_insert_in_new_line_below);
  init_op_list(&maps_ch[MODE_NORMAL][0]['d' - ' '], 1, remove_selected_text);
  init_op_list(&maps_ch[MODE_NORMAL][0]['c' - ' '], 2, remove_selected_text, enter_insert_mode);
  init_op_list(&maps_ch[MODE_NORMAL][0]['j' - ' '], 1, move_cursors_down);
  init_op_list(&maps_ch[MODE_NORMAL][0]['k' - ' '], 1, move_cursors_up);
  init_op_list(&maps_ch[MODE_NORMAL][0]['h' - ' '], 1, move_cursors_left);
  init_op_list(&maps_ch[MODE_NORMAL][0]['H' - ' '], 1, extend_selections_left);
  init_op_list(&maps_ch[MODE_NORMAL][0]['l' - ' '], 1, move_cursors_right);
  init_op_list(&maps_ch[MODE_NORMAL][0]['L' - ' '], 1, extend_selections_right);
  init_op_list(&maps_ch[MODE_NORMAL][0]['x' - ' '], 1, select_current_line);
  init_op_list(&maps_ch[MODE_NORMAL][TB_MOD_CTRL]['{' - ' '], 1, write_buf_to_file); // Escape
  init_op_list(&maps_ch[MODE_INSERT][TB_MOD_CTRL]['{' - ' '], 1, enter_normal_mode); // Escape
  init_op_list(&maps_ch[MODE_GOTO][TB_MOD_CTRL]['{' - ' '], 1, enter_normal_mode); // Escape
  init_op_list(&maps_ch[MODE_INSERT][TB_MOD_CTRL]['m' - ' '], 1, backslash_n); // Enter
  init_op_list(&maps_ch[MODE_NORMAL][TB_MOD_CTRL]['m' - ' '], 1, process_menu_input); // Enter
  init_op_list(&maps_backspace[MODE_INSERT], 1, backspace_at_every_cursor);
  init_op_list(&maps_ch[MODE_GOTO][0]['e' - ' '], 1, goto_file_end);
  init_op_list(&maps_ch[MODE_GOTO][0]['g' - ' '], 1, goto_file_start);

  push_command(szstr("w"), 1, write_buf_to_file);
  push_command(szstr("q"), 1, shutdown);

  if (argc > 2 || argc < 2) {
    printf("Invalid parameters\n");
    printf("Usage: %s [FILE]\n", argv[0]);
    exit(EXIT_FAILURE);
  }

  Buffer file_buf = {
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
  Buffer menu_buf = {
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
  menu_buf.lines[0].str = malloc(sizeof(char) * 1);
  menu_buf.lines[0].len = 0;
  menu_buf.lines[0].cap = 1;

  buf = &file_buf;
  file_buf_global = &file_buf;
  menu_buf_global = &menu_buf;

  {
    FILE *file = fopen(buf->file_path, "a+");
    if (file == NULL) {
      perror("Couldn't open file for reading");
      exit(1);
    }
    Line line = {
     .str = malloc(sizeof(char) * 1),
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
        insert_line(buf, &line, current_y);
        current_y += 1;
        current_x = 0;

        line.len = 0;
        line.cap = 0;
        line.str = malloc(sizeof(char) * 1);
        continue;
      }
      insert(&line, &c, 1, current_x);
      current_x += 1;
    }
    if (!messed_with) {
      insert_line(buf, &line, current_y);
    }
    fclose(file);
  }

  int tb_init_ret = tb_init();
  if (tb_init_ret) {
    fprintf(stderr, "tb_init() failed with error code %d\n", tb_init_ret);
    exit(EXIT_FAILURE);
  }

  tb_set_input_mode(TB_INPUT_ALT | TB_INPUT_MOUSE);

  draw_buf(&file_buf, 0, 0, tb_height() - 1);

  while (tb_poll_event(&tb_event) == TB_OK) {
    switch (tb_event.type) {
      case TB_EVENT_KEY: {
        if (tb_event.ch >= '0' && tb_event.ch <= '9' &&
            buf->mode == MODE_NORMAL) {
          buf->num_arg *= 10;
          buf->num_arg += tb_event.ch - '0';
        }
        else if (tb_event.ch >= ' ' && tb_event.ch <= '~') {
          OpList *op_list = &maps_ch[buf->mode]
                                    [tb_event.mod]
                                    [tb_event.ch - ' '];
          if (op_list->num_ops > 0) {
            for (int i = 0; i < op_list->num_ops; i++) {
              op_list->ops[i]();
            }
          }
          buf->num_arg = 0;
        }
        else if (tb_event.key >= TB_KEY_CTRL_A &&
                 tb_event.key <= TB_KEY_SPACE) {
          OpList *op_list = &maps_ch[buf->mode]
                                    [tb_event.mod]
                                    [tb_event.key + 'A' - 1];
          if (op_list->num_ops > 0) {
            for (int i = 0; i < op_list->num_ops; i++) {
              op_list->ops[i]();
            }
          }
          buf->num_arg = 0;
        }
        else if (tb_event.key == TB_KEY_BACKSPACE2) {
          OpList *op_list = &maps_backspace[buf->mode];
          if (op_list->num_ops > 0) {
            for (int i = 0; i < op_list->num_ops; i++) {
              op_list->ops[i]();
            }
          }
          buf->num_arg = 0;
        }
      } break;
    }

    tb_clear();
    draw_buf(&file_buf, 0, 0, tb_height() - 1);
    if (edit_mode == MENU_EDIT_MODE) {
      switch (menu_mode) {
        case COMMAND_MENU_MODE:
          tb_printf(0, tb_height() - 1, TB_WHITE, 0, ":");
          draw_buf(&menu_buf, 1, tb_height() - 1, 1);
          break;
        case SEARCH_MENU_MODE:
          tb_printf(0, tb_height() - 1, TB_WHITE, 0, "Search:");
          draw_buf(&menu_buf, 7, tb_height() - 1, 1);
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
