#include "asm_osx2linux.h"

.text
.globl _write

_write:
################################################################################
#if defined(__ppc__) || defined(__PPC__) || defined(__ppc64__)
################################################################################
	li      r0,4
	sc
	nop
	nop
	blr

################################################################################
#elif __i386__
################################################################################
#ifdef SYSENTER
#ifdef __linux__
    movl    4(%esp), %ebx
    movl    8(%esp), %ecx
    movl    12(%esp), %edx
    movl    16(%esp), %esi
    movl    20(%esp), %edi
#endif // __linux__
    movl    $4, %eax    # SYS_write=4
    popl    %edx
    pushl   $0  # FIXME: Understand what XNU expect here
    movl    %esp,%ecx
    sysenter   	#   call syscall

#else // SYSENTER
#ifdef __linux__
    movl    4(%esp), %ebx
    movl    8(%esp), %ecx
    movl    12(%esp), %edx
    movl    16(%esp), %esi
    movl    20(%esp), %edi
#endif // __linux__
    movl    $4, %eax    # SYS_write=4
    int     $0x80   	#   call syscall
    ret
#endif // SYSENTER

################################################################################
#elif __x86_64__
################################################################################
#ifdef SYSENTER
#ifdef __linux__
    movq    4(%rsp), %rbx
    movq    8(%rsp), %rcx
    movq    12(%rsp), %rdx
    movq    16(%rsp), %rsi
    movq    20(%rsp), %rdi
    movq    $4, %rax    # SYS_write=4
    popq    %rdx
    pushq   $0
    movq    %rsp,%rcx
    sysenter   	#   call syscall
#else // __linux__
    movl    $0x02000004, %eax
    movq    %rcx, %r10
    syscall
    ret
#endif // __linux__

#else // SYSENTER
#ifdef __linux__
    movq    4(%rsp), %rbx
    movq    8(%rsp), %rcx
    movq    12(%rsp), %rdx
    movq    16(%rsp), %rsi
    movq    20(%rsp), %rdi
#endif // __linux__
    movq    $4, %rax    # SYS_exit=4
    int     $0x80   #   call syscall
    ret
#endif // SYSENTER

################################################################################
#elif defined(__arm__)
################################################################################
#ifdef __linux__
	mov		r7, #4
	swi		0
#else // Darwin
	mov		r12, #4
#if 0
	// test
	mov		r3, #10
	mov		r4, #10
	mov		r5, #10
	mov		r6, #10
	mov		r7, #4
	mov		r8, #10
	mov		r9, #10
	mov		r10, #10
	mov		r11, #10
#endif
	swi		128
#endif
	bx		lr
	#mov		pc, lr
	
################################################################################
#endif // Architectures
################################################################################
