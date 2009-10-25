.text
.globl _exit

#if defined(__ppc__) || defined(__PPC__)
#ifdef __linux__
#define r0 0
#endif //__linux__
_exit:
	li      r0, 1       # syscall number (sys_write)
	sc                  # call kernel
	nop
	nop
	blr

#elif __i386__
#ifdef SYSENTER

_exit:
#ifdef __linux__
    movl    4(%esp), %ebx
    movl    8(%esp), %ecx
    movl    12(%esp), %edx
    movl    16(%esp), %esi
    movl    20(%esp), %edi
#endif //__linux__
    movl    $1, %eax    # SYS_exit=1
    popl    %edx
    pushl   $0
    movl    %esp,%ecx
    sysenter   	#   call syscall

#else

_exit:
#ifdef __linux__
    movl    4(%esp), %ebx
    movl    8(%esp), %ecx
    movl    12(%esp), %edx
    movl    16(%esp), %esi
    movl    20(%esp), %edi
#endif // __linux__
    movl    $1, %eax    # SYS_exit=1
    int     $0x80   #   call syscall
    ret

#endif // SYSENTER
#endif //__i386__




