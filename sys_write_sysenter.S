
.text
.globl _write


_write:
    movl    $4, %eax    # SYS_write=4
    popl    %edx
    pushl   $0  # <= ?????
    movl    %esp,%ecx
    sysenter   	#   call syscall
