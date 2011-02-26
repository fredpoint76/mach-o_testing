#if defined(__arm__)
#include "asm_osx2linux.h"
.text
.globl ___udivsi3
.globl ___umodsi3

___udivsi3:
	subs	r2, r1, #1
	bxeq	lr
	bcc	.l3
				# 0xb54
	cmp	r0, r1
	bls	.l1
				# 0xb38
	tst	r1, r2
	beq	.l2
				# 0xb44
	clz	r3, r0
	clz	r2, r1
	sub	r3, r2, r3
	rsbs	r3, r3, #31
	addne	r3, r3, r3, lsl #1
	mov	r2, #0
	addne	pc, pc, r3, lsl #2
	nop
	cmp	r0, r1, lsl #31
	adc	r2, r2, r2
	subcs	r0, r0, r1, lsl #31
	cmp	r0, r1, lsl #30
	adc	r2, r2, r2
	subcs	r0, r0, r1, lsl #30
	cmp	r0, r1, lsl #29
	adc	r2, r2, r2
	subcs	r0, r0, r1, lsl #29
	cmp	r0, r1, lsl #28
	adc	r2, r2, r2
	subcs	r0, r0, r1, lsl #28
	cmp	r0, r1, lsl #27
	adc	r2, r2, r2
	subcs	r0, r0, r1, lsl #27
	cmp	r0, r1, lsl #26
	adc	r2, r2, r2
	subcs	r0, r0, r1, lsl #26
	cmp	r0, r1, lsl #25
	adc	r2, r2, r2
	subcs	r0, r0, r1, lsl #25
	cmp	r0, r1, lsl #24
	adc	r2, r2, r2
	subcs	r0, r0, r1, lsl #24
	cmp	r0, r1, lsl #23
	adc	r2, r2, r2
	subcs	r0, r0, r1, lsl #23
	cmp	r0, r1, lsl #22
	adc	r2, r2, r2
	subcs	r0, r0, r1, lsl #22
	cmp	r0, r1, lsl #21
	adc	r2, r2, r2
	subcs	r0, r0, r1, lsl #21
	cmp	r0, r1, lsl #20
	adc	r2, r2, r2
	subcs	r0, r0, r1, lsl #20
	cmp	r0, r1, lsl #19
	adc	r2, r2, r2
	subcs	r0, r0, r1, lsl #19
	cmp	r0, r1, lsl #18
	adc	r2, r2, r2
	subcs	r0, r0, r1, lsl #18
	cmp	r0, r1, lsl #17
	adc	r2, r2, r2
	subcs	r0, r0, r1, lsl #17
	cmp	r0, r1, lsl #16
	adc	r2, r2, r2
	subcs	r0, r0, r1, lsl #16
	cmp	r0, r1, lsl #15
	adc	r2, r2, r2
	subcs	r0, r0, r1, lsl #15
	cmp	r0, r1, lsl #14
	adc	r2, r2, r2
	subcs	r0, r0, r1, lsl #14
	cmp	r0, r1, lsl #13
	adc	r2, r2, r2
	subcs	r0, r0, r1, lsl #13
	cmp	r0, r1, lsl #12
	adc	r2, r2, r2
	subcs	r0, r0, r1, lsl #12
	cmp	r0, r1, lsl #11
	adc	r2, r2, r2
	subcs	r0, r0, r1, lsl #11
	cmp	r0, r1, lsl #10
	adc	r2, r2, r2
	subcs	r0, r0, r1, lsl #10
	cmp	r0, r1, lsl #9
	adc	r2, r2, r2
	subcs	r0, r0, r1, lsl #9
	cmp	r0, r1, lsl #8
	adc	r2, r2, r2
	subcs	r0, r0, r1, lsl #8
	cmp	r0, r1, lsl #7
	adc	r2, r2, r2
	subcs	r0, r0, r1, lsl #7
	cmp	r0, r1, lsl #6
	adc	r2, r2, r2
	subcs	r0, r0, r1, lsl #6
	cmp	r0, r1, lsl #5
	adc	r2, r2, r2
	subcs	r0, r0, r1, lsl #5
	cmp	r0, r1, lsl #4
	adc	r2, r2, r2
	subcs	r0, r0, r1, lsl #4
	cmp	r0, r1, lsl #3
	adc	r2, r2, r2
	subcs	r0, r0, r1, lsl #3
	cmp	r0, r1, lsl #2
	adc	r2, r2, r2
	subcs	r0, r0, r1, lsl #2
	cmp	r0, r1, lsl #1
	adc	r2, r2, r2
	subcs	r0, r0, r1, lsl #1
	cmp	r0, r1
	adc	r2, r2, r2
	subcs	r0, r0, r1
	mov	r0, r2
	bx	lr
