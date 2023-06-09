#include "operations.h"

#define ARGS va_list args; va_start(args, sel);

int insert(Buffer *buff, Selection *sel, ...) { // Args: char char_to_insert
  ARGS;
  char char_to_insert = va_arg(args, int);

  
  return 0;
}
