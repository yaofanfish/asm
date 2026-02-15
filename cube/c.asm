%macro syscall 0
	int 0x80
%endmacro

section .data
hi db "Hello, Cube! ", 0xA, 0x0
hilen equ $-hi
x db 16
y db 16
z db 16
v1 db
vec dw 0,0,0,0,0,0,0,0,0

section .text
global _start
global main
_start:
	mov eax, 4
	mov ebx, 1
	mov ecx, hi
	mov edx, hilen
	syscall
	
	and esp, 0xffffff00
	jmp main

	jmp _end

main:
	

render:

_end:
	mov eax, 1
	mov ebx, 0
	syscall
