#include <stdlib.h>
#include <stdio.h>

// #define TB_IMPL
#include "termbox2.h"

typedef struct {
  char *content;
  size_t len;
  size_t cap;
} Line;

void insert(Line *line, char *str, size_t len, size_t index) {
  if (line->len + len >= line->cap) {
    line->cap = line->len * 2 + len;
    char *new_content = realloc(line->content, line->cap);
    if (new_content == NULL) {
      perror("Could not realloc line content for inserting");
      exit(EXIT_FAILURE);
    }

    line->content = new_content;
  }
  memmove(&line->content[index + len], &line->content[index], line->len - index);
  memcpy(&line->content[index], str, len);
  line->len += len;
}

int main(void) {
  char text[14] = "This is a test";
  char text_to_insert[5] = " cool";
  Line line = {
    .content = malloc(14),
    .len = 14,
    .cap = 14,
  };
  memcpy(line.content, text, 14);
  fwrite(line.content, 1, line.len, stdout);
  printf("\n");
  insert(&line, text_to_insert, 5, 9);
  fwrite(line.content, 1, line.len, stdout);
  printf("\n");

  // struct tb_event ev;

  // tb_init();

  // while (1);

  // tb_shutdown();

  return 0;
}
