#include "asm_osx2linux.h"

.text
.globl _write

#if defined(__ppc__) || defined(__PPC__)
_write:
	li      r0,4
	sc
	nop
	nop
	blr

#elif __i386__

#ifdef SYSENTER

_write:
#ifdef __linux__
    movl    4(%esp), %ebx
    movl    8(%esp), %ecx
    movl    12(%esp), %edx
    movl    16(%esp), %esi
    movl    20(%esp), %edi
#endif //__linux__
    movl    $4, %eax    # SYS_write=4
    popl    %edx
    pushl   $0  # FIXME: Understand what XNU expect here
    movl    %esp,%ecx
    sysenter   	#   call syscall

#else

_write:
#ifdef __linux__
    movl    4(%esp), %ebx
    movl    8(%esp), %ecx
    movl    12(%esp), %edx
    movl    16(%esp), %esi
    movl    20(%esp), %edi
#endif //__linux__
    movl    $4, %eax    # SYS_write=4
    int     $0x80   	#   call syscall
#    mov     %ebp,%esp
#    xor     %eax,%eax
#    leave
    ret

#endif
#endif


