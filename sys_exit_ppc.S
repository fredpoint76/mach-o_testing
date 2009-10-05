
.text
.globl _exit

_exit:
	li      r0, 1       ; syscall number (sys_write)
	sc                  ; call kernel
	nop
	nop
	blr
