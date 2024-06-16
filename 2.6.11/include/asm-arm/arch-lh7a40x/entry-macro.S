/*
 * include/asm-arm/arch-lh7a40x/entry-macro.S
 *
 * Low-level IRQ helper macros for LH7A40x platforms
 *
 * This file is licensed under  the terms of the GNU General Public
 * License version 2. This program is licensed "as is" without any
 * warranty of any kind, whether express or implied.
 */

# if defined (CONFIG_ARCH_LH7A400) && defined (CONFIG_ARCH_LH7A404)
#  error "LH7A400 and LH7A404 are mutually exclusive"
# endif

# if defined (CONFIG_ARCH_LH7A400)
		.macro	disable_fiq
		.endm

		.macro	get_irqnr_and_base, irqnr, irqstat, base, tmp
		mov	\irqnr, #0
		mov	\base, #io_p2v(0x80000000)	@ APB registers
		ldr	\irqstat, [\base, #0x500]	@ PIC INTSR

1001:		movs	\irqstat, \irqstat, lsr #1	@ Shift into carry
		bcs	1008f				@ Bit set; irq found
		add	\irqnr, \irqnr, #1
		bne	1001b				@ Until no bits
		b	1009f				@ Nothing?  Hmm.
1008:		movs	\irqstat, #1			@ Force !Z
1009:
               .endm

#elif defined(CONFIG_ARCH_LH7A404)

		.macro	disable_fiq
		.endm

		.macro	get_irqnr_and_base, irqnr, irqstat, base, tmp
		mov	\irqnr, #0			@ VIC1 irq base
		mov	\base, #io_p2v(0x80000000)	@ APB registers
		add	\base, \base, #0x8000
		ldr	\tmp, [\base, #0x0030]		@ VIC1_VECTADDR
		tst	\tmp, #VA_VECTORED		@ Direct vectored
		bne	1002f
		tst	\tmp, #VA_VIC1DEFAULT		@ Default vectored VIC1
		ldrne	\irqstat, [\base, #0]		@ VIC1_IRQSTATUS
		bne	1001f
		add	\base, \base, #(0xa000 - 0x8000)
		ldr	\tmp, [\base, #0x0030]		@ VIC2_VECTADDR
		tst	\tmp, #VA_VECTORED		@ Direct vectored
		bne	1002f
		ldr	\irqstat, [\base, #0]		@ VIC2_IRQSTATUS
		mov	\irqnr, #32			@ VIC2 irq base

1001:		movs	\irqstat, \irqstat, lsr #1	@ Shift into carry
		bcs	1008f				@ Bit set; irq found
		add	\irqnr, \irqnr, #1
		bne	1001b				@ Until no bits
		b	1009f				@ Nothing?  Hmm.
1002:		and	\irqnr, \tmp, #0x3f		@ Mask for valid bits
1008:		movs	\irqstat, #1			@ Force !Z
		str	\tmp, [\base, #0x0030]		@ Clear vector
1009:
               .endm
#endif

