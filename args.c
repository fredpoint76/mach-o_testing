#include "printf.h"
#include "strcmp.h"

extern int write(int fd, char *str, int len);
extern void exit(int code);
extern unsigned int *get_stack_pointer();
 
#ifdef __linux__
// TBD
#else
	#if defined(__ppc__) || defined(__PPC__) || defined(__ppc64__)
	// FIXME
	#elif __i386__	
	#define STACK_LINUX_BEGIN	(unsigned int *)0xBFFFFFFC
	#define STACK_LINUX_END		(unsigned int *)0xBFFDE000
	#define STACK_LINUX_SIZE	(unsigned int *)0x1FFF
	#define STACK_OSX_BEGIN 	(unsigned int *)0xBFFFFFFC
	#define STACK_OSX_END		(unsigned int *)0xBF800000
	#define STACK_OSX_SIZE		(unsigned int *)0x7FFFF0
	#elif __x86_64__
	// FIXME
	#define STACK_LINUX_BEGIN 0x0
	#define STACK_LINUX_END   0x0
	#define STACK_OSX_BEGIN  0x0
	#define STACK_OSX_END 	0x0
	#define STACK_OSX_BEGIN  0x0
	#elif __arm__
	// FIXME
	#define STACK_LINUX_BEGIN 0x0
	#define STACK_LINUX_END   0x0
	#define STACK_OSX_BEGIN  0x36000000
	#define STACK_OSX_END 	0x2ff00000
	#endif
#endif

int main(int argc, char *argv[], char *envp[]) {
	int i;
	unsigned int *addr_sp;
	addr_sp = (unsigned int *) get_stack_pointer();
	printf("Stack pointer: %X\n", (unsigned int) addr_sp); 
	printf("argc: %d [%X]\n", argc, (unsigned int)&argc); 

	printf("\n");
	for(i=0; i < argc; i++)
		printf("argv[%d] at %08X point to %08X => %s\n", i, 
			(unsigned int) &argv[i], (unsigned int) argv[i], argv[i]);

	printf("\n");
	for(i=0; envp[i]; i++)
		printf("envp[%d] at %08X point to %08X => %s\n", i, 
			(unsigned int) &envp[i], (unsigned int) envp[i], envp[i]);


#if 1
	{
		unsigned int *p, *begin, *end;
		char a, b, c, d;
		
		begin = STACK_LINUX_BEGIN;
		end = STACK_LINUX_END;
		
		for(i=0; envp[i]; i++) {
			if(strncmp(envp[i], "TERM_PROGRAM=Apple_Terminal", 27) == 0) {
				printf("We are running on OSX\n");
				begin = STACK_OSX_BEGIN ;
				end = STACK_OSX_END;
			}
		}
		for(p = begin; p >= end; p--) {
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
