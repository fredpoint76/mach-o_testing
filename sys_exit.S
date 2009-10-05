
.text
.globl _exit


_exit:
    movl    $1, %eax    # SYS_exit=1
    int     $0x80   #   call syscall
#    leave
    ret
