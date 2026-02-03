%macro print 0-2
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
%macro infop_simple_def 1-3
%ifid %3
%3%+:
%else
__section_%+%1%+:
%endif
	%ifid %2
		print %1, %2
	%else
		print %1, %1 %+ len
	%endif
	jmp _start
%endmacro
%macro bits_simp 1
	infop_simple_def _%+%1%+_bit, _reg_g_len, bit%+%1
%endmacro
section .data
hi db "Hello, world! ", 10, 0
hilen equ $-hi
msg db "> ", 0xA, 0x0
wrong db " - invalid input: ", 0x0
wronglen equ $-wrong
wrong8 db "8: ", 0
wrong8len equ $-wrong8
_64_bit db "rax rbx rcx rdx rdi rsi rbp rsp r8  r9  r10  r11  r12  r13  r14  r15 ", 10, 0
_32_bit db "eax ebx ecx edx edi esi ebp esp r8d r9d r10d r11d r12d r13d r14d r15d", 10, 0
_16_bit db " ax  bx  cx  dx  di  si  bp  sp r8w r9w r10w r11w r12w r13w r14w r15w", 10, 0
_8l_bit db " al  bl  cl  dl dil sil bpl spl r8b r9b r10b r11b r12b r13b r14b r15b", 10, 0
_8h_bit db " ah  bh  ch  dh                                                     ", 10, 0
_reg_g_len equ $-_8h_bit

syscall_no db "x86:", 10, 9, "1 - exit",9,"2 - fork",10,9,"3 - read",9,"4 -write",10,9,"5 - open",9,"6 -close",10,9,"11execve",9,"7 - wait",10,10,"x64:",10,9,"0 - read",9,"1 -write",10,9,"2 - open",9,"3 -close",10,9,"57- fork",9,"59-execve",10,9,"60- exit", 9, "61- wait", 0xA, 0x0
syscall_nolen equ $-syscall_no

data_types db "data directives: ", 10, "db - byte       - 1", 10, "dw - word       - 2", 10, "dd - doubleword - 4", 10, "dq - quadword  - 8", 10, 10, "size specifiers: ", 10, "byte  - 1", 10, "word  - 2", 10, "dword - 4", "qword - 8",10, 0
data_typeslen equ $-data_types

jumps db "JUMPS: ", 10, "unsigned/signed (often) - def", 10, 9, "ja , jg  - above/greater", 10, 9, "jae, jge - a/g OR equal", 10, 9, "jb , jl  - below/less", 10, "(non-dep) equal/not equal (often)", "jbe, jle - b/l OR eq", "je , jne eq/neq", 10, 9, "jz , jnz zero/nzero", 10, 9, 10, 0
jumpslen equ $-jumps

bash_file db "/bin/bash", 0
bash_filelen equ $-bash_file
sh_file db "/bin/sh", 0
sh_filelen equ $-sh_file

hyphenc db "-c", 0
system_cmd_array dq sh_file, hyphenc, system_cmd, 0	; /bin/sh -c "ls"

NULL_ptr dq 0

section .bss
%define userilen 64
useri resb userilen
system_cmd resb userilen
buf resb userilen
buf1 resb 1
buf4 resb 4

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
	cmp byte [rbp], 's'
	je __section_syscall_no
	cmp byte [rbp], 'd'
	je __section_data_types
	cmp byte [rbp], 'j'
	je __section_jumps
	call system
	print hi, hilen
	cmp rax, 0
	jnz bitu

; 3
bit64:
	print _64_bit, _reg_g_len
	jmp _start
infop_simple_def _32_bit, _reg_g_len, bit32
bits_simp 16
; !3
bit8:
	cmp byte [rbp+1], "l"
	je bit8l
	cmp byte [rbp+1], "h"
	je bit8h
	print wrong8, wrong8len
	jmp bitu
bits_simp 8l
bits_simp 8h
infop_simple_def syscall_no
infop_simple_def data_types
infop_simple_def jumps
system:
	mov rsi, rbp
	lea rdi, [rel system_cmd]
	mov byte [rsi + rax], 0	; change useri: \n --> \0
	call strcpy
	mov rax, 57				; fork
	syscall
	cmp rax, 0
	jz child_process
	mov rax, 61
	xor rdi, rdi			; wait for child_process
	syscall
	; startai
	; Extract exit code: WEXITSTATUS(status) = (status >> 8) & 0xFF
	shr rax, 8
	and rax, 0xFF
	; endai
	ret

child_process:
	mov rax, 59
	lea rdi, [rel sh_file]
	lea rsi, [rel system_cmd_array]
	lea rdx, [rel NULL_ptr]
	syscall
	mov rdi, rax
	mov rax, 60
	syscall

strcpy:
	mov al, [rsi]
	mov [rdi], al
	inc rsi
	inc rdi
	cmp al, 0
	jne strcpy
	ret
memcpy:
	mov al, [rsi]
	mov [rdi], al
	inc rsi
	inc rdi
	dec rcx
	cmp rcx, 0
	jle memcpy
	ret
bitu:
	add al, 0x30
	mov byte [rel buf1], al
	print buf1, userilen
	print wrong, wronglen
	print rbp, userilen
	jmp _start
