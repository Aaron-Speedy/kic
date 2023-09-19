#!/bin/sh
set -xe

gcc main.c -o swir -Wall -ggdb -O3 -std=c99 -pedantic

