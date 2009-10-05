
.text
.globl _write

_write:
	li      r0,4         ; syscall number (sys_write)
	sc                  ; call kernel
	nop
	nop
	blr
