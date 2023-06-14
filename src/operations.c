#include <string.h>
#include <malloc.h>

#include "operations.h"
#include "../config.h"

enum FailRets {
  NO_OP = 1,
};

#define get_args() va_list args; va_start(args, sel);

int insert_util(Buffer *buffer, size_t line, size_t column, char char_to_insert) {
  buffer->lines[line].len++;

  if(buffer->lines[line].alloc_len >= buffer->lines[line].len) {
    memmove(buffer->lines[line].str + column + 1, buffer->lines[line].str + column, buffer->lines[line].len - column - 1);
  } else {
    buffer->lines[line].alloc_len += LINE_RESIZE_AMOUNT;

    char *new_str = malloc(buffer->lines[line].alloc_len);
    memcpy(new_str, buffer->lines[line].str, column);
    memcpy(new_str + column + 1, buffer->lines[line].str + column, buffer->lines[line].len - column - 1);
    free(buffer->lines[line].str);
    buffer->lines[line].str = new_str;
  }

  buffer->lines[line].str[column] = char_to_insert;

  return 0;
}
int delete_util(Buffer *buffer, size_t line, size_t column) {
  if(buffer->lines[line].len > 0 && buffer->lines[line].len > column) {
    buffer->lines[line].len--;
    memmove(buffer->lines[line].str + column, buffer->lines[line].str + column + 1, buffer->lines[line].len - column + 1);

    return 0;
  }

  return NO_OP;
}

int insert(Buffer *buffer, Selection *sel, ...) { // Args: char char_to_insert
  get_args();
  char char_to_insert = va_arg(args, int);

  insert_util(buffer, sel->anchor_line, sel->anchor_column, char_to_insert);
  sel->anchor_column++;
  sel->cursor_column++;
  
  return 0;
}
int backspace(Buffer *buffer, Selection *sel, ...) { // Args: N/A  
  sel->anchor_column--;
  sel->cursor_column--;
  if(delete_util(buffer, sel->anchor_line, sel->anchor_column)) {
    sel->anchor_column++;
    sel->cursor_column++;
  }

  return 0;
}
int move_right(Buffer *buffer, Selection *sel, ...) { // Args: N/A
  if(sel->cursor_column++ == buffer[sel->cursor_line].len) sel->cursor_column--;
  sel->anchor_column = sel->cursor_column;
  sel->anchor_line = sel->cursor_line;

  return 0;
}
int move_left(Buffer *buffer, Selection *sel, ...) { // Args: N/A
  if(sel->cursor_column) sel->cursor_column--;

  sel->anchor_column = sel->cursor_column;
  sel->anchor_line = sel->cursor_line;

  return 0;
}
