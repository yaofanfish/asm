section .data
hi db "Hello, Square!",0   ; null-terminated string for C
hilen equ $-hi

section .text
global main
extern puts                ; tell assembler we will link with libc

main:
    push ebx
    mov eax, 4
	mov ebx, 1
    mov eax, 0             ; return 0
    ret
