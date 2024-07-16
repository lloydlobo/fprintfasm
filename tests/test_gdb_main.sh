#!/usr/bin/env bash

set -xe

yes | gdb -ex "break _start" -ex "run" -ex "info registers" -ex "quit" ./main
