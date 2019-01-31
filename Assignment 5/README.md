# Assignment 5

## What to do

• Take up at least 3 shellcode samples created using Msfpayload for linux/x86 

• Use GDB/Ndisasm/Libemu to dissect the functionality of the shellcode

• Present your analysis

## Solution

Each solution follows the same steps:

GDB analysis:

   1) Obtain the shellcode of every sample using the following command

            * msfvenom -p linux/x86/* -f c (where * is the payload selected)

    2) Copy the output to shellcode.c and compile it

            * gcc -fno-stack-protector -z execstack shellcode.c -o shellcode

    3) Run the binary with GDB, set a breakpoint at &code, run it and copy the nasm code.

    4) Study it!
