#include <string.h>
#include <unistd.h>
#include <time.h>
#include <sys/ioctl.h>
#include <signal.h>
#include <stdlib.h>

#define szstr(str) str, sizeof(str)

typedef struct {
  char *str;
  size_t len;
} Line;

typedef struct {
  Line *content;
  size_t num_lines;
} Buffer;

typedef struct Selection {
  size_t anchor_line;
  size_t anchor_column;
  size_t cursor_line;
  size_t cursor_column;
  struct Selection *next;
  struct Selection *prev;
} Selection;

void cleanup(void) {
  write(1, szstr("\x1b[?1049h"));
  write(1, szstr("\x1b[2J"));
  write(1, szstr("\x1b[?1049l"));
}
void die() { // Signal won't accept functions where void is specified
  exit(1);
}

int main() {
  Selection *first_sel = calloc(1, sizeof(Selection));

  // Prepare TUI
  write(1, szstr("\x1b[?1049h")); // Switch to alternate buffer
  write(1, szstr("\x1b[2J")); // Clear the screen and disable scrollback.
  write(1, szstr("\x1b[0;0H")); // Move cursor to 0, 0

  atexit(cleanup);
  signal(SIGTERM, die);
  signal(SIGINT, die);

  // Get terminal size
  struct winsize ws;
  ioctl(1, TIOCGWINSZ, &ws);

  write(1, szstr("Hello, world!\n"));
  sleep(1);

  return 0;
}
