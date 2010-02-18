#include "asm_osx2linux.h"

.text
.globl _get_stack_pointer

#if defined(__ppc__) || defined(__PPC__)  || defined(__ppc64__)
_get_stack_pointer:
	addze r3, r1
	blr

#elif __i386__
_get_stack_pointer:
		movl %esp, %eax
		ret

#endif //__i386__




