
#include "n3290x_lib_ex_spiflash.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "wblib.h"

#include "w55fa93_reg.h"
#include "w55fa93_spi.h"

int usiCheckBusy(void);
INT16 usiReadID(void);
int usiWriteEnable(void);
int usiWriteDisable(void);
int usiStatusWrite(UINT8 data);

SPI_Flash spi_flash = {
	spiFlashWrite,
	spiFlashRead,
	spiFlashEraseSector,
	spiFlashEraseAll,
	spiFlashInit
};

SPI_SPI spi_spi = {
	/*spiRead,*/NULL,
	/*spiWrite,*/NULL,
	/*spiOpen,*/NULL,
	/*spiEnable,*/NULL,
	/*spiDisable,*/NULL,
	
	/*spiActive,*/NULL,
	/*spiTxLen,*/NULL,
	/*spiSetClock,*/NULL,
	/*spiIoctl,*/NULL,
};

SPI_USI spi_usi = {
	usiCheckBusy,
	usiReadID,
	usiWriteEnable,
	usiWriteDisable,
	usiStatusWrite
};

SPI_TypeDef spi = {
	&spi_flash,
	&spi_spi,
	&spi_usi,
};

int usiCheckBusy()
{
	// check status
	outpw(REG_SPI0_SSR, inpw(REG_SPI0_SSR) | 0x01);	// CS0

	// status command
	outpw(REG_SPI0_TX0, 0x05);
	spiTxLen(0, 0, 8);
	spiActive(0);

	// get status
	while(1)
	{
		outpw(REG_SPI0_TX0, 0xff);
		spiTxLen(0, 0, 8);
		spiActive(0);
		if (((inpw(REG_SPI0_RX0) & 0xff) & 0x01) != 0x01)
			break;
	}

	outpw(REG_SPI0_SSR, inpw(REG_SPI0_SSR) & 0xfe);	// CS0

	return Successful;
}

INT16 usiReadID()
{
	UINT16 volatile id;

	outpw(REG_SPI0_SSR, inpw(REG_SPI0_SSR) | 0x01);	// CS0

	// command 8 bit
	outpw(REG_SPI0_TX0, 0x90);
	spiTxLen(0, 0, 8);
	spiActive(0);

	// address 24 bit
	outpw(REG_SPI0_TX0, 0x000000);
	spiTxLen(0, 0, 24);
	spiActive(0);

	// data 16 bit
	outpw(REG_SPI0_TX0, 0xffff);
	spiTxLen(0, 0, 16);
	spiActive(0);
	id = inpw(REG_SPI0_RX0) & 0xffff;

	outpw(REG_SPI0_SSR, inpw(REG_SPI0_SSR) & 0xfe);	// CS0

	return id;
}


int usiWriteEnable()
{
	outpw(REG_SPI0_SSR, inpw(REG_SPI0_SSR) | 0x01);	// CS0

	outpw(REG_SPI0_TX0, 0x06);
	spiTxLen(0, 0, 8);
	spiActive(0);

	outpw(REG_SPI0_SSR, inpw(REG_SPI0_SSR) & 0xfe);	// CS0

	return Successful;
}

int usiWriteDisable()
{
	outpw(REG_SPI0_SSR, inpw(REG_SPI0_SSR) | 0x01);	// CS0

	outpw(REG_SPI0_TX0, 0x04);
	spiTxLen(0, 0, 8);
	spiActive(0);

	outpw(REG_SPI0_SSR, inpw(REG_SPI0_SSR) & 0xfe);	// CS0

	return Successful;
}

int usiStatusWrite(UINT8 data)
{
	usiWriteEnable();

	outpw(REG_SPI0_SSR, inpw(REG_SPI0_SSR) | 0x01);	// CS0

	// status command
	outpw(REG_SPI0_TX0, 0x01);
	spiTxLen(0, 0, 8);
	spiActive(0);

	// write status
	outpw(REG_SPI0_TX0, data);
	spiTxLen(0, 0, 8);
	spiActive(0);

	outpw(REG_SPI0_SSR, inpw(REG_SPI0_SSR) & 0xfe);	// CS0

	return Successful;
}


/**************************************************/
INT spiFlashInit(void)
{
	static BOOL bIsSpiFlashOK = 0;
	int volatile loop;

	if (!bIsSpiFlashOK)
	{
		outpw(REG_APBCLK, inpw(REG_APBCLK) | SPIMS0_CKE);	// turn on SPI clk
		//Reset SPI controller first
		outpw(REG_APBIPRST, inpw(REG_APBIPRST) | SPI0RST);
		outpw(REG_APBIPRST, inpw(REG_APBIPRST) & ~SPI0RST);
		// delay for time
		// Delay
	    for (loop=0; loop<500; loop++);  
		//configure SPI0 interface, Base Address 0xB800C000

		/* apb clock is 48MHz, output clock is 10MHz */
		spiIoctl(0, SPI_SET_CLOCK, 48, 10000);

		//Startup SPI0 multi-function features, chip select using SS0
		outpw(REG_GPDFUN, inpw(REG_GPDFUN) | 0xFF000000);

		outpw(REG_SPI0_SSR, 0x00);		// CS active low
		outpw(REG_SPI0_CNTRL, 0x04);		// Tx: falling edge, Rx: rising edge

		if ((loop=usiReadID()) == -1)
		{
			sysprintf("read id error !! [0x%x]\n", loop&0xffff);
			return -1;
		}

		sysprintf("SPI flash id [0x%x]\n", loop&0xffff);
		usiStatusWrite(0x00);	// clear block protect
		// delay for time
		// Delay
	    for (loop=0; loop<0x20000; loop++);  

		bIsSpiFlashOK = 1;
	}	
	return 0;
 }


