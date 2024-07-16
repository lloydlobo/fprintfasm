# Makefile

## Usage
#
# Build And Run:
#
# ```bash
# make -B -j4 BIN=main && make run
# ```
# Output:
#
#   nasm -f elf64 -g -Wlabel-orphan -Wno-orphan-labels -Ox main.asm
#   ld -o main main.o
#   ./main
#   fprintfasm
#   exit code: 0
#
## Watch
#
# ```bash
# fd -e asm | entr -cprs 'make -B clean & make -B -j4 BIN=main && make run'
# ```
#
BIN=main

SRCS=$(BIN).asm

OBJS=$(SRCS:.asm=.o)

COMPILER=nasm

COMPILER_FLAGS=-f elf64 -g
COMPILER_FLAGS+=-Wlabel-orphan -Wno-orphan-labels

#    -O number Optimize branch offsets. 
#     •   -O0: No optimization 
#     •   -O1: Minimal optimization 
#     •   -Ox: Multipass optimization (default)
COMPILER_FLAGS+=-Ox

#    -M Causes nasm to output Makefile-style dependencies to stdout; normal output is suppressed.
#COMPILER_FLAGS+=-M

LDLIBS=
DFLAGS=

## make $(BIN)
#
# ```bash
# make
# ```
# Output:
#
#   nasm -f elf64 -g -Wlabel-orphan -Wno-orphan-labels -Ox main.asm
#   ld -o main main.o
#
$(BIN):
	$(COMPILER) $(COMPILER_FLAGS) $(SRCS)
	ld -o $(BIN) $(BIN).o

clean:
	trash *.o $(BIN)
	dir

run:
	./$(BIN)
	@echo "exit code: $$?"

summary:
	@du --all -ch --exclude='.git' && echo 
	@stat $(BIN).o && echo 
	@stat $(BIN) && echo 

## make disassemble-binary:
#
# NOTE(Lloyd): The following output had to first omot `-g` debug flag while
# compiling the object file; and then link via ld to executable `fprintfasm`.
# ```bash
# objdump -S fprintfasm
# ```
# Output:
#
#   fprintfasm:     file format elf64-x86-64
#
#
#   Disassembly of section .text:
#
#   0000000000401000 <fprintfasm>:
#     401000:       b8 01 00 00 00          mov    $0x1,%eax
#     401005:       bf 01 00 00 00          mov    $0x1,%edi
#     40100a:       48 be 00 20 40 00 00    movabs $0x402000,%rsi
#     401011:       00 00 00
#     401014:       ba 0b 00 00 00          mov    $0xb,%edx
#     401019:       0f 05                   syscall
#     40101b:       c3                      ret
#
#   000000000040101c <_start>:
#     40101c:       e8 df ff ff ff          call   401000 <fprintfasm>
#     401021:       b8 3c 00 00 00          mov    $0x3c,%eax
#     401026:       bf 00 00 00 00          mov    $0x0,%edi
#     40102b:       0f 05                   syscall
#
disassemble-binary:
	objdump -S $(BIN)

## make test
#
# ```bash
# make -B -j4 --trace test
# ```
# Output:
#
#   Makefile:70: update target 'test' due to: target is .PHONY
#   time ./tests/test_gdb_main.sh && echo "exit code: $?" && echo
#   + yes
#   + gdb -ex 'break _start' -ex run -ex 'info registers' -ex quit ./main
#   Reading symbols from ./main...
#   Breakpoint 1 at 0x40101c: file main.asm, line 45.
#   Starting program: /home/lloyd/p/lang_asm/fprintfasm/main
#   Breakpoint 1, _start () at main.asm:45
#   45              call fprintfasm
#   rax            0x0                 0
#   rbx            0x0                 0
#   rcx            0x0                 0
#   rdx            0x0                 0
#   rsi            0x0                 0
#   rdi            0x0                 0
#   rbp            0x0                 0x0
#   rsp            0x7fffffffc490      0x7fffffffc490
#   r8             0x0                 0
#   ...
#   r15            0x0                 0
#   rip            0x40101c            0x40101c <_start>
#   eflags         0x202               [ IF ]
#   cs             0x33                51
#   ss             0x2b                43
#   ds             0x0                 0
#   es             0x0                 0
#   fs             0x0                 0
#   gs             0x0                 0
#   A debugging session is active.
#           Inferior 1 [process 223551] will be killed.
#     Quit anyway? (y or n) [answered Y; input not from terminal]
#   exit code: 0
#
#   time ./tests/test_main.sh && echo "exit code: $?" && echo
#   + make -B -j4 BIN=main
#   Test 1 passed: Correct output
#   Test 2 passed: Correct exit code
#   exit code: 0
#
test: $(BIN)
	time ./tests/test_gdb_main.sh && echo "exit code: $$?" && echo
	time ./tests/test_main.sh && echo "exit code: $$?" && echo

.PHONY: all clean test
