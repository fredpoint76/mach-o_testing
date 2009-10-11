.text
.globl _write

#if __ppc__

_write:
	li      r0,4         ; syscall number (sys_write)
	sc                  ; call kernel
	nop
	nop
	blr

#elif __i386__

#ifdef SYSENTER

_write:
    movl    $4, %eax    # SYS_write=4
    popl    %edx
    pushl   $0  # <= ?????
    movl    %esp,%ecx
    sysenter   	#   call syscall

#else

_write:
    movl    $4, %eax    # SYS_write=4
    int     $0x80   	#   call syscall
#    mov     %ebp,%esp
    xor     %eax,%eax
#    leave
    ret

#endif
#endif


