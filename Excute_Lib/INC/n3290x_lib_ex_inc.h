
#ifndef __N3290X_LIB_EX_INC_H
#define __N3290X_LIB_EX_INC_H

#ifdef __cplusplus
extern "C" {
#endif

#include "n3290x_lib_ex_def.h"

#define LIB_EX_GPIO_ALLOW			//extern gpio lib allow
#define LIB_EX_SPIFLASH_ALLOW

#if defined LIB_EX_GPIO_ALLOW
#include "n3290x_lib_ex_gpio.h"
#endif

#if defined LIB_EX_SPIFLASH_ALLOW
#include "n3290x_lib_ex_spiflash.h"
#endif

#include "n3290x_lib_ex_fats.h"

#ifdef __cplusplus
}
#endif

#endif
