# Solution (Using GDB and Libemu)

Using exec_compile.sh, the final shellcode is generated and executed. We can use GDB to analyze its behaviour. 

Using Libemu, we can obtain the next image of the process flow:

![alt text](https://github.com/MrSquid25/SLAE/blob/master/Assignment%205/exec/exec.png "Flow")

If we analyze the nasm code, we can reach the following conclusions:

      push byte +0xb
      pop eax
      cwd
      push edx
      push word 0x632d
      mov edi,esp
      push dword 0x68732f
      push dword 0x6e69622f
      mov ebx,esp
      push edx
      call 0x1
      push edi
      push ebx
      mov ecx,esp
      int 0x80


1)    push byte +0xb

      pop eax
          
          EAX is set to 11 (xb in decimal) which is execve. 
      
2)    cdq

      push edx
            
          EDX is set to 0, 
    
3)    push word 0x632d

      mov edi,esp
      
          0x632d is -c in ASCII which is set to EDI.
     
 4)   push dword 0x68732f
 
      push dword 0x6e69622f
      
      mov ebx,esp
      
      push edx
      
          0x68732f is /sh and 0x6e69622f is /bash in ASCII which is set to EBX (EBX=/bin/sh)
          0 is set to the stack (push edx)
    
  5)  call 0x1
  
      push edi
      
      push ebx
      
      mov ecx,esp
      
          Here is assigned the command to execute, in my case, whoami. (ECX=WHOAMI)
          
   6) int 0x80 
   
            Execve is executed --> int execve(const char *filename, char *const argv[],char *const envp[]);
                                       execve (/bin/sh, whoami, 0)
