#include <string.h>
#include <unistd.h>
#include <time.h>
#include <sys/ioctl.h>
#include <signal.h>
#include <stdlib.h>
#include <stdio.h>
#include <termios.h>

#include "src/modes.h"
#include "src/structs.h"
#include "src/operations.h"

#define szstr(str) str, sizeof(str)
#define clear_line() write(1, szstr("\x1b[2K"));
#define move_cursor(line, column) printf("\x1b[%zu;%zuH", line + 1, column + 1); fflush(stdout);
typedef struct {
  char key;
} Key;

struct termios initial;

void cleanup(void) {
  write(1, szstr("\x1b[?1049h"));
  write(1, szstr("\x1b[2J"));
  write(1, szstr("\x1b[?1049l"));
  tcsetattr(1, TCSANOW, &initial);
}
void die() { // Signal won't accept functions where void is specified
  exit(EXIT_FAILURE);
}

int main() {
  Selection *sels_head = calloc(1, sizeof(Selection));
  Buffer buffer = {
    .lines = calloc(1, sizeof(Line)),
    .len = 1,
    .alloc_len = 1,
  };
  buffer.lines[0].str = malloc(1);

  // Prepare TUI
  write(1, szstr("\x1b[?1049h")); // Switch to alternate buffer
  write(1, szstr("\x1b[2J")); // Clear the screen and disable scrollback.
  move_cursor((size_t)0, (size_t)0);

  // Disable line buffering and echo
  struct termios t;
  if(tcgetattr(1, &t)) {perror("tcgetattr"); exit(EXIT_FAILURE);}
  initial = t;
  t.c_lflag &= (~ECHO & ~ICANON);
  if(tcsetattr(1, TCSANOW, &t)) {perror("tcsetattr"); exit(EXIT_FAILURE);};

  atexit(cleanup);
  signal(SIGTERM, die);
  signal(SIGINT, die);

  struct winsize ws;
  ioctl(1, TIOCGWINSZ, &ws);

  // Program loop
  int mode = NORMAL_MODE;
  while(1) {
    Key input;
    read(1, &input.key, 1);

    switch(mode) {
      case NORMAL_MODE: {
        switch(input.key) {
          case 'i':
            mode = INSERT_MODE;
            break;
          case 'h':
            move_left(&buffer, sels_head);
            break;
          case 'l':
            move_right(&buffer, sels_head);
            break;
        }
      } break;
      case INSERT_MODE: {
        switch(input.key) {
          case 127:
            backspace(&buffer, sels_head);
            break;
          case '\x1b':
            mode = NORMAL_MODE;
            break;
          default:
            insert(&buffer, sels_head, input.key);
        }
      } break;
    }

    size_t upper_bound = ws.ws_row > buffer.len ? ws.ws_row : buffer.len;
    for(size_t i = 0; i < upper_bound; i++) {
      move_cursor(i, (size_t)0);
      clear_line();
      write(1, buffer.lines[i].str, buffer.lines[i].len);
    }
    move_cursor(sels_head->cursor_line, sels_head->cursor_column);
  }

  return 0;
}
