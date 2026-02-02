section .data
hi db "Hello, x64! ", 10
hilen equ $-hi
x dw 0;
y dw 0;

section .text
global _start

_start:
	mov rax, 1
	mov rdi, 1
	mov rsi, hi
	mov rdx, hilen
	syscall

	mov rax, 60
	mov rdi, 0
	syscall
