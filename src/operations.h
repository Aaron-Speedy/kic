#ifndef OPERATIONS_H
#define OPERATIONS_H

#include <stdlib.h>
#include <stdarg.h>

#include "structs.h"

int insert_util(Buffer *buffer, size_t line, size_t column, char char_to_insert);
int delete_util(Buffer *buffer, size_t line, size_t column);

int insert(Buffer *buffer, Selection *sel, ...); // Args: char_to_insert
int backspace(Buffer *buffer, Selection *sel, ...); // Args: N/A
int move_right(Buffer *buffer, Selection *sel, ...); // Args: N/A
int move_left(Buffer *buffer, Selection *sel, ...); // Args: N/A
int move_up(Buffer *buffer, Selection *sel, ...); // Args: N/A
int move_down(Buffer *buffer, Selection *sel, ...); // Args: N/A

#endif
