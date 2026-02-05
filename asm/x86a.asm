%macro syscall 0
    int 0x80
%endmacro
section .data
hi db "Hello, x86! ", 10
hilen equ $-hi
file db "json.json", 0
; filebuf resb 1024
x dw 0;
y dw 0;

section .bss
fd resb 4
%define filesize 256
filebuffer resb filesize
filesz resb 4

parsebuffer resb filesize
dimensionsizes resb 8

section .text
global _start

_start:
	mov eax, 4
	mov ebx, 1
	mov ecx, hi
	mov edx, hilen
	syscall

	mov eax, 5		; open()
	mov ebx, file
	mov ecx, 0		; 0 - read, 1 - write, 2 - read/write, 64 - create
	syscall

	mov dword [fd], eax	; store fd

	mov eax, 3		; read()
	mov ebx, [rel fd]	; json.json
	mov ecx, filebuffer
	mov edx, filesize
	syscall
	mov dword [filesz], eax

	mov eax, 6		; close()
	mov ebx, fd
	syscall

	mov eax, 4		; write()
	mov ebx, 1		; stdout
	mov ecx, filebuffer
	mov edx, filesize
	syscall

	jmp exit

parse:
; rd into char arrays
	call count_num
	
count_num:
; content is in filebuffer [["alice", 18], ["bob", 19]]
; size is filesz
; al cur char
; ebx dimension
; ecx index
; ebp buffer
; edx [] counter
; dimensionsizes resb 64
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	lea ebp, [rel filebuffer]
	mov ecx, ebp
	mov byte [ebp], 1
	call c1
c1:
	mov al, [ecx]
	cmp al, "["
	je yesopen
	cmp al, "]"
	je yesclose
	cmp al, ","
	je yescomma
	jmp rback
yesopen:
	add edx, 1
yesclose:
	sub edx, 1
yescomma:
	cmp edx, ebx	
	jne rback
	add byte [dimensionsizes + ebx], 1
	jmp rback
rback:
	add ecx, 1
	jmp c1
exit:
	mov eax, 1
	mov ebx, 0
	syscall
