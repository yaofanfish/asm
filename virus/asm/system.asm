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
	mov byte [%1+rax], 0
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
hi db "Hello, int system(const char* command)! ", 0xA, 0x0
hilen equ $-hi

shell db "/bin/sh", 0
argv dq shell, hyphenc, cmd, 0 ; /bin/sh -c cmd
hyphenc db "-c", 0
envp dq 0

section .bss
cmd resb 64

section .text

global _start
_start:
	mov rax, 1
	mov rdi, 1
	mov rsi, hi
	mov rdx, hilen
	syscall

	print hi, hilen
	input cmd, 63
	call system
	jmp exit


system:
	mov rax, 57
	syscall
	cmp rax, 0
	je child_process ; 0 for child, child_id for parent'
	mov rdi, rax
	mov rax, 61 ; wait
	mov rsi, 0
	mov rdx, 0
	syscall
	jmp systemdone

child_process:
	mov rax, 59 ; execve
	lea rdi, [rel shell] ; prog
	lea rsi, [rel argv] ; argv
	lea rdx, [rel envp] ; envp
	syscall

	call exit

systemdone:
	mov rax, 1
	mov rdi, 1
	mov rsi, hi
	mov rdx, hilen
	syscall
	ret

exit:
	mov rax, 60
	mov rdi, 0
	syscall

