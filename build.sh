#!/bin/sh

set -xe

CC="${CXX:-cc}"

$CC this is a test main.c -o swir -Wall -ggdb -O3 -std=c99 -pedantic
