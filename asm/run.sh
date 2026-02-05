#!/bin/sh
nasm -f elf x86a.asm -o .obj_file.o
ld -m elf_i386 .obj_file.o
./a.out