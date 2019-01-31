#!/bin/bash

echo "[+] Generating code using metasploit..."

#code=$(msfvenom -p linux/x86/exec CMD=whoami -f c)

#Obtaining shellcode from msfvenom and defining objdump variable with it

objdump="\x6a\x0b\x58\x99\x52\x66\x68\x2d\x63\x89\xe7\x68\x2f\x73\x68\x00\x68\x2f\x62\x69\x6e\x89\xe3\x52\xe8\x07\x00\x00\x00\x77\x68\x6f\x61\x6d\x69\x00\x57\x53\x89\xe1\xcd\x80";

sleep 3

echo "[+] Compiling shellcode.c"

cp skeleton_shellcode.c shellcode.c  #Copy the skeleton of the shellcode (it contais a string named shellcode which it will be replaced with objdump)

replace "shellcode" "$objdump" -- shellcode.c &>/dev/null #Replace shellcode dump

sleep 2

gcc -fno-stack-protector -z execstack shellcode.c -o shellcode &>/dev/null #Compile and execute the shellcode

echo "[+] Executing exec..."

./shellcode
