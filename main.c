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
  Line *buffer = calloc(1, sizeof(Line));
  sels_head->anchor_line = sels_head->cursor_line = buffer;

  // Prepare TUI
  write(1, szstr("\x1b[?1049h")); // Switch to alternate buffer
  write(1, szstr("\x1b[2J")); // Clear the screen and disable scrollback.
  write(1, szstr("\x1b[0;0H"));

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
  int mode = INSERT_MODE;
  while(1) {
    Key input;
    read(1, &input.key, 1);

    switch(mode) {
      case NORMAL_MODE: {
      } break;
      case INSERT_MODE: {
        switch(input.key) {
          case 127:
            backspace(sels_head);
            break;
          default:
            insert(sels_head, input.key);
        }
      } break;
    }

    clear_line();
    write(1, szstr("\x1b[0;0H"));
    write(1, sels_head->anchor_line->str, sels_head->anchor_line->len);
  }

  return 0;
}
