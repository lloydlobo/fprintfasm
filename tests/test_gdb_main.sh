#!/usr/bin/env bash

# ```bash
# chmod +x tests/test_gdb_main.sh
# ./tests/test_gdb_main.sh
# ```

set -xe

# Warmup before test
stat main

# Run test via gdb aka The GNU Debugger
#
# NOTE(Lloyd): `yes` command is used to interactively help use exit gdb when
# prompted for quit:
#     Quit anyway? (y or n) [answered Y; input not from terminal]
yes | gdb -ex "break _start" -ex "run" -ex "info registers" -ex "quit" ./main
