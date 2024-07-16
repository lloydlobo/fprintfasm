#!/usr/bin/env bash

# ```bash
# chmod +x tests/test_main.sh
# ./tests/test_main.sh
# ```

set -xe

#------------------------------------------------------------------------------
# Prepare executable
#------------------------------------------------------------------------------

# Compile the assembly code
#
# ```bash
# nasm -f elf64 -g -Wlabel-orphan -Wno-orphan-labels -Ox main.asm
# ld -o main main.o
# ```
make -B -j4 --trace BIN=main

#------------------------------------------------------------------------------
# Tests
#------------------------------------------------------------------------------

# Test 1: Check correct output
# { ---------------------------------------------------------------------------
want_output="fprintfasm"
got_output=$(./main)

if [ "$got_output" == "$want_output" ]; then
	echo "Test 1 passed: Correct output"
else
	echo "Test 1 failed: Incorect output"
	echo "Want: $want_output"
	echo "Got: $got_output"
fi
# --------------------------------------------------------------------------- }

# Test 2: Check exit code
# { ---------------------------------------------------------------------------
want_exit_code=0
./main
got_exit_code=$?

if [ $got_exit_code -eq 0 ]; then
	echo "Test 2 passed: Correct exit code"
else
	echo "Test 2 failed: Incorect exit code"
	echo "Want: $want_exit_code"
	echo "Got: $got_exit_code"
fi
# --------------------------------------------------------------------------- }

#------------------------------------------------------------------------------
# testlogs
#------------------------------------------------------------------------------

#
# 20240716042624UTC
#
# $ ./tests/test_main.sh
# + make -B -j4 BIN=main
# nasm -f elf64 -g -Wlabel-orphan -Wno-orphan-labels -Ox main.asm
# ld -o main main.o
# + want_output=fprintfasm
# ++ ./main
# + got_output=fprintfasm
# + '[' fprintfasm == fprintfasm ']'
# + echo 'Test 1 passed: Correct output'
# Test 1 passed: Correct output
# + want_exit_code=0
# + ./main
# fprintfasm
# + got_exit_code=0
# + '[' 0 -eq 0 ']'
# + echo 'Test 2 passed: Correct exit code'
# Test 2 passed: Correct exit code

#
# 20240716041949UTC
#
# $ ./tests/test_main.sh
# + make -B -j4 BIN=main
# nasm -f elf64 -g -Wlabel-orphan -Wno-orphan-labels -Ox main.asm
# ld -o main main.o
# + want_output=fprintfasm
# ++ ./main
# + got_output=fprintfasm
# + '[' fprintfasm == fprintfasm ']'
# + echo 'Test 1 passed: Correct output'
# Test 1 passed: Correct output
