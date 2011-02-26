#include "asm_osx2linux.h"
#include "printf.h"
#include "libfunc.h"

extern int write(int fd, char *str, int len);
extern void exit(int code);

int main(int argc, char *argv[]) {
	int i, j, k;
	voided(3);
	write(1,"Hello\n",6); 
	i = 3;
	j = 5;
	k = mean(i, j);
	write(1,"World\n",6); 
	return k;
}
