%macro print 2
	mov rsi, %1 ; these 2 infront incase the inputs ARE registers
	mov rdx, %2 ;
	mov rax, 1
	mov rdi, 1
	syscall
%endmacro
%macro input 2
	mov rsi, %1
	mov rdx, %2
	mov rax, 0
	mov rdi, 0
	syscall
%endmacro
section .data
msg db "> ", 0xA, 0x0
wrong db "invalid input: ", 0x0
wronglen equ $-wrong
wrong8 db "8: ", 0
wrong8len equ $-wrong8
_64_bit db "rax rbx rcx rdx rdi rsi rbp rsp r8  r9  r10  r11  r12  r13  r14  r15 ", 10, 0
_32_bit db "eax ebx ecx edx edi esi ebp esp r8d r9d r10d r11d r12d r13d r14d r15d", 10, 0
_16_bit db " ax  bx  cx  dx  di  si  bp  sp r8w r9w r10w r11w r12w r13w r14w r15w", 10, 0
_8l_bit db " al  bl  cl  dl dil sil bpl spl r8b r9b r10b r11b r12b r13b r14b r15b", 10, 0
_8h_bit db " ah  bh  ch  dh                                                     ", 10, 0
_reg_g_len equ $-_8h_bit

section .bss
%define userilen 64
useri resb userilen

section .text
global _start
_start:
	print msg, 2
	input useri, userilen

	mov rbp, useri
	cmp byte [rbp], '6'
	je bit64
	cmp byte [rbp], 51
	je bit32
	cmp byte [rbp], 0x31
	je bit16
	cmp byte [rbp], 0x38
	je bit8
	jmp bitu

bit64:
	print _64_bit, _reg_g_len
	jmp _start
bit32:
	print _32_bit, _reg_g_len
	jmp _start
bit16:
	print _16_bit, _reg_g_len
	jmp _start
bit8:
	cmp byte [rbp+1], "l"
	je bit8l
	cmp byte [rbp+1], "h"
	je bit8h
	print wrong8, wrong8len
	jmp bitu
bit8l:
	print _8l_bit, _reg_g_len
	jmp _start
bit8h:
	print _8h_bit, _reg_g_len
	jmp _start
bitu:
	print wrong, wronglen
	print rbp, userilen
	jmp _start
