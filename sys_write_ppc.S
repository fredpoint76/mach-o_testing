
.text
.globl _write

_write:
	li      0,4         # syscall number (sys_write)
	sc                  # call kernel
