#include <unistd.h>
#include <stdint.h>
#include <string.h>
#include <errno.h>

#define SSTUI_IMPLEMENTATION
#include "sstui.h"

typedef enum {
  SST_NONE,
  SST_ALPHA,
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
#define SSTI_MATCH(start, middle, end) \
  if ((matches &= (strncmp(start, &seq[seq_index], sizeof(start) - 1) == 0))) { \
    seq_index += sizeof(start) - 1; \
    middle; \
    matches &= strncmp(end"\0", &seq[seq_index], sizeof(end"\0") - 1) == 0; \
  } \
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
    do {
      key.type = SST_ALPHA;
      SSTI_MATCH("", (key.key = seq[seq_index], matches &= SSTI_IS_LOWER(key.key), seq_index++), "");
      SSTI_MATCH("", (key.key = seq[seq_index] + 32, key.mod = SST_SHIFT, matches &= SSTI_IS_LOWER(key.key), seq_index++), "");
      SSTI_MATCH("", (key.key = seq[seq_index] + 96, key.mod = SST_CONTROL, matches &= SSTI_IS_LOWER(key.key), seq_index++), "");
      SSTI_MATCH("\x1b", (key.key = seq[seq_index], key.mod = SST_ALT, matches &= SSTI_IS_LOWER(key.key), seq_index++), "");
      SSTI_MATCH("\x1b", (key.key = seq[seq_index] + 32, key.mod = SST_SHIFT | SST_ALT, matches &= SSTI_IS_LOWER(key.key), seq_index++), "");
      SSTI_MATCH("\x1b", (key.key = seq[seq_index] + 96, key.mod = SST_CONTROL | SST_ALT, matches &= SSTI_IS_LOWER(key.key), seq_index++), "");

      key.type = SST_FUNCTION;
      key.mod = 0;
      SSTI_MATCH("\x1b", (key.key = 1), "OP");
      SSTI_MATCH("\x1b", (key.key = 2), "OQ");
      SSTI_MATCH("\x1b", (key.key = 3), "OR");
      SSTI_MATCH("\x1b", (key.key = 4), "OS");
      SSTI_MATCH("\x1b[", (key.key = 5), "15~");
      SSTI_MATCH("\x1b[", (key.key = 6), "17~");
      SSTI_MATCH("\x1b[", (key.key = 7), "18~");
      SSTI_MATCH("\x1b[", (key.key = 8), "19~");
      SSTI_MATCH("\x1b[", (key.key = 9), "20~");
      SSTI_MATCH("\x1b[", (key.key = 10), "21~");
      SSTI_MATCH("\x1b[", (key.key = 11), "23~");
      SSTI_MATCH("\x1b[", (key.key = 12), "24~");

      matches = 0;
    } while (0);

    if (matches && key.type == SST_ALPHA) printf("%c : %d\n", key.key, key.mod);
    if (matches && key.type == SST_FUNCTION) printf("F%d : %d\n", key.key, key.mod);
    if (key.key == 'q') break;
  }

  return 0;
}
