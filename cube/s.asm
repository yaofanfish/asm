%macro syscall 0
	int 0x80
%endmacro
section .data
hi db "Hello, Square2! ",10,0
hilen equ $-hi
x db 16
y db 16
mat dwq
tr db 8,8
tl db -8, 8
bl db -8, -8
br db 8, -8
cords dd tr, tl, bl, br

section .bss

section .text
global main
main:
	push ebx
	mov eax, 4
	mov ebx, 1
	mov ecx, hi
	mov edx, hilen
	syscall

	jmp mloop

	pop ebx
	mov eax, 0
	ret

mloop:
	jmp mloop

render:

matmul:
	pop ebx
	mov eax, 
