	; file: main.asm

	;----------------------------------------------------------------------
	; # Build and run:
	; $ make -B -j4 BIN=main
	; ---
	; # Watch:
	; $ fd -e asm | entr -cprs 'make -B clean & make -B -j4 BIN=main'
	; ---
	; # Glossary:
	; register extended: rax rcx rdx rbx [like ACDC] (in order: 0 1 2 3)
	; register instruction pointer: rip [address of next instruction to run]
	; register (src/dst) instruction: rsi rdi [source destination] [source: top of the stack]
	; register pointer: rsp rbp [stack base]
	; `r**`: 64bit :: `e**`: 32bit
	; ---
	;----------------------------------------------------------------------

	BITS 64

	%define SYS_EXIT 60; Note: 32bit would use `mov eax, 1`
	%define SYS_WRITE 1; Note: 32bit would use: `mov eax, 4`
	%define STDOUT 1; File descriptor 1 for standard output

	segment .text; [ section ]

fprintfasm:
	mov rax, SYS_WRITE; Note: rax often used as first argument for functions
	mov rdi, STDOUT
	mov rsi, progn; Note: rsi/rdi for strings processing src/dst instructions
	mov rdx, n_progn; Length of string in `progn`
	syscall

	ret

global _start

_start:
	;fprintf(stdout, "%s", progn); Write progn to standard output
	;----------------------------------------------------------------------
	call fprintfasm
	;----------------------------------------------------------------------

	;exit(0); - sys_exit (no error)
	;----------------------------------------------------------------------
	mov     rax, SYS_EXIT
	mov     rdi, 0
	syscall ; Call the kernel. Note: 32bit would use `int 0x80` interrupt.
	;----------------------------------------------------------------------

	segment .data; [ section ]

progn:
	db 'fprintfasm', 0x0a; `0x0a` is linefeed character for newline
	n_progn  equ $-progn; > 10+1

;x:
	;resb 1

	;# $ gdb ./main
	;# (gdb) layout next
	;# # Press Enter... <RET> <RET>
	;# (gdb) break _start
	;# (gdb) break fprintfasm
	;# (gdb) break progn
	;# (gdb) run
	;#
	;# ┌─Register group: general──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
	;# │rax            0x0                 0                           rbx            0x0                 0                           rcx            0x0                 0                            │
	;# │rdx            0x0                 0                           rsi            0x0                 0                           rdi            0x0                 0                            │
	;# │rbp            0x0                 0x0                         rsp            0x7fffffffc560      0x7fffffffc560              r8             0x0                 0                            │
	;# │r9             0x0                 0                           r10            0x0                 0                           r11            0x0                 0                            │
	;# │r12            0x0                 0                           r13            0x0                 0                           r14            0x0                 0                            │
	;# │r15            0x0                 0                           rip            0x40101c            0x40101c <_start>           eflags         0x202               [ IF ]                       │
	;# │cs             0x33                51                          ss             0x2b                43                          ds             0x0                 0                            │
	;# │es             0x0                 0                           fs             0x0                 0                           gs             0x0                 0                            │
	;# │                                                                                                                                                                                              │
	;# │                                                                                                                                                                                              │
	;# │                                                                                                                                                                                              │
	;# │                                                                                                                                                                                              │
	;# │                                                                                                                                                                                              │
	;# │                                                                                                                                                                                              │
	;# │                                                                                                                                                                                              │
	;# └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
	;# │b+  0x401000 <fprintfasm>           mov    $0x1, %eax                                                                                                                                         │
	;# │    0x401005 <fprintfasm+5>         mov    $0x1, %edi                                                                                                                                         │
	;# │    0x40100a <fprintfasm+10>        movabs $0x40102d, %rsi                                                                                                                                    │
	;# │    0x401014 <fprintfasm+20>        mov    $0x11, %edx                                                                                                                                        │
	;# │    0x401019 <fprintfasm+25>        syscall                                                                                                                                                   │
	;# │    0x40101b <fprintfasm+27>        ret                                                                                                                                                       │
	;# │B+> 0x40101c <_start>               call   0x401000 <fprintfasm>                                                                                                                              │
	;# │    0x401021 <_start+5>             mov    $0x3c, %eax                                                                                                                                        │
	;# │    0x401026 <_start+10>            mov    $0x0, %edi                                                                                                                                         │
	;# │    0x40102b <_start+15>            syscall                                                                                                                                                   │
	;# │b+  0x40102d <progn>                data16 jo 0x4010a2                                                                                                                                        │
	;# │    0x401030                        imul   $0x6d736166, 0x74(%rsi), %ebp                                                                                                                      │
	;# │    0x401037                        and    %dh, (%rax)                                                                                                                                        │
	;# │    0x401039                        cs xor %ebp, (%rsi)                                                                                                                                       │
	;# │    0x40103c                        xor    %cl, (%rdx)                                                                                                                                        │
	;# │    0x40103e                        sub    $0x0, %al                                                                                                                                          │
	;# └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
	;# native process 180933 In: _start                                                                                                                                             L38   PC: 0x40101c
