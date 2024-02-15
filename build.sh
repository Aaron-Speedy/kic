#!/bin/sh

set -xe

CC="${CXX:-cc}"

$CC main.c -o kic -Wall -ggdb -O3 -std=c99 -pedantic
