#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <time.h>
#include <sys/ioctl.h>

#define szstr(str) str, sizeof(str)

typedef struct {
  char *str;
  size_t len;
} Line;

typedef struct {
  Line *content;
  size_t num_lines;
} Buffer;

int main() {
  write(1, szstr("\x1b[?1049h"));
  write(1, szstr("\x1b[2J"));

  struct winsize ws;
  ioctl(1, TIOCGWINSZ, &ws);

  write(1, szstr("Hello, world!\n"));
  sleep(1);

  write(1, szstr("\x1b[2J"));
  write(1, szstr("\x1b[?1049l"));
  return 0;
}
