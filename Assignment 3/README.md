# Assignment 3

## What to do:

-Study about the Egg Hunter shellcode

-Create a working demo of the Egghunter

-Should be configurable for different payloads

## Solutions:

1) Study about the Egg Hunter of the shellcode: 

All the information used to solve this section was found at [Safely Searching Process Virtual Address Space](http://www.hick.org/code/skape/papers/egghunt-shellcode.pdf).

First of all, what is an Egg Hunter?

As it is said in the paper, is a virtual address space where we can inject the code/payload in the current process. The egg is the marker that helps the payload to be located by the exploit. In this case, the sigaction method is the one selected to be implemented.

### Sigaction implementation

Nasm code given as a reproduction of the Egg Hunter using this technique:

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

Now that we know the exact structure for the egg hunter, we need to create the nasm code. Using this schema, here is the final code.

        global _start 

        section .text

        _start: 

        alignment:  
                or cx,0xfff         ; Page alignment

        search_shell:  
                inc ecx             ; Increment our page alignment (space "created" where the shellcode will be executed)
                push byte +0x43     ; Sigaction syscall (0x43 = 67 decimal)
                pop eax             ; eax=67
                int 0x80            ; Syscall sigaction

                cmp al,0xf2         ; If al is 242 (0xf2), then there is a sigaction error and egg hunter can not be executed
                jz alignment        ; The code keeps jumping to alignment until the comparison is set to False (searchs the egghunter)
                mov eax, 0x7A6EA1A2 ; Here is the eggcode
                mov edi, ecx        ; Moves ecx to edi (pointer to the shellcode)
                scasd   	    ; Compares (double word) eax with edi 
                jnz search_shell    ; If it did not match try the next address
                scasd
                jnz search_shell
                jmp edi             ; We found our egg identifier, pass execution

After that, we must compile the code using compile.sh. This bash script will do the following:

   * 2.1) Assembly and link the nasm code:

         echo '[+] Assembling with Nasm ... '
         nasm -f elf32 -o Egg_Hunter.o Egg_Hunter.nasm

         echo '[+] Linking ...'
         ld -o Egg_Hunter Egg_Hunter.o

         echo '[+] Done!'
  * 2.2) Obtain the shellcode from the binary created:

        objdump=$(objdump -d ./Egg_Hunter|grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-6 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\x/g'|paste -d '' -s |sed 's/^/"/'|sed 's/$/"/g')

   * 2.3) Inject the output of objdump to the shellcode.c:

         replace "shellcode" "$objdump" -- shellcode.c &>/dev/null #Replace shellcode dump
   * 2.4) Compile the shellcode and execute it

         gcc -fno-stack-protector -z execstack shellcode.c -o shellcode &>/dev/null #Compile and execute the shellcode
     
3) Should be configurable for different payloads:   

As it should be configurable to different payloads, we need to modify the original shellcode script. This is the key part of the script:

        unsigned char egg_code[] = "shellcode" //Shellcode is replace with the content of objdump
        unsigned char payload[] = "eggcode+eggcode+Shellcode" //eggcode is the "egg/mark" injected into the nasm code.

        main()
        {
                printf("Eggcode Length:  %d\n", strlen(egg_code));
                printf("Payload Length:  %d\n", strlen(payload));

                int (*ret)() = (int(*)())egg_code;

                ret();

        }

