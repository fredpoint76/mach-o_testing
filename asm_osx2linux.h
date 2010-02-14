#ifndef __APPLE__
#define _start start
#define write _write
#define exit _exit
#define get_stack_pointer _get_stack_pointer
#endif



#ifdef __linux__
#if defined(__ppc__) || defined(__PPC__)

#define r0 0
#define r1 1
#define r2 2
#define r3 3
#define r4 4
#define r5 5
#define r6 6
#define r7 7
#define r8 8
#define r9 9
#define r10 10
#define r11 11
#define r12 12
#define r13 13
#define r14 14
#define r15 15

#endif //__ppc__
#endif //__linux__
