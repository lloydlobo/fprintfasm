#!/usr/bin/env bash

set -xe

gdb -ex "break _start" -ex "run" -ex "info registers" -ex "quit" ./main
