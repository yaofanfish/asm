[BITS 64]
; 0x401040 - e_entry
call tmp
tmp:
pop rbx
push rdi ; argc
push rsi ; argv
push rdx ; envp
mov rax, 0x00401126 ; notmain 0x00401126
call rax

pop rdx
pop rsi
pop rdi

mov rax, 0x401040
jmp rax
