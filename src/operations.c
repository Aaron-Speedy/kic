#include <string.h>
#include <malloc.h>

#include "operations.h"
#include "../config.h"

#define ARGS va_list args; va_start(args, sel);

int insert_line(Line *line, size_t column, char char_to_insert) {
  line->len++;

  if(line->alloc_len >= line->len) {
    memmove(line->str + column, line->str + column + 1, line->len - column);
  } else {
    line->alloc_len += LINE_RESIZE_AMOUNT;

    char *new_str = malloc(line->alloc_len);
    memcpy(new_str, line->str, column);
    memcpy(new_str + column, line->str + column + 1, line->len - column - 1);
    free(line->str);
    line->str = new_str;
  }

  line->str[column] = char_to_insert;

  return 0;
}

int insert(Selection *sel, ...) { // Args: char char_to_insert
  ARGS;
  char char_to_insert = va_arg(args, int);

  insert_line(sel->anchor_line, sel->anchor_column, char_to_insert);
  sel->anchor_column++;
  
  return 0;
}
