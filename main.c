#define TB_IMPL
#include "termbox2.h"

typedef enum {
  MODE_NORMAL,
  MODE_INSERT,
} Mode;

typedef struct {
  char *content;
  size_t len;
  size_t cap;
} Line;

typedef struct {
  Line *lines;
  size_t num_lines;
  size_t lines_cap;
  size_t adjusted_cursor_x;
  size_t saved_cursor_x;
  size_t cursor_y;
  Mode mode;
  const char *file_path;
} Buffer;

void insert(Line *line, char *str, size_t str_len, size_t index) {
  if (line->len + str_len >= line->cap) {
    line->cap = line->len * 2 + str_len;
    char *new_content = realloc(line->content, sizeof(char) * line->cap);
    if (new_content == NULL) {
      perror("Could not realloc line->content for inserting");
      exit(EXIT_FAILURE);
    }

    line->content = new_content;
  }

  memmove(&line->content[index + str_len], &line->content[index], sizeof(char) * (line->len - index));
  memcpy(&line->content[index], str, sizeof(char) * str_len);
  line->len += str_len;
}

void insert_line(Buffer *buffer, Line *line, size_t y_pos) {
  if (buffer->num_lines + 1 >= buffer->lines_cap) {
    buffer->lines_cap = buffer->num_lines * 2 + 1;
    Line *new_buffer_lines = realloc(buffer->lines, sizeof(Line) * buffer->lines_cap);
    if (new_buffer_lines == NULL) {
      perror("Could not realloc buffer->lines for inserting a line");
    }

    buffer->lines = new_buffer_lines;
  }

  memmove(&buffer->lines[y_pos + 1], &buffer->lines[y_pos], sizeof(Line) * (buffer->num_lines - y_pos));
  buffer->lines[y_pos].content = line->content;
  buffer->lines[y_pos].len = line->len;
  buffer->lines[y_pos].cap = line->len;
  buffer->num_lines += 1;
}

void write_buffer_to_file(Buffer *buffer) {
  int fd = open(buffer->file_path, O_CREAT | O_WRONLY);
  for (int i = 0; i < buffer->num_lines; i++) {
    write(fd, buffer->lines[i].content, buffer->lines[i].len);
    write(fd, "\n", 1);
  }
}

int main(void) {
  Buffer buffer = {
    .lines = malloc(sizeof(Line) * 1),
    .num_lines = 0,
    .lines_cap = 1,
    .adjusted_cursor_x = 0,
    .saved_cursor_x = 0,
    .cursor_y = 0,
    .mode = MODE_NORMAL,
    .file_path = "main.c",
  };

  {
    FILE *file = fopen(buffer.file_path, "r");
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
    while ((c = fgetc(file)) != EOF) {
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
    fclose(file);

  }

  int tb_init_ret = tb_init();
  if (tb_init_ret) {
    fprintf(stderr, "tb_init() failed with error code %d\n", tb_init_ret);
    exit(EXIT_FAILURE);
  }

  tb_set_input_mode(TB_INPUT_ESC | TB_INPUT_MOUSE);
  struct tb_event ev;

  tb_clear();
  for (int i = 0; i < buffer.num_lines; i++) {
    tb_print_len(0, i, TB_WHITE, 0, buffer.lines[i].content, buffer.lines[i].len);
  }
  uintattr_t color = 0;
  if (buffer.mode == MODE_INSERT) color = TB_RED;
  if (buffer.mode == MODE_NORMAL) color = TB_BLUE;
  if (buffer.adjusted_cursor_x == buffer.lines[buffer.cursor_y].len) tb_set_cell(buffer.adjusted_cursor_x, buffer.cursor_y, 0, 0, color);
  else tb_set_cell(buffer.adjusted_cursor_x, buffer.cursor_y, buffer.lines[buffer.cursor_y].content[buffer.adjusted_cursor_x], 0, color);
  tb_present();
  while (tb_poll_event(&ev) == TB_OK) {
    switch (ev.type) {
      case TB_EVENT_KEY: {
        switch (buffer.mode) {
          case MODE_NORMAL: {
            if (ev.key == TB_KEY_CTRL_Q) {
              goto end;
            }
            if (ev.ch == 'i') {
              buffer.mode = MODE_INSERT;
            }
            if (ev.ch == 'o') {
              Line new_line = {
                .content = malloc(1),
                .len = 0,
                .cap = 1,
              };
              insert_line(&buffer, &new_line, buffer.cursor_y + 1);
              buffer.saved_cursor_x = 0;
              buffer.adjusted_cursor_x = 0;
              buffer.cursor_y += 1;

              buffer.mode = MODE_INSERT;
            }
            if (ev.ch == 'j' && buffer.cursor_y < buffer.num_lines - 1) {
              buffer.cursor_y += 1;
              buffer.adjusted_cursor_x = buffer.saved_cursor_x > buffer.lines[buffer.cursor_y].len ? buffer.lines[buffer.cursor_y].len : buffer.saved_cursor_x;
            }
            if (ev.ch == 'k' && buffer.cursor_y > 0) {
              buffer.cursor_y -= 1;
              buffer.adjusted_cursor_x = buffer.saved_cursor_x > buffer.lines[buffer.cursor_y].len ? buffer.lines[buffer.cursor_y].len : buffer.saved_cursor_x;
            }
            if (ev.ch == 'h' && buffer.adjusted_cursor_x > 0) {
              buffer.adjusted_cursor_x -= 1;
              buffer.saved_cursor_x = buffer.adjusted_cursor_x;
            }
            if (ev.ch == 'l' && buffer.adjusted_cursor_x < buffer.lines[buffer.cursor_y].len) {
              buffer.adjusted_cursor_x += 1;
              buffer.saved_cursor_x = buffer.adjusted_cursor_x;
            }
            if (ev.key == TB_KEY_ESC) {
              write_buffer_to_file(&buffer);
            }
          } break;

          case MODE_INSERT: {
            if (ev.ch >= ' ' && ev.ch <= '~') {
              char in[] = { ev.ch };
              insert(&buffer.lines[buffer.cursor_y], in, 1, buffer.adjusted_cursor_x);
              buffer.adjusted_cursor_x += 1;
              buffer.saved_cursor_x = buffer.adjusted_cursor_x;
            }
            if (ev.key == TB_KEY_ESC) {
              buffer.mode = MODE_NORMAL;
            }
          } break;
        }
      } break;
    }

    tb_clear();
    for (int i = 0; i < buffer.num_lines; i++) {
      tb_print_len(0, i, TB_WHITE, 0, buffer.lines[i].content, buffer.lines[i].len);
    }
    uintattr_t color = 0;
    if (buffer.mode == MODE_INSERT) color = TB_RED;
    if (buffer.mode == MODE_NORMAL) color = TB_BLUE;
    if (buffer.adjusted_cursor_x == buffer.lines[buffer.cursor_y].len) tb_set_cell(buffer.adjusted_cursor_x, buffer.cursor_y, 0, 0, color);
    else tb_set_cell(buffer.adjusted_cursor_x, buffer.cursor_y, buffer.lines[buffer.cursor_y].content[buffer.adjusted_cursor_x], 0, color);
    tb_present();
  }

end:
  tb_shutdown();

  return 0;
}
