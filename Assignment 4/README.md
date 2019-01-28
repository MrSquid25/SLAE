# Assignment 4

Create a custom encoding scheme like the “InserSon Encoder” we showed you. 

PoC with using execve-stack as the shellcode to encode with your schema and execute.

Solution: 
  1) Compile execve-stack.nasm and obtain the shellcode by running objdump.
  nasm -f elf32 -o execve.o execve.nasm
  ld -o execve execve.o
  objdump -d ./execve|grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-6 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\x/g'|paste -d '' -s |sed 's/^/"/'|sed 's/$/"/g'
  2) Copy the output of objdump to our python script (Mirror_Encoder.py)
  3) Run the scrip, copy the generated shellcode to our shellcode.c script and compile it.
  gcc -fno-stack-protector -z execstack shellcode.c -o shellcode
  4) Create a nasm code to revert the encoder and execute correctly the orginal shellcode.
