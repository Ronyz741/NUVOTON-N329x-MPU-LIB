#ifndef __N3290X_LIB_EX_SPIFLASH_H
#define __N3290X_LIB_EX_SPIFLASH_H

#ifdef __cplusplus
extern "C"{
#endif

#include "wblib.h"
#include "w55fa93_spi.h"

/*写基地址 blockn(块):64KB sectorn(扇区):4KB 
  一次只能写一个整块扇区，若向同一个扇区写入两次数据，则只有后面那次有效
*/
#define SPI_ADDR(blockn,sectorn)	(64*1024*blockn+4*1024*sectorn)
/*读基地址 blockn(块):64KB sectorn(扇区):4KB 
*/
#define SPI_ERASE_ADDR(blockn,sectorn)	(64*1024*blockn+4*1024*(sectorn-1))	

//与flash有关
typedef struct _SPI_Flash{
	INT (*FlashWrite)(UINT32 addr, UINT32 len, UINT32 *buf);
	INT (*FlashRead)(UINT32 addr, UINT32 len, UINT32 *buf);
	
	INT (*FlashEraseSector)(UINT32 addr, UINT32 secCount);
	INT	(*FlashEraseAllSector)(void);
	INT (*FlashInit)(void);
}SPI_Flash;
//与spi有关
typedef struct _SPI_SPI{
	INT (*Read)(INT port, INT RxBitLen, INT len, CHAR *pDst);
	INT (*Write)(INT port, INT TxBitLen, INT len, CHAR *pSrc);
	INT (*Open)(SPI_INFO_T *pInfo);
	INT (*Enable)(INT32 spiPort);
	INT (*Disable)(INT32 spiPort);
	
	INT (*SPIActive)(INT port);
	INT (*TxLen)(INT port, INT count,INT bitLen);
	void(*SetClock)(INT port,INT clock_by_MHz,INT output_by_kHz);
	void(*Ioctl)(INT32 spiPort, INT32 spiFeature, INT32 spicArg0, INT32 spicArg1);
}SPI_SPI;

typedef struct _SPI_USI{
	int (*CheckBusy)(void);
	INT16 (*ReadID)(void);
	int (*WriteEnable)(void);
	int (*WriteDisable)(void);
	int (*StatusWrite)(UINT8 data);
}SPI_USI;

typedef struct _SPI_TypeDef{
	SPI_Flash * flash;
	SPI_SPI * spi;
	SPI_USI * usi;	
}SPI_TypeDef;

extern SPI_TypeDef spi;

#ifdef __cplusplus
}
#endif

#endif
