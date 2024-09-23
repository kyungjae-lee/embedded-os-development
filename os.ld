ENTRY(vector_start)			/* specifies the start symbol */
SECTIONS 					/* describes the section settings */
{
	. = 0x0;				/* the first section begins at 0x00000000 */


	.text :					/* dictates the .text section layout */
	{
		*(vector_start)
		*(.text .rodata)
	}
	.data :
	{
		*(.data)
	}
	.bss :
	{
		*(.bss)
	}
}
