#include <string.h>
#include <malloc.h>

#include "operations.h"
#include "../config.h"

#define get_args() va_list args; va_start(args, sel);

int insert_util(Line *line, size_t *column, char char_to_insert) {
  line->len++;

  if(line->alloc_len >= line->len) {
    memmove(line->str + *column, line->str + *column + 1, line->len - *column - 1);
  } else {
    line->alloc_len += LINE_RESIZE_AMOUNT;

    char *new_str = malloc(line->alloc_len);
    memcpy(new_str, line->str, *column);
    memcpy(new_str + *column, line->str + *column + 1, line->len - *column - 1);
    free(line->str);
    line->str = new_str;
  }

  line->str[*column] = char_to_insert;
  (*column)++;

  return 0;
}
int delete_util(Line *line, size_t *column) {
  if(line->len > 0) {
    line->len--;
    memmove(line->str + *column, line->str + *column + 1, line->len - *column + 1);
    (*column)--;
  }

  return 0;
}

int insert(Selection *sel, ...) { // Args: char char_to_insert
  get_args();
  char char_to_insert = va_arg(args, int);

  insert_util(sel->anchor_line, &sel->anchor_column, char_to_insert);
  
  return 0;
}
int backspace(Selection *sel, ...) { // Args: N/A  
  delete_util(sel->anchor_line, &sel->anchor_column);

  return 0;
}
