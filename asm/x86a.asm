%macro syscall
    int 0x80
%endmacro
section .data
hi db "Hello, x86! ", 10
hilen equ $-hi
file db "json.json", 0
filebuf resb 1024
x dw 0;
y dw 0;

section .text
global _start

_start:
	mov eax, 4
	mov ebx, 1
	mov ecx, hi
	mov edx, hilen
	syscall

	mov eax, 2
	mov ebx, file
	mov ecx, 

exit:
	mov eax, 1
	mov ebx, 0
	syscall
