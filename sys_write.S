
.text
.globl _write


_write:
    movl    $4, %eax    # SYS_write=4
    int     $0x80   	#   call syscall
#    mov     %ebp,%esp
    xor     %eax,%eax
#    leave
    ret
