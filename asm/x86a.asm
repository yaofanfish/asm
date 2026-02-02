%macro syscall
    int 0x80
%endmacro
section .data
hi db "Hello, x86! ", 10
hilen equ $-hi
x dw 0;
y dw 0;

section .text
global _start

_start:
	mov eax, 1
	mov ebx, 1
	mov ecx, hi
	mov edx, hilen
	syscall

	mov rax, 60
	mov rdi, 0
	syscall
