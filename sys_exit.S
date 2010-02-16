#include "asm_osx2linux.h"

.text
.globl _exit

_exit:
################################################################################
#if defined(__ppc__) || defined(__PPC__)
################################################################################
	li      r0, 1
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
    movl    $1, %eax    # SYS_exit=1
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
    movl    $1, %eax    # SYS_exit=1
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
#endif // __linux__
    movq    $1, %rax    # SYS_exit=1
    popq    %rdx
    pushq   $0
    movq    %rsp,%rcx
    sysenter   	#   call syscall

#else // SYSENTER
#ifdef __linux__
    movq    4(%rsp), %rbx
    movq    8(%rsp), %rcx
    movq    12(%rsp), %rdx
    movq    16(%rsp), %rsi
    movq    20(%rsp), %rdi
#endif // __linux__
    movq    $1, %rax    # SYS_exit=1
    int     $0x80   #   call syscall
    ret
#endif // SYSENTER

################################################################################
#endif // Architectures
################################################################################
