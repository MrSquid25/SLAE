# Assignment 5

## What to do

• Take up at least 3 shellcode samples created using Msfpayload for linux/x86 

• Use GDB/Ndisasm/Libemu to dissect the functionality of the shellcode

• Present your analysis

## Solution

Each solution follows the same steps:

##### GDB analysis:

   1) Obtain the shellcode of every sample using the following command

             msfvenom -p linux/x86/* -f c (where * is the payload selected)

   2) Copy the output to shellcode.c and compile it

            * gcc -fno-stack-protector -z execstack shellcode.c -o shellcode

   3) Run the binary with GDB, set a breakpoint at &code, run it and copy the nasm code.
   
            gdb -q ./shellcode
            
            break *&code
            
            run
            
            disassemble

   4) Study it!

##### Libemu Analysis:

   1) Run the following command to obtain the analysis using Libenum Sctest:
   
            msfvenom -p linux/x86/* (whatever instructions needs) -f raw | ./sctest -vvv -Ss 100000 -G bindshell.dot
            
   2) Convert .dot file to .png file (graphic flow of the instructions followed by the nasm code)
            
            dot bindshell.dot -Tpng -o bindshell.png

##### Ndisasm Analysis:

   1) Run the following command to obtain the disassembly code:
   
            msfvenom -p linux/x86/* (whatever instructions needs) -f raw | ndisasm -u -
            
Whatever option you decide is correct. In my case, I chose every option available. Read_file, chmod and execve are the payloads selected to study using these mechanisms.
