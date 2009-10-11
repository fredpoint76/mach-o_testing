.text
.globl _exit

#if __ppc__

_exit:
	li      r0, 1       ; syscall number (sys_write)
	sc                  ; call kernel
	nop
	nop
	blr

#elif __i386__

#ifdef SYSENTER

_exit:
    movl    $1, %eax    # SYS_exit=1
    popl    %edx
    pushl   $0
    movl    %esp,%ecx
    sysenter   	#   call syscall

#else

_exit:
    movl    $1, %eax    # SYS_exit=1
    int     $0x80   #   call syscall
    ret

#endif
#endif