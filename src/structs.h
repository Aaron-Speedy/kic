#ifndef STRUCTS_H
#define STRUCTS_H

#include <stdlib.h>

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

#endif
