#ifndef OPERATIONS_H
#define OPERATIONS_H

#include <stdlib.h>
#include <stdarg.h>

#include "structs.h"

int insert_util(Line *line, size_t *column, char char_to_insert);
int delete_util(Line *line, size_t *column);

int insert(Selection *sel, ...); // Args: char_to_insert
int delete(Selection *sel, ...); // Args: N/A

#endif
