#!/bin/bash
#Filename: mirror-decoder-compile.sh
#Author:  MrSquid
#Purpose: Assemble mirror-decode.nasm, compile shellcode and execute it. 


echo '[+] Assembling with Nasm ... '
nasm -f elf32 -o mirror-decode.o mirror-decode.nasm

echo '[+] Linking ...'
ld -o mirror-decode mirror-decode.o

echo '[+] Done!'

sleep 2

echo "[+] Dumping disassembling code.."

objdump=$(objdump -d ./mirror-decode|grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-6 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\x/g'|paste -d '' -s |sed 's/^/"/'|sed 's/$/"/g')

echo $objdump 
sleep 3

echo "[+] Compiling shellcode.c and executing it.."

cp skeleton_shellcode.c shellcode.c  #Copy the skeleton of the shellcode (it contais a string named shellcode which it will be replaced with objdump)

replace "shellcode" "$objdump" -- shellcode.c &>/dev/null #Replace shellcode dump

sleep 2

gcc -fno-stack-protector -z execstack shellcode.c -o shellcode &>/dev/null #Compile and execute the shellcode


./shellcode