INT spiFlashEraseSector(UINT32 addr, UINT32 secCount)
{
	int volatile i;

	if ((addr % (64*1024)) != 0)
		return -1;

	for (i=0; i<secCount; i++)
	{
		usiWriteEnable();

		outpw(REG_SPI0_SSR, inpw(REG_SPI0_SSR) | 0x01);	// CS0

		// erase command
		outpw(REG_SPI0_TX0, 0xd8);
		spiTxLen(0, 0, 8);
		spiActive(0);

		// address
		outpw(REG_SPI0_TX0, addr+i*64*1024);
		spiTxLen(0, 0, 24);
		spiActive(0);

		outpw(REG_SPI0_SSR, inpw(REG_SPI0_SSR) & 0xfe);	// CS0

		// check status
		usiCheckBusy();
	}

	return Successful;
}


INT spiFlashEraseAll(void)
{
	usiWriteEnable();

	outpw(REG_SPI0_SSR, inpw(REG_SPI0_SSR) | 0x01);	// CS0

	outpw(REG_SPI0_TX0, 0xc7);
	spiTxLen(0, 0, 8);
	spiActive(0);

	outpw(REG_SPI0_SSR, inpw(REG_SPI0_SSR) & 0xfe);	// CS0

	// check status
	usiCheckBusy();

	return Successful;
}


INT spiFlashWrite(UINT32 addr, UINT32 len, UINT32 *buf)
{
	int volatile count=0, page, i;
	UINT32 u32Tmp;
	
	count = len / 256;
	if ((len % 256) != 0)
		count++;

	for (i=0; i<count; i++)
	{
		// check data len
		if (len >= 256)
		{
			page = 256;
			len = len - 256;
		}
		else
			page = len;

		//sysprintf("len %d page %d\n",len , page);
		usiWriteEnable();

		outpw(REG_SPI0_SSR, inpw(REG_SPI0_SSR) | 0x01);	// CS0

		// write command
		outpw(REG_SPI0_TX0, 0x02);
		spiTxLen(0, 0, 8);
		spiActive(0);

		// address
		outpw(REG_SPI0_TX0, addr+i*256);
		spiTxLen(0, 0, 24);
		spiActive(0);		
		
		// write data
		while (page > 0)
		{	
			u32Tmp = ((*buf & 0xFF) << 24) | ((*buf & 0xFF00) << 8) | ((*buf & 0xFF0000) >> 8)| ((*buf & 0xFF000000) >> 24);
			outpw(REG_SPI0_TX0, u32Tmp);
			spiTxLen(0, 0, 32);
			spiActive(0);
			buf++;
			page -=4;
		}

		outpw(REG_SPI0_SSR, inpw(REG_SPI0_SSR) & 0xfe);	// CS0

		// check status
		usiCheckBusy();
	}

	return Successful;
}


INT spiFlashRead(UINT32 addr, UINT32 len, UINT32 *buf)
{
	int volatile i;
	UINT32 u32Tmp;
	UINT8 *ptr;

	outpw(REG_SPI0_SSR, inpw(REG_SPI0_SSR) | 0x01);	// CS0

	// read command
	outpw(REG_SPI0_TX0, 03);
	spiTxLen(0, 0, 8);
	spiActive(0);

	// address
	outpw(REG_SPI0_TX0, addr);
	spiTxLen(0, 0, 24);
	spiActive(0);

	// data	 
	for (i=0; i<len/4; i++)
	{
		outpw(REG_SPI0_TX0, 0xffffffff);
		spiTxLen(0, 0, 32);
		spiActive(0);
		u32Tmp = inp32(REG_SPI0_RX0);
		*buf++ = ((u32Tmp & 0xFF) << 24) | ((u32Tmp & 0xFF00) << 8) | ((u32Tmp & 0xFF0000) >> 8)| ((u32Tmp & 0xFF000000) >> 24);
	}
	
	if(len % 4)
	{
		ptr = (UINT8 *)buf;
		for (i=0; i<(len %4); i++)
		{
			outpb(REG_SPI0_TX0, 0xff);
			spiTxLen(0, 0, 8);
			spiActive(0);
			*ptr++ = inpb(REG_SPI0_RX0);
		}		
	}	

	outpw(REG_SPI0_SSR, inpw(REG_SPI0_SSR) & 0xfe);	// CS0

	return Successful;
}


