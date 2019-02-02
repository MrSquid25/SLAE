#!/bin/bash

if [ -z $2 ]; then
	echo "Usage ./compile.sh FILENAME PORT"
else
	if [ $2 -gt 65535 ] || [ 1025 -gt $2 ]; then 
		echo "Port must be between 1025 and 65535!"
	else
		#./compile.sh bind_shell 8888
		cp schema.nasm $1.nasm #Creamos el nasm para no cargarnos el esquema 

		echo "[+] Inserting port to code..."

		HEX_PORT=0x`python -c "import struct; print struct.pack('<L',$2).encode('hex')[:8]"` #Aqui usamos python para pasar el puerto a hexadecimal bien. Cogemos 8 bytes porque en ensamblador esta metiendo 8 bytes, se podria modificar el nasm y meter 4 y 4, pero como no sabemos cuales son los 4 siguientes, cogemos ocho aqui y listo.
		replace "PORT" "$HEX_PORT" -- $1.nasm  #cambia la palabra puerto por el puerto en hexadecimal

		echo '[+] Assembling with Nasm ... '
		nasm -f elf32 -o $1.o $1.nasm

		echo '[+] Linking ...'
		ld -z execstack -o $1 $1.o

		echo '[+] Done!'
		echo
		#rm $1.nasm #Eliminamos lo creado
		#rm $1.o

		echo "[+] Shellcode with port $2 is..."
		echo 
		objdump -d ./$1|grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-6 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\x/g'|paste -d '' -s |sed 's/^/"/'|sed 's/$/"/g'
	fi
fi
