#!/bin/bash

#Filename: final_compile.sh
#Author:  MrSquid
#Purpose: Assembler and linker of the nasm code. Compiler of the shellcode.c.
#Usage: final_compile.sh filename 

echo '[+] Assembling with Nasm ... '
nasm -f elf32 -o $1.o $1.nasm

echo '[+] Linking ...'
ld -o $1 $1.o

rm $1.o 

echo '[+] Done!'

sleep 3

objdump=$(objdump -d ./$1|grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-6 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\x/g'|paste -d '' -s |sed 's/^/"/'|sed 's/$/"/g')

echo 

echo "Shellcode:" $objdump

echo 

echo "[+] Compiling shellcode.c"

cp skeleton_shellcode.c shellcode.c  #Copy the skeleton of the shellcode (it contais a string named shellcode which it will be replaced with objdump)

replace "SHELL" "$objdump" -- shellcode.c &>/dev/null #Replace shellcode dump

sleep 2

gcc -fno-stack-protector -z execstack shellcode.c -o shellcode &>/dev/null #Compile and execute the shellcode

echo "[+] Executing exec..."

./shellcode
