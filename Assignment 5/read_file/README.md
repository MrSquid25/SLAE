# Solution

## Ndisasm way

If we dump the nasm code from the payload (msfvenom -p linux/x86/read_file PATH=/etc/passwd -f raw | ndisasm -u -), here is what we can see:

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

       00000007  5B                pop ebx ; The content of the top of the stack is set to ebx, 
                                            ; in this case, /etc/passwd).
    
![alt text](https://github.com/MrSquid25/SLAE/blob/master/Assignment%205/read_file/pop_ebx.PNG "Pop Ebx")

   4)  00000008  31C9              xor ecx,ecx ; Clearing out ecx, now is 0
       
   5)  0000000A  CD80              int 0x80 ; int open(const char *pathname, int flags); open(/etc/passwd, 0) 
   
       where EAX is 5=OPEN, EBX is etc/passwd=PATH and ECX is 0=FLAGS
   
   6) 0000000C  89C3              mov ebx,eax ; Eax is set to ebx
   
   7) 0000000E  B803000000        mov eax,0x3  ; Eax is set to 3 <=> Syscall, function read selected
   
   8) 00000013  89E7              mov edi,esp ; Top of stack set to edi;
   
   9) 00000015  89F9              mov ecx,edi ; Edi set to ecx;
   
   10) 00000017  BA00100000        mov edx,0x1000 ; Edx set to 4096 (decimal)
   
   11) 0000001C  CD80              int 0x80 Read function executed --> ssize_t read(int fd, void *buf, size_t count);
   
    EAX=3=READ,EBX=3=FD, ECX=EDI=BUF, EDX=4096=COUNT
   
   12) 0000001E  89C2              mov edx,eax ; EDX set to EAX
   
   13) 00000020  B804000000        mov eax,0x4 ; Eax to 4 <=> Syscall, function write
   
   14) 00000025  BB01000000        mov ebx,0x1 ; Ebx=1
   
   15) 0000002A  CD80              int 0x80 ; ssize_t write(int fd, const void *buf, size_t count);
 
    In this case, is just called but no writing is done.
 
   16) 0000002C  B801000000        mov eax,0x1 ; Exit called
   
   17) 00000031  BB00000000        mov ebx,0x0
   
   18) 00000036  CD80              int 0x80 ; Execution of exit 
   
