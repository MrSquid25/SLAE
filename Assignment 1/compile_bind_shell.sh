#!/bin/bash

#Filename: compile_bind_shell.sh
#Author:  MrSquid
#Purpose: Bind shell compiler. Filename and Port are easily configurable (see usage)


if [ -z $2 ]; then
	echo "Usage ./compile.sh FILENAME PORT"
else
	if [ $2 -gt 65535 ] || [ 1025 -gt $2 ]; then 
		echo "Port must be between 1025 and 65535!"
	else
		cp schema.nasm $1.nasm #Create a new file with the given filename  

		echo "[+] Inserting port to code..."

		HEX_PORT=0x`python -c "import struct; print struct.pack('<L',$2).encode('hex')[:8]"` 
		#Given port is set to hex 
		replace "PORT" "$HEX_PORT" -- $1.nasm  #HEX_PORT is written on $1.nasm

		echo '[+] Assembling with Nasm ... '
		nasm -f elf32 -o $1.o $1.nasm

		echo '[+] Linking ...'
		ld -z execstack -o $1 $1.o

		echo '[+] Done!'
		echo
		echo "[+] Shellcode with port $2 is..."
		echo 
		objdump -d ./$1|grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-6 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\x/g'|paste -d '' -s |sed 's/^/"/'|sed 's/$/"/g'
	fi
fi
