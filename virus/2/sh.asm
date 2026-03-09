[BITS 64]
; 0x1040 - e_entry
; location of start = 0x1350 offset
call tmp	; 5 bytes
tmp:
pop rbx

sub rbx, 5 ; 1 byte for call, 4 for OFFSET (8 would be for absolute)
push rdi ; argc
push rsi ; argv
push rdx ; envp
sub rsp, 8 ; 16 byte aligned

; note
; win func = 0x1126 offset
lea rax, [rbx-0x217]
call rax
; note

; MAN
add rsp, 8 ; 16 bytes aligned
pop rdx
pop rsi
pop rdi

lea rax, [rbx-0x310] ; 0x1350-0x1040 = 0x310
jmp rax




