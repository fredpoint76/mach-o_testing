
.text
.globl _exit

_exit:
	li      0,1         # syscall number (sys_write)
	sc                  # call kernel
