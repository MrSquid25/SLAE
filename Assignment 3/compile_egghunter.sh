#!/bin/bash
#Filename: compile_egghunter.sh
#Author: MrSquid
#Purpose: Assembly any nasm code. In this case, Egg_Hunter.nasm

echo '[+] Assembling with Nasm ... '
nasm -f elf32 -o Egg_Hunter.o Egg_Hunter.nasm

echo '[+] Linking ...'
ld -o Egg_Hunter Egg_Hunter.o

echo '[+] Done!'

objdump=$(objdump -d ./Egg_Hunter|grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-6 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\x/g'|paste -d '' -s |sed 's/^/"/'|sed 's/$/"/g')
#Dump the shellcode

cp skeleton_shellcode.c shellcode.c #Copy the skeleton shellcode 

replace "shellcode" "$objdump" -- shellcode.c &>/dev/null #Replace shellcode dump

gcc -fno-stack-protector -z execstack shellcode.c -o shellcode &>/dev/null #Compile and execute the shellcode
