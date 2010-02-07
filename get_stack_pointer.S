.text
.globl _get_stack_pointer

#if defined(__ppc__) || defined(__PPC__)
#ifdef __linux__
#define r0 0
#endif //__linux__
# !!!FIXME!!! Implement this
_get_stack_pointer:
	nop
	blr

#elif __i386__
_get_stack_pointer:
		movl %esp, %eax
		ret

#endif //__i386__




