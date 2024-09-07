.text						/* start of the '.text' section */
	.code 32				/* instruction size: 32-bit */

	.global vector_start	/* '.global' corresponds to 'extern' in C */
	.global vector_end	

	vector_start:			/* label */
		mov r0, r1
	vector_end:
		.space 1024, 0		/* fill 1024 bytes from the current position with 0 */
.end						/* end of the '.text' section */
