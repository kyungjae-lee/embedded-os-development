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
		ldr r0, =0x10000000
		ldr r1, [r0]

	dummy_handler:
		b .
.end						/* end of the '.text' section */
