#include <unistd.h>
#include <stdint.h>
#include <string.h>
#include <errno.h>

#define SSTUI_IMPLEMENTATION
#include "sstui.h"

typedef enum {
  SST_NONE,
  SST_ALPHA,
  SST_NUM,
  SST_SYMBOL,
  SST_FUNCTION,
} SST_KeyType;

typedef enum {
  SST_SHIFT = 1,
  SST_ALT = 2,
  SST_CONTROL = 4,
} SST_Mod;

typedef struct {
  SST_KeyType type;
  char key;
  SST_Mod mod;
} SST_Key;

#define SSTI_IS_LOWER(x) ((x) >= 'a' && (x) <= 'z')
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
      key.type = SST_ALPHA;
      if (SSTI_START("")) {
        SSTI_MATCH((key.key = seq[seq_index], matches &= SSTI_IS_LOWER(key.key), seq_index++), "");
        SSTI_MATCH((key.key = seq[seq_index] + 32, key.mod = SST_SHIFT, matches &= SSTI_IS_LOWER(key.key), seq_index++), "");
        SSTI_MATCH((key.key = seq[seq_index] + 96, key.mod = SST_CONTROL, matches &= SSTI_IS_LOWER(key.key), seq_index++), "");
      }
      if (SSTI_START("\x1b")) {
        SSTI_MATCH((key.key = seq[seq_index], key.mod = SST_ALT, matches &= SSTI_IS_LOWER(key.key), seq_index++), "");
        SSTI_MATCH((key.key = seq[seq_index] + 32, key.mod = SST_SHIFT | SST_ALT, matches &= SSTI_IS_LOWER(key.key), seq_index++), "");
        SSTI_MATCH((key.key = seq[seq_index] + 96, key.mod = SST_CONTROL | SST_ALT, matches &= SSTI_IS_LOWER(key.key), seq_index++), "");
      }

      key.type = SST_NUM;
      if (SSTI_START("")) {
        SSTI_MATCH((key.key = seq[seq_index], key.mod = 0, matches &= SSTI_IS_NUM(key.key), seq_index++), "");
      }
      if (SSTI_START("\x1b")) {
        SSTI_MATCH((key.key = seq[seq_index], key.mod = SST_ALT, matches &= SSTI_IS_NUM(key.key), seq_index++), "");
      }

      key.type = SST_SYMBOL;
      if (SSTI_START("")) {
        SSTI_MATCH((key.key = seq[seq_index], key.mod = 0, matches &= SSTI_IS_SYMBOL(key.key), seq_index++), "");
      }

      key.type = SST_FUNCTION;
      key.mod = 0;
      if (SSTI_START("\x1b")) {
        SSTI_MATCH((key.key = 1), "OP");
        SSTI_MATCH((key.key = 2), "OQ");
        SSTI_MATCH((key.key = 3), "OR");
        SSTI_MATCH((key.key = 4), "OS");
      }
      if (SSTI_START("\x1b[")) {
        SSTI_MATCH((key.key = 5), "15~");
        SSTI_MATCH((key.key = 6), "17~");
        SSTI_MATCH((key.key = 7), "18~");
        SSTI_MATCH((key.key = 8), "19~");
        SSTI_MATCH((key.key = 9), "20~");
        SSTI_MATCH((key.key = 10), "21~");
        SSTI_MATCH((key.key = 11), "23~");
        SSTI_MATCH((key.key = 12), "24~");
      }

      matches = 0;
    } while (0);

    if (matches && key.type == SST_ALPHA) printf("%c : %d\n", key.key, key.mod);
    if (matches && key.type == SST_NUM) printf("%c : %d\n", key.key, key.mod);
    if (matches && key.type == SST_SYMBOL) printf("%c : %d\n", key.key, key.mod);
    if (matches && key.type == SST_FUNCTION) printf("F%d : %d\n", key.key, key.mod);
    if (key.key == 'q') break;
  }

  return 0;
}
