#ifndef SSTUI_H
#define SSTUI_H

void sst_init_tui(void);
void sst_cleanup_tui(void);
void sst_kill_tui();

#endif

#ifdef SSTUI_IMPLEMENTATION

#include <sys/ioctl.h>
#include <signal.h>
#include <termios.h>
#include <stdlib.h>
#include <stdio.h>

struct termios sst_initial_termios;
struct termios sst_current_termios;
struct winsize sst_winsize;

#define sst_clear_line() write(1, szstr("\x1b[2K"));
#define sst_move_cursor(line, column) printf("\x1b[%zu;%zuH", line + 1, column + 1); fflush(stdout);

#define szstr(str) str, sizeof(str)
void sst_init_tui(void) {
  setvbuf(stdout, NULL, _IONBF, 0); // Turn off buffering

  printf("\x1b[?1049h"); // Switch to alternate buffer
  printf("\x1b[2J"); // Clear the screen and disable scrollback.
  sst_move_cursor((size_t)0, (size_t)0);

  if (tcgetattr(1, &sst_current_termios)) {
    perror("tcgetattr"); 
    exit(EXIT_FAILURE);
  }

  sst_initial_termios = sst_current_termios;
  sst_current_termios.c_iflag &= ~(BRKINT | ICRNL | INPCK | IXON);
  // sst_current_termios.c_oflag &= ~(OPOST);
  sst_current_termios.c_cflag |=  (CS8);
  sst_current_termios.c_lflag &= ~(ECHO | ICANON | IEXTEN | ISIG | INPCK);
  sst_current_termios.c_cc[VMIN] = 1;
  sst_current_termios.c_cc[VTIME] = 0;

  if (tcsetattr(1, TCSANOW, &sst_current_termios)) {
    perror("tcsetattr");
    exit(EXIT_FAILURE);
  }

  atexit(sst_cleanup_tui);
  signal(SIGTERM, sst_kill_tui);
  signal(SIGINT, sst_kill_tui);

  ioctl(1, TIOCGWINSZ, &sst_winsize);
}

void sst_cleanup_tui(void) {
  printf("\x1b[?1049h");
  printf("\x1b[2J");
  printf("\x1b[?1049l");
  tcsetattr(1, TCSANOW, &sst_initial_termios);
}

void sst_kill_tui() {
  exit(EXIT_FAILURE);
}

#endif

/*
------------------------------------------------------------------------------
This software is available under 2 licenses -- choose whichever you prefer.
------------------------------------------------------------------------------
ALTERNATIVE A - MIT License

Copyright (c) 2023 Aaron Speedy

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
------------------------------------------------------------------------------
ALTERNATIVE B - Public Domain (Unlicense)

This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <https://unlicense.org/>
*/

