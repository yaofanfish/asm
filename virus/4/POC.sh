#!/bin/bash
echo -e "\033[1;36mProof Of Concept: pie elf executable;\ninsert shellcode into .fini; modify e_entry to go there; it jmps back to the original e_entry\033[0m\nshell code shellcode execution :D\n"
gcc c.c
echo -e "\033[36mBEFORE MODIFICATION\033[0m (saved to a.out.original)"
./a.out
echo ""
cp a.out a.out.original
nasm -f bin sh.asm
./insert.py -dq -f a.out -s sh --quiet
echo -e "\033[36mAFTER MODIFICATION\033[0m"
output="$(./a.out | tee /dev/tty)"
echo ""
if [[ $output =~ "Hello, world!" && $output =~ "REVSH" ]]; then
	echo -e "\033[32mSuccess! \033[0m"
	ext=0
else
	echo -e "\033[31mFailure. \033[0m"
	ext=1
fi
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	echo bye
	exit "$ext"
fi
