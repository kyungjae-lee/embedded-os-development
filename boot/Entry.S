#include "ARMv7AR.h"
#include "MemoryMap.h"

.text						/* start of the '.text' section */
	.code 32				/* instruction size: 32-bit */

	.global vector_start	/* '.global' corresponds to 'extern' in C */
	.global vector_end	

	vector_start:			/* label */
		ldr	pc, reset_handler_addr
		ldr pc, under_handler_addr
		ldr pc, svc_handler_addr
		ldr pc, pftch_abt_handler_addr
		ldr pc, data_abt_handler_addr
		b .
		ldr pc, irq_handler_addr
		ldr pc, fiq_handler_addr

		reset_handler_addr:		.word reset_handler
		under_handler_addr:		.word dummy_handler
		svc_handler_addr:		.word dummy_handler
		pftch_abt_handler_addr:	.word dummy_handler
		data_abt_handler_addr:	.word dummy_handler
		irq_handler_addr:		.word dummy_handler
		fiq_handler_addr:		.word dummy_handler
	vector_end:
		
	reset_handler:
		/* initialize stacks for individual operation mode */
		mrs r0, cpsr
		bic r1, r0, #0x1F
		orr r1, r1, #ARM_MODE_BIT_SVC /* operation mode */
		msr cpsr, r1
		ldr sp, =SVC_STACK_TOP

		mrs r0, cpsr
		bic r1, r0, #0x1F
		orr r1, r1, #ARM_MODE_BIT_IRQ
		msr cpsr, r1
		ldr sp, =IRQ_STACK_TOP

		mrs r0, cpsr
		bic r1, r0, #0x1F
		orr r1, r1, #ARM_MODE_BIT_FIQ
		msr cpsr, r1
		ldr sp, =FIQ_STACK_TOP

		mrs r0, cpsr
		bic r1, r0, #0x1F
		orr r1, r1, #ARM_MODE_BIT_ABT
		msr cpsr, r1
		ldr sp, =ABT_STACK_TOP

		mrs r0, cpsr
		bic r1, r0, #0x1F
		orr r1, r1, #ARM_MODE_BIT_UND
		msr cpsr, r1
		ldr sp, =UND_STACK_TOP

		mrs r0, cpsr
		bic r1, r0, #0x1F
		orr r1, r1, #ARM_MODE_BIT_SYS
		msr cpsr, r1
		ldr sp, =USRSYS_STACK_TOP

		bl main

	dummy_handler:
		b .

.end						/* end of the '.text' section */
