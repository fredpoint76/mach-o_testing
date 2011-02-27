#include "printf.h"
#if 0
#include "strcmp.h"
#endif
extern int write(int fd, char *str, int len);
extern void exit(int code);
extern unsigned int *get_stack_pointer();

#ifdef __linux__
// TBD
#else
	#if defined(__ppc__) || defined(__PPC__) || defined(__ppc64__)
	#elif __i386__
	#define START_BEGIN 0xBFFFFFF0
	#define STACK_END 	0xBF800000
	#elif __x86_64__
	// FIXME
	#define START_BEGIN 0x0
	#define STACK_END 	0x0
	#elif __arm__
	#define START_BEGIN 0x2ffff935
	#define STACK_END 	0x2ffff1c0
	#endif
#endif

int main(int argc, char *argv[], char *envp[]) {
	int i;
	unsigned int *addr_sp;
	addr_sp = (unsigned int *) get_stack_pointer();
	printf("Stack pointer: %X\n", (unsigned int) addr_sp); 
	printf("argc: %d [%X]\n", argc, (unsigned int)&argc); 
	printf("Stack pointer: %X\n", (unsigned int) addr_sp); 

	printf("\n");
	for(i=0; i < argc; i++)
		printf("argv[%d] at %08X point to %08X => %s\n", i, 
			(unsigned int) &argv[i], (unsigned int) argv[i], argv[i]);

	printf("\n");
	for(i=0; envp[i]; i++)
		printf("envp[%d] at %08X point to %08X => %s\n", i, 
			(unsigned int) &envp[i], (unsigned int) envp[i], envp[i]);


#if 0
	{
		unsigned int *p;
		char a, b, c, d;

		printf("\n");
		for(i=0; envp[i]; i++) {
			if(strncmp(envp[i], "TERM_PROGRAM", 12) == 0) {
				
			}
		}
		for(p = (unsigned int *)START_BEGIN; p >= (unsigned int *)STACK_END; p--) {
			i = *p;
			a = i >> 24;
			b = i >> 16;
			c = i >> 8;
			d = i;
			printf("at %X => %X : %c %c %c %c\n", (unsigned int)p ,
					(unsigned int)i, a, b, c, d);
		}
	}
#endif
	return 0;
}