.l1:
	moveq	r0, #1
	movne	r0, #0
	bx	lr
.l2:
	clz	r2, r1
	rsb	r2, r2, #31
	mov	r0, r0, lsr r2
	bx	lr
.l3:
	str	lr, [sp, #-8]!
	bl	.l4
				# 0x105c
	mov	r0, #0
	ldr	pc, [sp], #8
	stmdb	sp!, {r0, r1, lr}
	bl	___udivsi3
	ldmia	sp!, {r1, r2, lr}
	mul	r3, r2, r0
	sub	r1, r1, r3
.l4:
	bx	lr

___umodsi3:
	subs	r2, r1, #1
	bcc	0xeec
	cmpne	r0, r1
	moveq	r0, #0
	tsthi	r1, r2
	andeq	r0, r0, r2
	bxls	lr
	clz	r2, r1
	clz	r3, r0
	sub	r2, r2, r3
	rsbs	r2, r2, #31
	addne	pc, pc, r2, lsl #3
	nop
	cmp	r0, r1, lsl #31
	subcs	r0, r0, r1, lsl #31
	cmp	r0, r1, lsl #30
	subcs	r0, r0, r1, lsl #30
	cmp	r0, r1, lsl #29
	subcs	r0, r0, r1, lsl #29
	cmp	r0, r1, lsl #28
	subcs	r0, r0, r1, lsl #28
	cmp	r0, r1, lsl #27
	subcs	r0, r0, r1, lsl #27
	cmp	r0, r1, lsl #26
	subcs	r0, r0, r1, lsl #26
	cmp	r0, r1, lsl #25
	subcs	r0, r0, r1, lsl #25
	cmp	r0, r1, lsl #24
	subcs	r0, r0, r1, lsl #24
	cmp	r0, r1, lsl #23
	subcs	r0, r0, r1, lsl #23
	cmp	r0, r1, lsl #22
	subcs	r0, r0, r1, lsl #22
	cmp	r0, r1, lsl #21
	subcs	r0, r0, r1, lsl #21
	cmp	r0, r1, lsl #20
	subcs	r0, r0, r1, lsl #20
	cmp	r0, r1, lsl #19
	subcs	r0, r0, r1, lsl #19
	cmp	r0, r1, lsl #18
	subcs	r0, r0, r1, lsl #18
	cmp	r0, r1, lsl #17
	subcs	r0, r0, r1, lsl #17
	cmp	r0, r1, lsl #16
	subcs	r0, r0, r1, lsl #16
	cmp	r0, r1, lsl #15
	subcs	r0, r0, r1, lsl #15
	cmp	r0, r1, lsl #14
	subcs	r0, r0, r1, lsl #14
	cmp	r0, r1, lsl #13
	subcs	r0, r0, r1, lsl #13
	cmp	r0, r1, lsl #12
	subcs	r0, r0, r1, lsl #12
	cmp	r0, r1, lsl #11
	subcs	r0, r0, r1, lsl #11
	cmp	r0, r1, lsl #10
	subcs	r0, r0, r1, lsl #10
	cmp	r0, r1, lsl #9
	subcs	r0, r0, r1, lsl #9
	cmp	r0, r1, lsl #8
	subcs	r0, r0, r1, lsl #8
	cmp	r0, r1, lsl #7
	subcs	r0, r0, r1, lsl #7
	cmp	r0, r1, lsl #6
	subcs	r0, r0, r1, lsl #6
	cmp	r0, r1, lsl #5
	subcs	r0, r0, r1, lsl #5
	cmp	r0, r1, lsl #4
	subcs	r0, r0, r1, lsl #4
	cmp	r0, r1, lsl #3
	subcs	r0, r0, r1, lsl #3
	cmp	r0, r1, lsl #2
	subcs	r0, r0, r1, lsl #2
	cmp	r0, r1, lsl #1
	subcs	r0, r0, r1, lsl #1
	cmp	r0, r1
	subcs	r0, r0, r1
	bx	lr
	str	lr, [sp, #-8]!
	bl	0x105c
	mov	r0, #0
	ldr	pc, [sp], #8
#endif
