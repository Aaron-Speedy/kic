#ifndef STRUCTS_H
#define STRUCTS_H

#include <stdlib.h>

/* The buffer is stored as a linked list instead of a gap buffer or something because 
this editor uses multiple selections, and I am just prototyping right now. I might change
to a different structure later though.*/ 
typedef struct Line {
  char *str;
  size_t len;
  size_t alloc_len;
  struct Line *prev;
  struct Line *next;
} Line;

typedef struct Selection {
  Line *anchor_line;
  Line *cursor_line;
  size_t anchor_column;
  size_t cursor_column;
  struct Selection *next;
  struct Selection *prev;
} Selection;

#endif
