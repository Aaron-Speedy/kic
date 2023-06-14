#ifndef STRUCTS_H
#define STRUCTS_H

#include <stdlib.h>

typedef struct {
  char *str;
  size_t len;
  size_t alloc_len;
} Line;

typedef struct {
  Line *lines;
  size_t len;
  size_t alloc_len;
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
