# Makefile

# ## Tips
#
# $ make
# nasm -f elf64 main.asm
#
# $ make -B BIN=main_f64
# nasm -f elf64 main_f64.asm
BIN=main

SRCS=$(BIN).asm

OBJS=$(SRCS:.asm=.o)

COMPILER=nasm
COMPILER_FLAGS=-f elf64 -g
COMPILER_FLAGS+=-Wlabel-orphan -Wno-orphan-labels
# -M Causes nasm to output Makefile-style dependencies to stdout; normal output is suppressed.
# COMPILER_FLAGS+=-M
# -O number Optimize branch offsets. •   -O0: No optimization •   -O1: Minimal optimization •   -Ox: Multipass optimization (default)
COMPILER_FLAGS+=-Ox

LDLIBS=
DFLAGS=

# ## Usage
#
# $ nasm -f elf64 main.asm && ld -o main main.o && ./main
$(BIN):
	$(COMPILER) $(COMPILER_FLAGS) $(SRCS)
	stat $(BIN).o
	ld -o $(BIN) $(BIN).o
	stat $(BIN)
	./$(BIN)
	@echo "exit code: $$?"

test:
	@echo "unimplemented"

clean:
	trash *.o
	dir

.PHONY: all clean test
