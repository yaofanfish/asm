%macro syscall 0
  int 0x80
%endmacro
section .data
hi db "Hello, C"
hilen equ $-hi

section .text
global main
main:
  mov eax, 4
  mov ebx, 1
  mov ecx, hi
  mov edx, hilen
  syscall

  mov eax, 1
  mov ebx, 0
  syscall
