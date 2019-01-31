# Solution

If we dump the nasm code from the payload, here is what we can see:

    00000000  EB36              jmp short 0x38
    00000002  B805000000        mov eax,0x5
    00000007  5B                pop ebx
    00000008  31C9              xor ecx,ecx
    0000000A  CD80              int 0x80
    0000000C  89C3              mov ebx,eax
    0000000E  B803000000        mov eax,0x3
    00000013  89E7              mov edi,esp
    00000015  89F9              mov ecx,edi
    00000017  BA00100000        mov edx,0x1000
    0000001C  CD80              int 0x80
    0000001E  89C2              mov edx,eax
    00000020  B804000000        mov eax,0x4
    00000025  BB01000000        mov ebx,0x1
    0000002A  CD80              int 0x80
    0000002C  B801000000        mov eax,0x1
    00000031  BB00000000        mov ebx,0x0
    00000036  CD80              int 0x80
    00000038  E8C5FFFFFF        call 0x2
    0000003D  2F                das
    0000003E  657463            gs jz 0xa4
    00000041  2F                das
    00000042  7061              jo 0xa5
    00000044  7373              jnc 0xb9
    00000046  7764              ja 0xac
    00000048  00                db 0x00

Let's analyze the content of this step by step.

1) 00000000  EB36              jmp short 0x38 ; Jump to 0x38 

2) 00000038  E8C5FFFFFF        call 0x2 ; Execute 0x2

3)  00000002  B805000000        mov eax,0x5 ; 5 is set to EAX <=> Syscall, function open selected

    00000007  5B                pop ebx ; The content of the top of the stack is set to ebx, in this case, /etc/passwd).
    
    
    00000008  31C9              xor ecx,ecx
    0000000A  CD80              int 0x80
    0000000C  89C3              mov ebx,eax
    0000000E  B803000000        mov eax,0x3
    00000013  89E7              mov edi,esp
    00000015  89F9              mov ecx,edi
    00000017  BA00100000        mov edx,0x1000
    0000001C  CD80              int 0x80