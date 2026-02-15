%macro syscall 0
	int 0x80
%endmacro
section .data
hi db "Hello, Square2! ",10,0
hilen equ $-hi
x db 16
y db 16
mat dwq

section .text
global main
main:
	push ebx
	mov eax, 4
	mov ebx, 1
	mov ecx, hi
	mov edx, hilen
	syscall

	mov

	pop ebx
	mov eax, 0
	ret
