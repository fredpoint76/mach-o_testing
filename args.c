#include "printf.h"

#ifndef __APPLE__
#define _start start
#define write _write
#define exit _exit
#endif

extern int write(int fd, char *str, int len);
extern void exit(int code);
extern unsigned int get_stack_pointer();


int main(int argc, char *argv[]) {
	int i, j;
	unsigned int *p;
	char a, b, c, d;
	unsigned int *addr_sp = (unsigned int *) get_stack_pointer();
#if 1
	printf("Stack pointer: %X\n", (unsigned int) addr_sp); 

	printf("argc: %d [%X]\n", argc, (unsigned int)&argc); 
	printf("Stack pointer: %X\n", (unsigned int) addr_sp); 
#endif

	for(i=0; i < argc; i++)
		printf("argv[%d] at %08X point to %08X => %s\n", i, 
			(unsigned int) &argv[i], (unsigned int) argv[i], argv[i]);

#if 1
#ifdef __APPLE__ 
//	for(p = (unsigned int *)0xBFFFFFF0 ; p > 0xBF000000; p--) {
	for(p = (unsigned int *)0xBFFFFFF0 ; p > 0xBFFFF600; p--) {
		j = *p;
		a = j >> 24;
		b = j >> 16;
		c = j >> 8;
		d = j;
		printf("at %X => %X : %c %c %c %c\n", (unsigned int)p , (unsigned int)j,
			a, b, c, d);
	}
#endif
#endif
	return 0;
}
