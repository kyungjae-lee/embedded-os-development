#include <stdint.h>
#include "Uart.h"
#include "HalUart.h"

extern voltaile PL011_t *Uart;

void Hal_uart_init(void)
{
	// Enable UART
	Uart->uartcr.bits.UARTEN = 0;
	Uart->uartcr.bits.TXE = 1;
	Uart->uartcr.bits.RXE = 1;
	Uart->uartcr.bits.UARTEN = 1;
}

void Hal_uart_put_char(uint8_t ch)
{
	while(Uart->uartfr.bits.TXFF); // Wait until Tx buffer becomes empty
	Uart->uartdr.all = (ch & 0xFF); // Send a character to Tx buffer through DR 
}
