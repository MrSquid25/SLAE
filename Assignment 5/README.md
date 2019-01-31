# Assignment 5

## What to do

• Take up at least 3 shellcode samples created using Msfpayload for linux/x86 

• Use GDB/Ndisasm/Libemu to dissect the functionality of the shellcode

• Present your analysis

## Solution

Each solution follows the same steps:

1) Obtain the shellcode of every sample using the following command
  
    msfvenom -p linux/x86/exec CMD=whoami -f c
