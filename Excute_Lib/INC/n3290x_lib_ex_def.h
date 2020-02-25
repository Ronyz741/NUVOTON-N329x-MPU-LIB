#ifndef __N3290X_LIB_EX_DEF_H
#define __N3290X_LIB_EX_DEF_H

#ifdef __cplusplus
extern "C" {
#endif

#include "type_s.h"
#include "n3290x_lib_ex_def.h"

//GPIO_TypeDef
typedef struct{
	vu32 MODE_OUT;	//Mode set of Output
	vu32 PUEN;		//Pull-up Enable
	vu32 OUT;		//Output value
	vu32 IN;		//Input value
}GPIO_TypeDef;

//USART_TypeDef
typedef struct{
	vu32 BUFF;		//Send or Recive register
	vu32 IEQ;		//Interruput Enable register
	vu32 FCR;		//FIFO control register
	vu32 LCR;		//line control register
	vu32 MCR;		//modem control register
	vu32 MSR;		//modem Status register
	vu32 FSR;		//FIFO Status register
	vu32 ISR;		//Interrupt Status register
	vu32 TOR;		//Time out register
	vu32 BAUD;		//Baud rate Divider	register
}USART_TypeDef;

#define GPIOA	((GPIO_TypeDef *)((u32)(GPIO_BA + GPIOA_OFFSET)))
#define GPIOB	((GPIO_TypeDef *)((u32)(GPIO_BA + GPIOB_OFFSET)))
#define GPIOC	((GPIO_TypeDef *)((u32)(GPIO_BA + GPIOC_OFFSET)))
#define GPIOD	((GPIO_TypeDef *)((u32)(GPIO_BA + GPIOD_OFFSET)))
#define GPIOE	((GPIO_Typedef *)((u32)(GPIO_BA + GPIOE_OFFSET)))

//General purpose	input/output pin offset definition
#define GPIOA_OFFSET	0x0000
#define GPIOB_OFFSET	0x0010
#define GPIOC_OFFSET	0x0020
#define GPIOD_OFFSET	0x0030
#define GPIOE_OFFSET	0x0040

#define USART1	((USART_TypeDef *)((u32)(UART_BA + USART1_OFFSET)))

#define USART1_OFFSET	0x0000;



#ifdef __cplusplus
}
#endif

#endif
