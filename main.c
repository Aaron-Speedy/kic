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

void cleanup(void) {
  write(1, szstr("\x1b[?1049h"));
  write(1, szstr("\x1b[2J"));
  write(1, szstr("\x1b[?1049l"));
}
void die() { // Signal won't accept functions where void is specified
  exit(1);
}

int main() {
  // Enter into the alternate buffer, and clear scroll-back
  write(1, szstr("\x1b[?1049h"));
  write(1, szstr("\x1b[2J"));

  atexit(cleanup);
  signal(SIGTERM, die);
  signal(SIGINT, die);

  struct winsize ws;
  ioctl(1, TIOCGWINSZ, &ws);

  write(1, szstr("Hello, world!\n"));
  sleep(1);

  return 0;
}
