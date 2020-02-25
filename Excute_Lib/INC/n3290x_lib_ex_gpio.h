#ifndef __N3290x_LIB_EX_GPIO_H
#define __N3290x_LIB_EX_GPIO_H

#ifdef __cplusplus
extern "C" {
#endif

#include "type_s.h"
#include "n3290x_lib_ex_def.h"

typedef struct
{
	u32 GPIO_Mode;
	u32 GPIO_Pin;
	u32 GPIO_PuPd;
}GPIO_InitTypeDef;

typedef enum{
	GPIO_Mode_Out,
	GPIO_Mode_In
}GPIO_ModeTypeDef;

typedef enum{
	GPIO_Pupd_None,
	GPIO_Pupd_PU
}GPIO_PupdTypeDef;

#define GPIO_Pin_0	BIT0
#define GPIO_Pin_1	BIT1
#define GPIO_Pin_2	BIT2
#define GPIO_Pin_3	BIT3
#define GPIO_Pin_4	BIT4
#define GPIO_Pin_5	BIT5
#define GPIO_Pin_6	BIT6
#define GPIO_Pin_7	BIT7
#define GPIO_Pin_8	BIT8
#define GPIO_Pin_9	BIT9
#define GPIO_Pin_10	BIT10
#define GPIO_Pin_11	BIT11
#define GPIO_Pin_12	BIT12
#define GPIO_Pin_13	BIT13
#define GPIO_Pin_14	BIT14
#define GPIO_Pin_15	BIT15

#define GPIO_PORTA		1
#define GPIO_PORTB		2
#define GPIO_PORTC		4
#define GPIO_PORTD		8
#define GPIO_PORTE		16

void GPIO_Write(GPIO_TypeDef* GPIOx,u16 val);
void GPIO_SetBits(GPIO_TypeDef* GPIOx,u16 GPIO_PIN);
void GPIO_ResetBits(GPIO_TypeDef* GPIOx,u16 GPIO_PIN);
u16 GPIO_ReadInputData(GPIO_TypeDef* GPIOx);
u16 GPIO_ReadOutputData(GPIO_TypeDef* GPIOx);
u8 GPIO_ReadOutputDataBit(GPIO_TypeDef* GPIOx,u16 GPIO_PIN);
u8 GPIO_ReadInputDataBit(GPIO_TypeDef* GPIOx,u16 GPIO_PIN);
void GPIO_Init(GPIO_TypeDef* GPIOx,GPIO_InitTypeDef* GPIO_InitStructure);

int gpio_open(unsigned char port);
int gpio_readport(unsigned char port, unsigned short *val);
int gpio_setportdir(unsigned char port, unsigned short mask, unsigned short dir);
int gpio_setportval(unsigned char port, unsigned short mask, unsigned short val);
int gpio_setportpull(unsigned char port, unsigned short mask, unsigned short pull);
int gpio_setdebounce(unsigned int clk, unsigned char src);
void gpio_getdebounce(unsigned int *clk, unsigned char *src);
int gpio_setsrcgrp(unsigned char port, unsigned short mask, unsigned char irq);
int gpio_getsrcgrp(unsigned char port, unsigned int *val);
int gpio_setintmode(unsigned char port, unsigned short mask, unsigned short falling, unsigned short rising);
int gpio_getintmode(unsigned char port, unsigned short *falling, unsigned short *rising);
int gpio_setlatchtrigger(unsigned char src);
void gpio_getlatchtrigger(unsigned char *src);
int gpio_getlatchval(unsigned char port, unsigned short *val);
int gpio_gettriggersrc(unsigned char port, unsigned short *src);
int gpio_cleartriggersrc(unsigned char port);


#ifdef __cplusplus
}
#endif

#endif

