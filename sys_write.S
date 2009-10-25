.text
.globl _write

#if defined(__ppc__) || defined(__PPC__)
#ifdef __linux__
#define r0 0
#endif //__linux__
_write:
	li      r0,4        # syscall number (sys_write)
	sc                  # call kernel
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
    pushl   $0  # <= ?????
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
    xor     %eax,%eax
#    leave
    ret

#endif
#endif


