# Makefile

## Usage
#
# ```bash
# make -B -j4 BIN=main && make run
# ```
# Output:
#   nasm -f elf64 -g -Wlabel-orphan -Wno-orphan-labels -Ox main.asm
#   ld -o main main.o
#   ./main
#   fprintfasm
#   exit code: 0

BIN=main

SRCS=$(BIN).asm

OBJS=$(SRCS:.asm=.o)

COMPILER=nasm

COMPILER_FLAGS=-f elf64 -g
COMPILER_FLAGS+=-Wlabel-orphan -Wno-orphan-labels
# -O number Optimize branch offsets. 
#  •   -O0: No optimization 
#  •   -O1: Minimal optimization 
#  •   -Ox: Multipass optimization (default)
COMPILER_FLAGS+=-Ox
# -M Causes nasm to output Makefile-style dependencies to stdout; normal output is suppressed.
# COMPILER_FLAGS+=-M

LDLIBS=
DFLAGS=

# ```bash
# make
# ```
# Output:
#   nasm -f elf64 -g -Wlabel-orphan -Wno-orphan-labels -Ox main.asm
#   ld -o main main.o
$(BIN):
	$(COMPILER) $(COMPILER_FLAGS) $(SRCS)
	ld -o $(BIN) $(BIN).o

run:
	./$(BIN)
	@echo "exit code: $$?"

summary:
	stat $(BIN).o
	stat $(BIN)

# + yes
# + gdb -ex 'break _start' -ex run -ex 'info registers' -ex quit ./main
# ...
# Quit anyway? (y or n) [answered Y; input not from terminal]
test:
	./tests/test_gdb_main.sh 

clean:
	trash *.o
	dir

.PHONY: all clean test
