#include <unistd.h>
#include <stdint.h>
#include <string.h>
#include <errno.h>

#define SSTUI_IMPLEMENTATION
#include "sstui.h"

typedef enum {
  SST_SHIFT = 1,
  SST_ALT = 2,
  SST_CONTROL = 4,
} SST_Mod;

typedef enum {
  SST_NONE,
  SST_ALPHANUMSYM,
  SST_FUNCTION,
} SST_KeyType;

typedef struct {
  SST_KeyType type;
  char key;
  SST_Mod mod;
} SST_Key;

#define SSTI_IS_LOWER(x) ((x) >= 'a' && (x) <= 'z')
#define SSTI_IS_ALPHA(x) (((x) >= 'a' && (x) <= 'z') ||  ((x) >= 'A' && (x) <= 'Z'))
#define SSTI_IS_NUM(x) ((x) >= '0' && (x) <= '9')
#define SSTI_IS_SYMBOL(x) (((x) >= ' ' && (x) <= '/') || \
                           ((x) >= ':' && (x) <= '@') || \
                           ((x) >= '[' && (x) <= '`') || \
                           ((x) >= '{' && (x) <= '~'))
#define SSTI_START(start) (start_len = sizeof(start) - 1, strncmp(start, seq, start_len) == 0)
#define SSTI_MATCH(middle, end) \
  seq_index += start_len; \
  middle; \
  matches &= strncmp(end"\0", &seq[seq_index], sizeof(end"\0") - 1) == 0; \
  if (matches) { \
    break; \
  } \
  seq_index = 0; \
  matches = 1;

int main(void) {
  sst_init_tui();

  while (1) {
    char seq[33] = { 0 };
    int ret = read(STDIN_FILENO, seq, sizeof(seq));
    if (ret < 0) {
      perror("Something went wrong while reading user input");
      exit(1);
    }

    SST_Key key = { 0 };
    int seq_index = 0; 
    int matches = 1;
    int start_len = 0;
    do {
      key.type = SST_ALPHANUMSYM;
      if (SSTI_START("")) {
        SSTI_MATCH((key.key = seq[seq_index], matches &= SSTI_IS_ALPHA(key.key) || SSTI_IS_NUM(key.key), seq_index++), "");
        SSTI_MATCH((key.key = seq[seq_index] + 96, key.mod = SST_CONTROL, matches &= SSTI_IS_LOWER(key.key), seq_index++), "");

        SSTI_MATCH((key.key = seq[seq_index], key.mod = 0, matches &= SSTI_IS_SYMBOL(key.key), seq_index++), "");
      }
      if (SSTI_START("\x1b")) {
        SSTI_MATCH((key.key = seq[seq_index], key.mod = SST_ALT, matches &= SSTI_IS_ALPHA(key.key) || SSTI_IS_NUM(key.key), seq_index++), "");
        SSTI_MATCH((key.key = seq[seq_index] + 96, key.mod = SST_CONTROL | SST_ALT, matches &= SSTI_IS_LOWER(key.key), seq_index++), "");

        SSTI_MATCH((key.key = seq[seq_index], key.mod = SST_ALT, matches &= SSTI_IS_SYMBOL(key.key), seq_index++), "");
      }

      key.type = SST_FUNCTION;
      key.mod = 0;
      if (SSTI_START("\x1bO")) {
        SSTI_MATCH((key.key = 1), "P");
        SSTI_MATCH((key.key = 2), "Q");
        SSTI_MATCH((key.key = 3), "R");
        SSTI_MATCH((key.key = 4), "S");
      }
      if (SSTI_START("\x1b[1")) {
        SSTI_MATCH((key.key = 5), "5~");
        SSTI_MATCH((key.key = 6), "7~");
        SSTI_MATCH((key.key = 7), "8~");
        SSTI_MATCH((key.key = 8), "9~");

        key.mod = SST_SHIFT;
        SSTI_MATCH((key.key = 1), ";2P");
        SSTI_MATCH((key.key = 2), ";2Q");
        SSTI_MATCH((key.key = 3), ";2R");
        SSTI_MATCH((key.key = 4), ";2S");
        SSTI_MATCH((key.key = 5), "5;2~");
        SSTI_MATCH((key.key = 6), "7;2~");
        SSTI_MATCH((key.key = 7), "8;2~");
        SSTI_MATCH((key.key = 8), "9;2~");

        key.mod = SST_ALT;
        SSTI_MATCH((key.key = 1), ";3P");
        SSTI_MATCH((key.key = 2), ";3Q");
        SSTI_MATCH((key.key = 3), ";3R");
        SSTI_MATCH((key.key = 4), ";3S");
        SSTI_MATCH((key.key = 5), "5;3~");
        SSTI_MATCH((key.key = 6), "7;3~");
        SSTI_MATCH((key.key = 7), "8;3~");
        SSTI_MATCH((key.key = 8), "9;3~");

        key.mod = SST_CONTROL;
        SSTI_MATCH((key.key = 1), ";5P");
        SSTI_MATCH((key.key = 2), ";5Q");
        SSTI_MATCH((key.key = 3), ";5R");
        SSTI_MATCH((key.key = 4), ";5S");
        SSTI_MATCH((key.key = 5), "5;5~");
        SSTI_MATCH((key.key = 6), "7;5~");
        SSTI_MATCH((key.key = 7), "8;5~");
        SSTI_MATCH((key.key = 8), "9;5~");
      }
      if (SSTI_START("\x1b[2")) {
        SSTI_MATCH((key.key = 9), "0~");
        SSTI_MATCH((key.key = 10), "1~");
        SSTI_MATCH((key.key = 11), "3~");
        SSTI_MATCH((key.key = 12), "4~");

        key.mod = SST_SHIFT;
        SSTI_MATCH((key.key = 9), "0;2~");
        SSTI_MATCH((key.key = 10), "1;2~");
        SSTI_MATCH((key.key = 11), "3;2~");
        SSTI_MATCH((key.key = 12), "4;2~");

        key.mod = SST_ALT;
        SSTI_MATCH((key.key = 9), "0;3~");
        SSTI_MATCH((key.key = 10), "1;3~");
        SSTI_MATCH((key.key = 11), "3;3~");
        SSTI_MATCH((key.key = 12), "4;3~");

        key.mod = SST_CONTROL;
        SSTI_MATCH((key.key = 9), "0;5~");
        SSTI_MATCH((key.key = 10), "1;5~");
        SSTI_MATCH((key.key = 11), "3;5~");
        SSTI_MATCH((key.key = 12), "4;5~");
      }

      matches = 0;
    } while (0);

    if (matches && key.type == SST_ALPHANUMSYM) printf("%c : %d\n", key.key, key.mod);
    if (matches && key.type == SST_FUNCTION) printf("F%d : %d\n", key.key, key.mod);
    if (key.key == 'q') break;
  }

  return 0;
}
