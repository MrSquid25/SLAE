#include<stdio.h>
#include<string.h>

//Filename: skeleton_shellcode.c
//Author:  MrSquid
//Purpose: Skeleton shellcode that generates a file named shellcode with the shellcode given to the compiler 


unsigned char code[] = \

shellcode; //This will be replaced with the "mirrored" shellcode
main()
{

	printf("Shellcode Length:  %d\n", strlen(code));

	int (*ret)() = (int(*)())code;

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
