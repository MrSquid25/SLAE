#!/bin/bash
//Filename: Compile.sh
//Author: MrSquid
//Purpose: Assembly any nasm code. In this case, Egg_Hunter.nasm

echo '[+] Assembling with Nasm ... '
nasm -f elf32 -o Egg_Hunter.o Egg_Hunter.nasm

echo '[+] Linking ...'
ld -o Egg_Hunter Egg_Hunter.o

echo '[+] Done!'



