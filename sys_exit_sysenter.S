
.text
.globl _exit


_exit:
    movl    $1, %eax    # SYS_exit=1
    popl    %edx
    pushl   $0
    movl    %esp,%ecx
    sysenter   	#   call syscall
