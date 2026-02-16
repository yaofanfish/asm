%macro syscall 0
	int 0x80
%endmacro
section .data
hi db "Hello, Square2! ",10,0
hilen equ $-hi
endl db 0xA

x db 16
y db 16
mat db 1, 0, 0, 1
tr db  8,  8
tl db -8,  8
bl_ db -8, -8	; line 12
br db  8, -8
cords dd tr, tl, bl_, br, 0
rcords dd rtr, rtl, rbl, rbr, 0

section .bss
rtr resb 2
rtl resb 2
rbl resb 2
rbr resb 2

renderpixels resb 64

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
	call render
	jmp mloop

render:
; 1. set the corners of the s
; 2. go through every pixel and see if it should\
	; be rendered; load into render
; 3. write to stdout
	xor ecx, ecx
	call setvecs
	ret
setvecs:	; get the r vectors
		; to their correct values by
		; 1. copy cur pos
		; 2. add corresponding vec
		; 3. matmul
		; then cmp to see if ret or no
		; note: easier to do in ax then mov
	xor edx, edx
	mov edi, dword [rel rcords]
	add edi, ecx
	mov esi, dword [rel cords]
	add esi, ecx
	; edi, esi contain pointers to desired vec
		; 1. pos
	mov al, byte [rel x]
	mov ah, byte [rel y]
		; 2. add vec
	add ax, word [esi]
	mov word [edi], ax
	call matmul
	add ecx, 4
	cmp ecx, 16
	jl setvecs
	ret

matmul:
; 1
	push ecx
	push ebx
	push eax
	xor cl, cl

	mov al, byte [edi+0]
	mov bl, byte [rel mat+0*2+0]
	imul eax, ebx
	add cl, al

	mov al, byte [edi+1]
	mov bl, byte [rel mat+1*2+1]
	imul eax, ebx
	add cl, al

	mov byte [edi+0], cl

; 2
        xor cl, cl

        mov al, byte [edi+0]
        mov bl, byte [rel mat+0*2+1]
        imul eax, ebx
        add cl, al

        mov al, byte [edi+1]
        mov bl, byte [rel mat+1*2+0]
        imul eax, ebx
        add cl, al

        mov byte [edi+1], cl

; ret
	pop eax
	pop ebx
	pop ecx
	ret

frender:
	push esi
	push edi
	push edx
	push ecx
	push eax
	mov eax, 4	; persistent write
	mov ebx, 1	; stdout
	mov ecx, 0
	mov esi, [rel renderpixels]
_frender:
	syscall
	add ecx, 1
	mov edx, ecx
	and edx, 0x00000007
	

