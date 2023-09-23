#define TB_IMPL
#include "termbox2.h"

int main(void) {
  struct tb_event ev;

  tb_init();

  while (1);

  tb_shutdown();

  return 0;
}
