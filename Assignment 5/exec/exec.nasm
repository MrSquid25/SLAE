;Filename: Chmod.nasm
;Nasm code obtained from: msfvenom -p linux/x86/exec CMD=whoami -f c => Compile shellcode => Copy nasm code from gdb 
;Author: MrSquid

global _start 

section .text

_start:

	push   0xb 		; 0xb is 11 in decimal 
	pop    eax 		; Set eax to 0xb (set 11 to eax, calling execve)
	cdq   			;set edx to 0
	push   edx 		;push 0 to the stack
	push   0x632d		;Push 0x632d to the stack (0x632d is -c)
	mov    edi,esp		;Moves -c to edi 
	push   0x68732f 	;This is /sh  
	push   0x6e69622f	;This is /bin (Now we have on the stack /bin/sh -c)
	mov    ebx,esp		;Moves /bin/sh -c to ebx
	push   edx		;push 0 to the stack 
	
	call   something	;0x404064 <code+36>
	ja     somewhere 	;0x4040c7

	something:
	   jmp somewhere

	exec: ;Obtained from the final 3 lines of the png image 
		push edi
   		push ebx
   		mov ecx,esp
   		int 0x80

	somewhere:
	   call exec
	   command: db "whoami"
