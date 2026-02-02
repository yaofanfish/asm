extern printf
%macro syscall 0
	int 0x80
%endmacro
section .data
hi db "Hello, C! 1+1=%d", 10, 0
hilen equ $-hi

section .text
global main
main:
	mov edx, 1
	add edx, 1
	mov eax, 0
	push edx
	push hi		; "Hello, C! 1+1=%d"
	call printf	; stack is 4 byte aligned
	add esp, 8

	mov eax, 0
	ret
