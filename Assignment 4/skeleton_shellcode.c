#include<stdio.h>
#include<string.h>

unsigned char code[] = \

shellcode;
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
