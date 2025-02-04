#include <stdint.h>
#include "HalUart.h"

static void Hw_init(void);

void main(void)
{
	Hw_Init();

	uint32_t i = 100;

	while (i--)
	{
		Hal_uart_put_char('N');
	}
}

static void Hw_init(void)
{
	Hal_uart_init();
}
