;/*****************************************************************************/
;/* SAM9260.S: Startup file for Atmel AT91SAM9260 device series               */
;/*****************************************************************************/
;/* <<< Use Configuration Wizard in Context Menu >>>                          */ 
;/*****************************************************************************/
;/* This file is part of the uVision/ARM development tools.                   */
;/* Copyright (c) 2005-2009 Keil Software. All rights reserved.               */
;/* This software may only be used under the terms of a valid, current,       */
;/* end user licence from KEIL for a compatible version of KEIL software      */
;/* development tools. Nothing else gives you the right to use this software. */
;/*****************************************************************************/


; The Startup code is executed after CPU Reset. This file may be 
; translated with the following SET symbols. In uVision these SET 
; symbols are entered under Options - ASM - Define.
; 
;  SIZE_INT_INFO: size of program image is coded instead of Reserved vector
;                 at address 0x14, if code is located in Internal RAM.
;
;  SIZE_EXT_INFO: size of program image is coded instead of Reserved vector
;                 at address 0x14, if code is located in External SDRAM.
;
;  REMAP:         when set the startup code remaps exception vectors from
;                 on-chip RAM to address 0.
;
;  VEC_TO_RAM:    when set the startup code copies exception vectors 
;                 from Image Load Address to on-chip RAM.
;
;  NO_EBI_INIT:   when set the EBI is not initialized in startup
;                 and it is used when EBI is initialized from debugger 
;                 enviroment (using the debug script).
;
;  NO_SDRAM_INIT: when set the SDRAM controller is not initialized in startup
;                 and it is used when SDRAM controller is initialized from 
;                 debugger enviroment (using the debug script).
;
;  NO_PMC_INIT:   when set the Power Management Controller and system clock 
;                 are not initialized in startup and it is used when PLL is 
;                 initialized from debugger enviroment (using the debug script).


; Standard definitions of Mode bits and Interrupt (I & F) flags in PSRs

Mode_USR        EQU     0x10
Mode_FIQ        EQU     0x11
Mode_IRQ        EQU     0x12
Mode_SVC        EQU     0x13
Mode_ABT        EQU     0x17
Mode_UND        EQU     0x1B
Mode_SYS        EQU     0x1F

I_Bit           EQU     0x80            ; when I bit is set, IRQ is disabled
F_Bit           EQU     0x40            ; when F bit is set, FIQ is disabled


; Internal Memory Base Addresses
IROM_BASE       EQU     0x00100000
IRAM_BASE       EQU     0x00200000

;// <h> Stack Configuration (Stack Sizes in Bytes)
;//   <o0> Undefined Mode      <0x0-0xFFFFFFFF:8>
;//   <o1> Supervisor Mode     <0x0-0xFFFFFFFF:8>
;//   <o2> Abort Mode          <0x0-0xFFFFFFFF:8>
;//   <o3> Fast Interrupt Mode <0x0-0xFFFFFFFF:8>
;//   <o4> Interrupt Mode      <0x0-0xFFFFFFFF:8>
;//   <o5> User/System Mode    <0x0-0xFFFFFFFF:8>
;// </h>

UND_Stack_Size  EQU     0x00000000
SVC_Stack_Size  EQU     0x00000008
ABT_Stack_Size  EQU     0x00000000
FIQ_Stack_Size  EQU     0x00000000
IRQ_Stack_Size  EQU     0x00000080
USR_Stack_Size  EQU     0x00000400

ISR_Stack_Size  EQU     (UND_Stack_Size + SVC_Stack_Size + ABT_Stack_Size + \
                         FIQ_Stack_Size + IRQ_Stack_Size)

                AREA    STACK, NOINIT, READWRITE, ALIGN=3

Stack_Mem       SPACE   USR_Stack_Size
__initial_sp    SPACE   ISR_Stack_Size
Stack_Top


;// <h> Heap Configuration
;//   <o>  Heap Size (in Bytes) <0x0-0xFFFFFFFF>
;// </h>

Heap_Size       EQU     0x00000000

                AREA    HEAP, NOINIT, READWRITE, ALIGN=3
__heap_base
Heap_Mem        SPACE   Heap_Size
__heap_limit


;----------------------- PIOs Definitions --------------------------------------

; Parallel Input/Output Controller (PIO) User Interface
PIOA_BASE       EQU     0xFFFFF400      ; PIO A                   Base Address
PIOB_BASE       EQU     0xFFFFF600      ; PIO B                   Base Address
PIOC_BASE       EQU     0xFFFFF800      ; PIO C                   Base Address
PIO_PER_OFS     EQU     0x00            ; PIO Enable Register     Address Offset
PIO_PDR_OFS     EQU     0x04            ; PIO Disable Register    Address Offset
PIO_OER_OFS     EQU     0x10            ; PIO Output Enable Reg   Address Offset
PIO_ODR_OFS     EQU     0x14            ; PIO Output Disable Reg  Address Offset
PIO_MDER_OFS    EQU     0x50            ; PIO Multi-Driver En Reg Address Offset
PIO_MDDR_OFS    EQU     0x54            ; PIO Multi-Driver Ds Reg Address Offset
PIO_PUDR_OFS    EQU     0x60            ; PIO Pull-up Disable Reg Address Offset
PIO_PUER_OFS    EQU     0x64            ; PIO Pull-up Enable Reg  Address Offset
PIO_ASR_OFS     EQU     0x70            ; PIO Periph A Select Reg Address Offset
PIO_BSR_OFS     EQU     0x74            ; PIO Periph B Select Reg Address Offset


;----------------------- Power Management Controller (PMC) Definitions ---------

; Power Management Controller (PMC) definitions
PMC_BASE        EQU     0xFFFFFC00      ; PMC                     Base Address
PMC_SCER_OFS    EQU     0x00            ; Sys Clk Enable Reg      Address Offset
PMC_SCDR_OFS    EQU     0x04            ; Sys Clk Disable Reg     Address Offset
PMC_SCSR_OFS    EQU     0x08            ; Sys Clk Status Reg      Address Offset
PMC_PCER_OFS    EQU     0x10            ; Periph Clk Enable Reg   Address Offset
PMC_PCDR_OFS    EQU     0x14            ; Periph Clk Disable Reg  Address Offset
PMC_PCSR_OFS    EQU     0x18            ; Periph Clk Status Reg   Address Offset
CKGR_MOR_OFS    EQU     0x20            ; Main Oscillator Reg     Address Offset
CKGR_MCFR_OFS   EQU     0x24            ; Main Clock Freq Reg     Address Offset
CKGR_PLLAR_OFS  EQU     0x28            ; PLLA Reg                Address Offset
CKGR_PLLBR_OFS  EQU     0x2C            ; PLLA Reg                Address Offset
PMC_MCKR_OFS    EQU     0x30            ; Master Clock Reg        Address Offset
PMC_PCK0_OFS    EQU     0x40            ; Programmable Clk 0 Reg  Address Offset
PMC_PCK1_OFS    EQU     0x44            ; Programmable Clk 1 Reg  Address Offset
PMC_PCK2_OFS    EQU     0x48            ; Programmable Clk 2 Reg  Address Offset
PMC_PCK3_OFS    EQU     0x4C            ; Programmable Clk 3 Reg  Address Offset
PMC_IER_OFS     EQU     0x60            ; Interrupt Enable  Reg   Address Offset
PMC_IDR_OFS     EQU     0x64            ; Interrupt Disable Reg   Address Offset
PMC_SR_OFS      EQU     0x68            ; Status Register         Address Offset
PMC_IMR_OFS     EQU     0x6C            ; Interrupt Mask Reg      Address Offset
PMC_PLLICPR_OFS EQU     0x80            ; Charge Pump Current Reg Address Offset

; Bit constants
PMC_MOSCEN      EQU     (1<<0)          ; Main Oscillator Enable
PMC_MUL         EQU     (0x7FF<<16)     ; PLL Multiplier
PMC_MOSCS       EQU     (1<<0)          ; Main Oscillator Stable
PMC_LOCKA       EQU     (1<<1)          ; PLL A Lock Status
PMC_LOCKB       EQU     (1<<2)          ; PLL A Lock Status
PMC_MCKRDY      EQU     (1<<3)          ; Master Clock Status

;// <e> Power Management Controller (PMC)
;//   <h> System Clock Enable Register (PMC_SCER)
;//     <o1.0>      PCK: Processor Clock Enable
;//     <o1.6>      UHP: USB Host Port Clock Enable
;//     <o1.7>      UDP: USB Device Port Clock Enable
;//     <o1.8>      PCK0: Programmable Clock 0 Output Enable
;//     <o1.9>      PCK1: Programmable Clock 1 Output Enable
;//   </h>
;//
;//   <h> Peripheral Clock Enable Register (PMC_PCER)
;//     <o2.2>      PID2: Parallel IO Controller A Enable
;//     <o2.3>      PID3: Parallel IO Controller B Enable
;//     <o2.4>      PID4: Parallel IO Controller C Enable
;//     <o2.5>      PID5: Analog to Digital Converter Enable
;//     <o2.6>      PID6: USART0 Enable
;//     <o2.7>      PID7: USART1 Enable
;//     <o2.8>      PID8: USART2 Enable
;//     <o2.9>      PID9: Multimedia Card Interface 0 Enable
;//     <o2.10>     PID10: USB Device Port Enable
;//     <o2.11>     PID11: Two-Wire Interface Enable
;//     <o2.12>     PID12: Serial Peripheral Interface 0 Enable
;//     <o2.13>     PID13: Serial Peripheral Interface 1 Enable
;//     <o2.14>     PID14: Serial Synchronous Controller 0 Enable
;//     <o2.17>     PID17: Timer Counter 0 Enable
;//     <o2.18>     PID18: Timer Counter 1 Enable
;//     <o2.19>     PID19: Timer Counter 2 Enable
;//     <o2.20>     PID20: USB Host Port Enable
;//     <o2.21>     PID21: Ethernet MAC Enable
;//     <o2.22>     PID22: Image Sensor Interface Enable
;//     <o2.23>     PID23: USART3 Enable
;//     <o2.24>     PID24: USART4 Enable
;//     <o2.25>     PID25: USART5 Enable
;//     <o2.26>     PID26: Timer Couter 3 Enable
;//     <o2.27>     PID27: Timer Couter 4 Enable
;//     <o2.28>     PID28: Timer Couter 5 Enable
;//     <o2.29>     PID29: Advanced Interrupt Controller (IRQ0) Enable
;//     <o2.30>     PID30: Advanced Interrupt Controller (IRQ1) Enable
;//     <o2.31>     PID31: Advanced Interrupt Controller (IRQ2) Enable
;//   </h>
;//
;//   <h> Main Oscillator Register (CKGR_MOR)
;//     <o3.0>      MOSCEN: Main Oscillator Enable
;//     <o3.8..15>  OSCOUNT: Main Oscillator Startup Time <0-255>
;//   </h>
;//
;//   <h> Clock Generator Phase Locked Loop A Register (CKGR_PLLAR)
;//                   <i> PLL A Freq = (Main CLOCK Freq / DIVA) * (MULA + 1)
;//                   <i> Example: XTAL = 18.432 MHz, DIVA = 14, MULA = 72  =>  PLLA = 96.1097 MHz
;//     <o4.0..7>   DIVA: PLL Divider A <0-255>
;//                   <i> 0        - Divider output is 0
;//                   <i> 1        - Divider is bypassed
;//                   <i> 2 .. 255 - Divider output is the Main Clock divided by DIVA
;//     <o4.8..13>  PLLACOUNT: PLL A Counter <0-63>
;//                   <i> Number of Slow Clocks before the LOCKA bit is set in 
;//                   <i> PMC_SR after CKGR_PLLAR is written
;//     <o4.14..15> OUTA: PLL A Clock Frequency Range
;//                   <0=> 80 .. 160MHz   <1=> Reserved
;//                   <2=> 150 .. 240MHz  <3=> Reserved
;//     <o4.16..26> MULA: PLL A Multiplier <0-2047>
;//                   <i> 0         - The PLL A is deactivated
;//                   <i> 1 .. 2047 - The PLL A Clock frequency is the PLL a input 
;//                   <i>             frequency multiplied by MULA + 1
;//   </h>
;//
;//   <h> Clock Generator Phase Locked Loop B Register (CKGR_PLLBR)
;//                   <i> PLL B Freq = (Main CLOCK Freq / DIVB) * (MULB + 1)
;//     <o5.0..7>   DIVB: PLL Divider B <0-255>
;//                   <i> 0        - Divider output is 0
;//                   <i> 1        - Divider is bypassed
;//                   <i> 2 .. 255 - Divider output is the Main Clock divided by DIVB
;//     <o5.8..13>  PLLBCOUNT: PLL B Counter <0-63>
;//                   <i> Number of Slow Clocks before the LOCKB bit is set in 
;//                   <i> PMC_SR after CKGR_PLLBR is written
;//     <o5.14..15> OUTB: PLL B Clock Frequency Range
;//                   <0=> 80 .. 160MHz   <1=> Reserved
;//                   <2=> 150 .. 240MHz  <3=> Reserved
;//     <o5.16..26> MULB: PLL B Multiplier <0-2047>
;//                   <i> 0         - The PLL B is deactivated
;//                   <i> 1 .. 2047 - The PLL B Clock frequency is the PLL a input 
;//                   <i>             frequency multiplied by MULB + 1
;//     <o5.28>     USB_96M: Divider by 2 Enable
;//                   <i> 0 - USB ports = PLL B Clock, PLL B Clock must be 48MHz
;//                   <i> 1 - USB ports = PLL B Clock / 2, PLL B Clock must be 96MHz
;//   </h>
;//
;//   <h> Master Clock Register (CKGR_MCKR)
;//     <o6.0..1>   CSS: Master Clock Selection
;//                   <0=> Slow Clock
;//                   <1=> Main Clock
;//                   <2=> PLL A Clock
;//                   <3=> PLL B Clock
;//     <o6.2..4>   PRES: Master Clock Prescaler
;//                   <0=> Clock        <1=> Clock / 2
;//                   <2=> Clock / 4    <3=> Clock / 8
;//                   <4=> Clock / 16   <5=> Clock / 32
;//                   <6=> Clock / 64   <7=> Reserved
;//     <o6.8..9>   MDIV: Master Clock Division
;//                   <0=> Processor Clock = Master Clock
;//                   <1=> Processor Clock = Master Clock / 2
;//                   <2=> Processor Clock = Master Clock / 4
;//                   <3=> Reserved
;//   </h>
;//
;//   <h> Programmable Clock Register 0 (PMC_PCK0)
;//     <o7.0..1>   CSS: Master Clock Selection
;//                   <0=> Slow Clock
;//                   <1=> Main Clock
;//                   <2=> PLL A Clock
;//                   <3=> PLL B Clock
;//     <o7.2..4>   PRES: Programmable Clock Prescaler
;//                   <0=> Clock        <1=> Clock / 2
;//                   <2=> Clock / 4    <3=> Clock / 8
;//                   <4=> Clock / 16   <5=> Clock / 32
;//                   <6=> Clock / 64   <7=> Reserved
;//   </h>
;//
;//   <h> Programmable Clock Register 1 (PMC_PCK1)
;//     <o8.0..1>   CSS: Master Clock Selection
;//                   <0=> Slow Clock
;//                   <1=> Main Clock
;//                   <2=> PLL A Clock
;//                   <3=> PLL B Clock
;//     <o8.2..4>   PRES: Programmable Clock Prescaler
;//                   <0=> None         <1=> Clock / 2
;//                   <2=> Clock / 4    <3=> Clock / 8
;//                   <4=> Clock / 16   <5=> Clock / 32
;//                   <6=> Clock / 64   <7=> Reserved
;//   </h>
;//
;//   <h> Programmable Clock Register 2 (PMC_PCK2)
;//     <o9.0..1>   CSS: Master Clock Selection
;//                   <0=> Slow Clock
;//                   <1=> Main Clock
;//                   <2=> PLL A Clock
;//                   <3=> PLL B Clock
;//     <o9.2..4>   PRES: Programmable Clock Prescaler
;//                   <0=> None         <1=> Clock / 2
;//                   <2=> Clock / 4    <3=> Clock / 8
;//                   <4=> Clock / 16   <5=> Clock / 32
;//                   <6=> Clock / 64   <7=> Reserved
;//   </h>
;//
;//   <h> Programmable Clock Register 3 (PMC_PCK3)
;//     <o10.0..1>  CSS: Master Clock Selection
;//                   <0=> Slow Clock
;//                   <1=> Main Clock
;//                   <2=> PLL A Clock
;//                   <3=> PLL B Clock
;//     <o10.2..4>  PRES: Programmable Clock Prescaler
;//                   <0=> None         <1=> Clock / 2
;//                   <2=> Clock / 4    <3=> Clock / 8
;//                   <4=> Clock / 16   <5=> Clock / 32
;//                   <6=> Clock / 64   <7=> Reserved
;//   </h>
;// </e>
PMC_SETUP       EQU     1
PMC_SCER_Val    EQU     0x00000001
PMC_PCER_Val    EQU     0x0000001C
CKGR_MOR_Val    EQU     0x00000701
CKGR_PLLAR_Val  EQU     0x20483F0E
CKGR_PLLBR_Val  EQU     0x00000000
PMC_MCKR_Val    EQU     0x00000002
PMC_PCK0_Val    EQU     0x00000000
PMC_PCK1_Val    EQU     0x00000000
PMC_PCK2_Val    EQU     0x00000000
PMC_PCK3_Val    EQU     0x00000000


;----------------------- MATRIX Definitions ------------------------------------

; Bus Matrix (MATRIX) User Interface
; |- Chip Configuration (CCFG) User Interface
MATRIX_BASE      EQU    0xFFFFEE00      ; Bus Matrix              Base Address
MATRIX_MCFG0_OFS EQU    0x00            ; Master Config Reg 0     Address Offset
MATRIX_MCFG1_OFS EQU    0x04            ; Master Config Reg 1     Address Offset
MATRIX_MCFG2_OFS EQU    0x08            ; Master Config Reg 2     Address Offset
MATRIX_MCFG3_OFS EQU    0x0C            ; Master Config Reg 3     Address Offset
MATRIX_MCFG4_OFS EQU    0x10            ; Master Config Reg 4     Address Offset
MATRIX_MCFG5_OFS EQU    0x14            ; Master Config Reg 5     Address Offset
MATRIX_SCFG0_OFS EQU    0x40            ; Slave Config Reg 0      Address Offset
MATRIX_SCFG1_OFS EQU    0x44            ; Slave Config Reg 1      Address Offset
MATRIX_SCFG2_OFS EQU    0x48            ; Slave Config Reg 2      Address Offset
MATRIX_SCFG3_OFS EQU    0x4C            ; Slave Config Reg 3      Address Offset
MATRIX_SCFG4_OFS EQU    0x50            ; Slave Config Reg 4      Address Offset
MATRIX_PRAS0_OFS EQU    0x80            ; Priority A for Slave 0  Address Offset
MATRIX_PRAS1_OFS EQU    0x88            ; Priority A for Slave 1  Address Offset
MATRIX_PRAS2_OFS EQU    0x90            ; Priority A for Slave 2  Address Offset
MATRIX_PRAS3_OFS EQU    0x98            ; Priority A for Slave 3  Address Offset
MATRIX_PRAS4_OFS EQU    0xA0            ; Priority A for Slave 4  Address Offset
MATRIX_MRCR_OFS  EQU    0x100           ; Master Remap Control R  Address Offset
EBI_CSA_OFS      EQU    0x11C           ; EBI Chip Select Assign  Address Offset

; Constants
EBI_CS0_ADDRESS EQU     0x10000000      ; Start of memory addressed by CS0
EBI_CS1_ADDRESS EQU     0x20000000      ; Start of memory addressed by CS1
EBI_CS2_ADDRESS EQU     0x30000000      ; Start of memory addressed by CS2
EBI_CS3_ADDRESS EQU     0x40000000      ; Start of memory addressed by CS3
EBI_CS4_ADDRESS EQU     0x50000000      ; Start of memory addressed by CS4
EBI_CS5_ADDRESS EQU     0x60000000      ; Start of memory addressed by CS5
EBI_CS6_ADDRESS EQU     0x70000000      ; Start of memory addressed by CS6
EBI_CS7_ADDRESS EQU     0x80000000      ; Start of memory addressed by CS7

;// <e> Bus Matrix (MATRIX)
MATRIX_SETUP    EQU     0

;//   <h> Bus Matrix Master Configuration Registers
;//     <h>  Bus Matrix Master Configuration Registers 0 (MATRIX_MCFG0)
;//       <o0.0..2> ULBT: Undefined Length Burst Type 
;//                   <0=> Infinite Length Burst
;//                   <1=> Single Access
;//                   <2=> Four Beat Burst
;//                   <3=> Eight Beat Burst
;//                   <4=> Sixteen Beat Burst
;//     </h>
;//     <h>  Bus Matrix Master Configuration Registers 1 (MATRIX_MCFG1)
;//       <o1.0..2> ULBT: Undefined Length Burst Type 
;//                   <0=> Infinite Length Burst
;//                   <1=> Single Access
;//                   <2=> Four Beat Burst
;//                   <3=> Eight Beat Burst
;//                   <4=> Sixteen Beat Burst
;//     </h>
;//     <h>  Bus Matrix Master Configuration Registers 2 (MATRIX_MCFG2)
;//       <o2.0..2> ULBT: Undefined Length Burst Type 
;//                   <0=> Infinite Length Burst
;//                   <1=> Single Access
;//                   <2=> Four Beat Burst
;//                   <3=> Eight Beat Burst
;//                   <4=> Sixteen Beat Burst
;//     </h>
;//     <h>  Bus Matrix Master Configuration Registers 3 (MATRIX_MCFG3)
;//       <o3.0..2> ULBT: Undefined Length Burst Type 
;//                   <0=> Infinite Length Burst
;//                   <1=> Single Access
;//                   <2=> Four Beat Burst
;//                   <3=> Eight Beat Burst
;//                   <4=> Sixteen Beat Burst
;//     </h>
;//     <h>  Bus Matrix Master Configuration Registers 4 (MATRIX_MCFG4)
;//       <o4.0..2> ULBT: Undefined Length Burst Type 
;//                   <0=> Infinite Length Burst
;//                   <1=> Single Access
;//                   <2=> Four Beat Burst
;//                   <3=> Eight Beat Burst
;//                   <4=> Sixteen Beat Burst
;//     </h>
;//     <h>  Bus Matrix Master Configuration Registers 5 (MATRIX_MCFG5)
;//       <o5.0..2> ULBT: Undefined Length Burst Type 
;//                   <0=> Infinite Length Burst
;//                   <1=> Single Access
;//                   <2=> Four Beat Burst
;//                   <3=> Eight Beat Burst
;//                   <4=> Sixteen Beat Burst
;//     </h>
;//   </h>
MATRIX_MCFG0_Val EQU    0x00000000
MATRIX_MCFG1_Val EQU    0x00000002
MATRIX_MCFG2_Val EQU    0x00000002
MATRIX_MCFG3_Val EQU    0x00000002
MATRIX_MCFG4_Val EQU    0x00000002
MATRIX_MCFG5_Val EQU    0x00000002

;//   <h> Bus Matrix Slave Configuration Registers
;//     <h> Bus Master Slave Configuration Register 0 (MATRIX_SCFG0)
;//       <o0.0..7>   SLOT_CYCLE: Maximum number of Allowed Cycles for a Burst
;//                   <i> When the SLOT_CYCLE limit is reached for a burst, it may be
;//                   <i> broken by another master trying to access this slave
;//       <o0.16..17> DEFMASTR_TYPE: Default Master Type
;//                   <0=> No Default Master
;//                   <1=> Last Default Master
;//                   <2=> Fixed Default Master
;//       <o0.18..20> FIXED_DEFMSTR: Fixed Index of Default Master <0-7>
;//                   <i> This is the index of the Fixed Default Master for this slave
;//       <o0.24..25> ARBT: Arbitration Type
;//                   <0=> Round-Robin Arbitration
;//                   <1=> Fixed Priority Arbitration
;//     </h>
;//     <h> Bus Master Slave Configuration Register 1 (MATRIX_SCFG1)
;//       <o1.0..7>   SLOT_CYCLE: Maximum number of Allowed Cycles for a Burst
;//                   <i> When the SLOT_CYCLE limit is reached for a burst, it may be
;//                   <i> broken by another master trying to access this slave
;//       <o1.16..17> DEFMASTR_TYPE: Default Master Type
;//                   <0=> No Default Master
;//                   <1=> Last Default Master
;//                   <2=> Fixed Default Master
;//       <o1.18..20> FIXED_DEFMSTR: Fixed Index of Default Master <0-7>
;//                   <i> This is the index of the Fixed Default Master for this slave
;//       <o1.24..25> ARBT: Arbitration Type
;//                   <0=> Round-Robin Arbitration
;//                   <1=> Fixed Priority Arbitration
;//     </h>
;//     <h> Bus Master Slave Configuration Register 2 (MATRIX_SCFG2)
;//       <o2.0..7>   SLOT_CYCLE: Maximum number of Allowed Cycles for a Burst
;//                   <i> When the SLOT_CYCLE limit is reached for a burst, it may be
;//                   <i> broken by another master trying to access this slave
;//       <o2.16..17> DEFMASTR_TYPE: Default Master Type
;//                   <0=> No Default Master
;//                   <1=> Last Default Master
;//                   <2=> Fixed Default Master
;//       <o2.18..20> FIXED_DEFMSTR: Fixed Index of Default Master <0-7>
;//                   <i> This is the index of the Fixed Default Master for this slave
;//       <o2.24..25> ARBT: Arbitration Type
;//                   <0=> Round-Robin Arbitration
;//                   <1=> Fixed Priority Arbitration
;//     </h>
;//     <h> Bus Master Slave Configuration Register 3 (MATRIX_SCFG3)
;//       <o3.0..7>   SLOT_CYCLE: Maximum number of Allowed Cycles for a Burst
;//                   <i> When the SLOT_CYCLE limit is reached for a burst, it may be
;//                   <i> broken by another master trying to access this slave
;//       <o3.16..17> DEFMASTR_TYPE: Default Master Type
;//                   <0=> No Default Master
;//                   <1=> Last Default Master
;//                   <2=> Fixed Default Master
;//       <o3.18..20> FIXED_DEFMSTR: Fixed Index of Default Master <0-7>
;//                   <i> This is the index of the Fixed Default Master for this slave
;//       <o3.24..25> ARBT: Arbitration Type
;//                   <0=> Round-Robin Arbitration
;//                   <1=> Fixed Priority Arbitration
;//     </h>
;//     <h> Bus Master Slave Configuration Register 4 (MATRIX_SCFG4)
;//       <o4.0..7>   SLOT_CYCLE: Maximum number of Allowed Cycles for a Burst
;//                   <i> When the SLOT_CYCLE limit is reached for a burst, it may be
;//                   <i> broken by another master trying to access this slave
;//       <o4.16..17> DEFMASTR_TYPE: Default Master Type
;//                   <0=> No Default Master
;//                   <1=> Last Default Master
;//                   <2=> Fixed Default Master
;//       <o4.18..20> FIXED_DEFMSTR: Fixed Index of Default Master <0-7>
;//                   <i> This is the index of the Fixed Default Master for this slave
;//       <o4.24..25> ARBT: Arbitration Type
;//                   <0=> Round-Robin Arbitration
;//                   <1=> Fixed Priority Arbitration
;//     </h>
;//   </h>
MATRIX_SCFG0_Val EQU    0x00000010
MATRIX_SCFG1_Val EQU    0x00000010
MATRIX_SCFG2_Val EQU    0x00000010
MATRIX_SCFG3_Val EQU    0x00000010
MATRIX_SCFG4_Val EQU    0x00000010

;//   <h> Bus Matrix Priority Registers For Slaves
;//     <h> Bus Matrix Priority Register For Slaves 0 (MATRIX_PRAS0)
;//       <i> Fixed priority of Master x for access to the selected slave.
;//       <i> The higher the number, the higher the priority.
;//       <o0.0..1>   M0PR: Master 0 Priority
;//       <o0.4..5>   M1PR: Master 1 Priority
;//       <o0.8..9>   M2PR: Master 2 Priority
;//       <o0.12..13> M3PR: Master 3 Priority
;//       <o0.16..17> M4PR: Master 4 Priority
;//       <o0.20..21> M5PR: Master 5 Priority
;//     </h>
;//     <h> Bus Matrix Priority Register For Slaves 1 (MATRIX_PRAS1)
;//       <i> Fixed priority of Master x for access to the selected slave.
;//       <i> The higher the number, the higher the priority.
;//       <o1.0..1>   M0PR: Master 0 Priority
;//       <o1.4..5>   M1PR: Master 1 Priority
;//       <o1.8..9>   M2PR: Master 2 Priority
;//       <o1.12..13> M3PR: Master 3 Priority
;//       <o1.16..17> M4PR: Master 4 Priority
;//       <o1.20..21> M5PR: Master 5 Priority
;//     </h>
;//     <h> Bus Matrix Priority Register For Slaves 2 (MATRIX_PRAS2)
;//       <i> Fixed priority of Master x for access to the selected slave.
;//       <i> The higher the number, the higher the priority.
;//       <o2.0..1>   M0PR: Master 0 Priority
;//       <o2.4..5>   M1PR: Master 1 Priority
;//       <o2.8..9>   M2PR: Master 2 Priority
;//       <o2.12..13> M3PR: Master 3 Priority
;//       <o2.16..17> M4PR: Master 4 Priority
;//       <o2.20..21> M5PR: Master 5 Priority
;//     </h>
;//     <h> Bus Matrix Priority Register For Slaves 3 (MATRIX_PRAS3)
;//       <i> Fixed priority of Master x for access to the selected slave.
;//       <i> The higher the number, the higher the priority.
;//       <o3.0..1>   M0PR: Master 0 Priority
;//       <o3.4..5>   M1PR: Master 1 Priority
;//       <o3.8..9>   M2PR: Master 2 Priority
;//       <o3.12..13> M3PR: Master 3 Priority
;//       <o3.16..17> M4PR: Master 4 Priority
;//       <o3.20..21> M5PR: Master 5 Priority
;//     </h>
;//     <h> Bus Matrix Priority Register For Slaves 4 (MATRIX_PRAS4)
;//       <i> Fixed priority of Master x for access to the selected slave.
;//       <i> The higher the number, the higher the priority.
;//       <o4.0..1>   M0PR: Master 0 Priority
;//       <o4.4..5>   M1PR: Master 1 Priority
;//       <o4.8..9>   M2PR: Master 2 Priority
;//       <o4.12..13> M3PR: Master 3 Priority
;//       <o4.16..17> M4PR: Master 4 Priority
;//       <o4.20..21> M5PR: Master 5 Priority
;//     </h>
;//   </h>
MATRIX_PRAS0_Val EQU    0x00000000
MATRIX_PRAS1_Val EQU    0x00000000
MATRIX_PRAS2_Val EQU    0x00000000
MATRIX_PRAS3_Val EQU    0x00000000
MATRIX_PRAS4_Val EQU    0x00000000

;// </e> Bus Matrix (MATRIX)


;// <e> External Bus Interface (EBI)
EBI_SETUP       EQU     1

;//   <h> EBI Chip Select Assignment Register
;//     <o0.1>      EBI_CS1A: EBI Chip Select 1 Assignment
;//                   <0=> Assigned to Static Memory Controller
;//                   <1=> Assigned to SDRAM Controller
;//     <o0.3>      EBI_CS3A: EBI Chip Select 3 Assignment
;//                   <0=> Assigned to Static Memory Controller
;//                   <1=> Assigned to Static Memory Controller and the SmartMedia Logic
;//     <o0.4>      EBI_CS4A: EBI Chip Select 4 Assignment
;//                   <0=> Assigned to Static Memory Controller
;//                   <1=> Assigned to Static Memory Controller and the CompactFlash Logic (Slot 1)
;//     <o0.5>      EBI_CS5A: EBI Chip Select 5 Assignment
;//                   <0=> Assigned to Static Memory Controller
;//                   <1=> Assigned to Static Memory Controller and the CompactFlash Logic (Slot 2)
;//     <o0.8>      EBI_DBPUC: EBI Data Bus Pull-Up Configuration
;//                   <0=> EBI D0..D15 Data Bus bits are internally pulled-up
;//                   <1=> EBI D0..D15 Data Bus bits are not internally pulled-up
;//     <o0.16>     VDDIOMSEL: Memory Voltage Selection
;//                   <0=> Memories are 1.8V powered
;//                   <1=> Memories are 3.3V powered
;//   </h>
EBI_CSA_Val     EQU     0x0001003A

;// </e> External Bus Interface (EBI)


;----------------------- Static Memory Controller (SMC) Definitions ------------

; Static Memory Controller (SMC) User Interface
SMC_BASE        EQU     0xFFFFEC00      ; SMC                     Base Address

                ^       0               ; SMC Registers           Offsets
SMC_SETUP0_OFS  #       0x04            ; CS0 Setup Register      Address Offset
SMC_PULSE0_OFS  #       0x04            ; CS0 Pulse Register      Address Offset
SMC_CYCLE0_OFS  #       0x04            ; CS0 Cycle Register      Address Offset
SMC_MODE0_OFS   #       0x04            ; CS0 Mode  Register      Address Offset

SMC_SETUP1_OFS  #       0x04            ; CS1 Setup Register      Address Offset
SMC_PULSE1_OFS  #       0x04            ; CS1 Pulse Register      Address Offset
SMC_CYCLE1_OFS  #       0x04            ; CS1 Cycle Register      Address Offset
SMC_MODE1_OFS   #       0x04            ; CS1 Mode  Register      Address Offset

SMC_SETUP2_OFS  #       0x04            ; CS2 Setup Register      Address Offset
SMC_PULSE2_OFS  #       0x04            ; CS2 Pulse Register      Address Offset
SMC_CYCLE2_OFS  #       0x04            ; CS2 Cycle Register      Address Offset
SMC_MODE2_OFS   #       0x04            ; CS2 Mode  Register      Address Offset

SMC_SETUP3_OFS  #       0x04            ; CS3 Setup Register      Address Offset
SMC_PULSE3_OFS  #       0x04            ; CS3 Pulse Register      Address Offset
SMC_CYCLE3_OFS  #       0x04            ; CS3 Cycle Register      Address Offset
SMC_MODE3_OFS   #       0x04            ; CS3 Mode  Register      Address Offset

SMC_SETUP4_OFS  #       0x04            ; CS4 Setup Register      Address Offset
SMC_PULSE4_OFS  #       0x04            ; CS4 Pulse Register      Address Offset
SMC_CYCLE4_OFS  #       0x04            ; CS4 Cycle Register      Address Offset
SMC_MODE4_OFS   #       0x04            ; CS4 Mode  Register      Address Offset

SMC_SETUP5_OFS  #       0x04            ; CS5 Setup Register      Address Offset
SMC_PULSE5_OFS  #       0x04            ; CS5 Pulse Register      Address Offset
SMC_CYCLE5_OFS  #       0x04            ; CS5 Cycle Register      Address Offset
SMC_MODE5_OFS   #       0x04            ; CS5 Mode  Register      Address Offset

SMC_SETUP6_OFS  #       0x04            ; CS6 Setup Register      Address Offset
SMC_PULSE6_OFS  #       0x04            ; CS6 Pulse Register      Address Offset
SMC_CYCLE6_OFS  #       0x04            ; CS6 Cycle Register      Address Offset
SMC_MODE6_OFS   #       0x04            ; CS6 Mode  Register      Address Offset

SMC_SETUP7_OFS  #       0x04            ; CS7 Setup Register      Address Offset
SMC_PULSE7_OFS  #       0x04            ; CS7 Pulse Register      Address Offset
SMC_CYCLE7_OFS  #       0x04            ; CS7 Cycle Register      Address Offset
SMC_MODE7_OFS   #       0x04            ; CS7 Mode  Register      Address Offset

;// <e> Static Memory Controller (SMC)
SMC_SETUP       EQU     0

;//   <e> SMC Chip Select 0 Configuration
;//     <h> Chip Select 0 Setup Register (SMC_SETUP0)
;//       <o1.0..5>   NWE_SETUP: NWE Setup Length <0-63>
;//                     <i> NWE setup length = (128*NWE_SETUP[5]+NWE_SETUP[4..0]) clock cycles
;//       <o1.8..13>  NCS_WR_SETUP: NCS Setup Length in WRITE Access <0-63>
;//                     <i> NCS setup length = (128*NCS_WR_SETUP[5]+NCS_WR_SETUP[4..0]) clock cycles
;//       <o1.16..21> NRD_SETUP: NRD Setup Length <0-63>
;//                     <i> NRD setup length = (128*NRD_SETUP[5]+NRD_SETUP[4..0]) clock cycles
;//       <o1.24..29> NCS_RD_SETUP: NCS Setup Length in READ Access <0-63>
;//                     <i> NCS setup length = (128*NCS_RD_SETUP[5]+NCS_RD_SETUP[4..0]) clock cycles
;//     </h>
;//
;//     <h> Chip Select 0 Pulse Register (SMC_PULSE0)
;//       <o2.0..6>   NWE_PULSE: NWE Pulse Length <0-127>
;//                     <i> NWE pulse length = (256*NWE_PULSE[6]+NWE_PULSE[5..0]) clock cycles
;//       <o2.8..14>  NCS_WR_PULSE: NCS Pulse Length in WRITE Access <0-127>
;//                     <i> NCS pulse length = (256*NCS_WR_PULSE[6]+NCS_WR_PULSE[5..0]) clock cycles
;//       <o2.16..22> NRD_PULSE: NRD Pulse Length <0-127>
;//                     <i> NRD pulse length = (256*NRD_PULSE[6]+NRD_PULSE[5..0]) clock cycles
;//       <o2.24..30> NCS_RD_PULSE: NCS Pulse Length in READ Access <0-127>
;//                     <i> NCS pulse length = (256*NCS_RD_PULSE[6]+NCS_RD_PULSE[5..0]) clock cycles
;//     </h>
;//
;//     <h> Chip Select 0 Cycle Register (SMC_CYCLE0)
;//       <o3.0..8>   NWE_CYCLE: Total Write Cycle Length <0-511>
;//                     <i> Write cycle length = (NWE_CYCLE[8..7]*256+NWE_CYCLE[6..0]) clock cycle
;//       <o3.16..24> NRD_CYCLE: Total Read Cycle Length <0-511>
;//                     <i> Read cycle length = (NRD_CYCLE[8..7]*256+NRD_CYCLE[6..0]) clock cycle
;//     </h>
;//
;//     <h> Chip Select 0 Mode Register (SMC_MODE0)
;//       <o4.0>      READ_MODE:
;//                     <0=> The read operation is controlled by the NCS signal
;//                     <1=> The read operation is controlled by the NRD signal
;//       <o4.1>      WRITE_MODE:
;//                     <0=> The write operation is controlled by the NCS signal
;//                     <1=> The write operation is controlled by the NWE signal
;//       <o4.4..5>   EXNW_MODE: NWAIT Mode
;//                     <0=> Disabled
;//                     <2=> Frozen Mode
;//                     <3=> Ready Mode
;//       <o4.8>      BAT: Byte Access Type
;//                     <0=> 0
;//                     <1=> 1
;//                     <i>  0: - Write operation is controlled using: NCS, NWE, NBS0, NBS1, NBS2, NBS3
;//                     <i>     - Read  operation is controlled using: NCS, NRD, NBS0, NBS1, NBS2, NBS3
;//                     <i>  1: - Write operation is controlled using: NCS, NWR0, NWR1, NWR2, NWR3        
;//                     <i>     - Read  operation is controlled using: NCS, NRD
;//       <o4.12..13> DBW: Data Bus Width
;//                     <0=> 8-bit bus
;//                     <1=> 16-bit bus
;//                     <2=> 32-bit bus
;//       <o4.16..19> TDF_CYCLES: Data Float Time <0-15>
;//       <o4.20>     TDF_MODE: TDF Optimization Enabled
;//       <o4.24>     PMEN: Page Mode Enabled
;//       <o4.28..29> PS: Page Size
;//                     <0=> 4-byte page
;//                     <1=> 8-byte page
;//                     <2=> 16-byte page
;//                     <3=> 32-byte page
;//     </h>
;//   </e>
SMC_CS0_SETUP   EQU     0x00000000
SMC_SETUP0_Val  EQU     0x00000000
SMC_PULSE0_Val  EQU     0x01010101
SMC_CYCLE0_Val  EQU     0x00010001
SMC_MODE0_Val   EQU     0x10001000

;//   <e> SMC Chip Select 1 Configuration
;//     <h> Chip Select 1 Setup Register (SMC_SETUP1)
;//       <o1.0..5>   NWE_SETUP: NWE Setup Length <0-63>
;//                     <i> NWE setup length = (128*NWE_SETUP[5]+NWE_SETUP[4..0]) clock cycles
;//       <o1.8..13>  NCS_WR_SETUP: NCS Setup Length in WRITE Access <0-63>
;//                     <i> NCS setup length = (128*NCS_WR_SETUP[5]+NCS_WR_SETUP[4..0]) clock cycles
;//       <o1.16..21> NRD_SETUP: NRD Setup Length <0-63>
;//                     <i> NRD setup length = (128*NRD_SETUP[5]+NRD_SETUP[4..0]) clock cycles
;//       <o1.24..29> NCS_RD_SETUP: NCS Setup Length in READ Access <0-63>
;//                     <i> NCS setup length = (128*NCS_RD_SETUP[5]+NCS_RD_SETUP[4..0]) clock cycles
;//     </h>
;//
;//     <h> Chip Select 1 Pulse Register (SMC_PULSE1)
;//       <o2.0..6>   NWE_PULSE: NWE Pulse Length <0-127>
;//                     <i> NWE pulse length = (256*NWE_PULSE[6]+NWE_PULSE[5..0]) clock cycles
;//       <o2.8..14>  NCS_WR_PULSE: NCS Pulse Length in WRITE Access <0-127>
;//                     <i> NCS pulse length = (256*NCS_WR_PULSE[6]+NCS_WR_PULSE[5..0]) clock cycles
;//       <o2.16..22> NRD_PULSE: NRD Pulse Length <0-127>
;//                     <i> NRD pulse length = (256*NRD_PULSE[6]+NRD_PULSE[5..0]) clock cycles
;//       <o2.24..30> NCS_RD_PULSE: NCS Pulse Length in READ Access <0-127>
;//                     <i> NCS pulse length = (256*NCS_RD_PULSE[6]+NCS_RD_PULSE[5..0]) clock cycles
;//     </h>
;//
;//     <h> Chip Select 1 Cycle Register (SMC_CYCLE1)
;//       <o3.0..8>   NWE_CYCLE: Total Write Cycle Length <0-511>
;//                     <i> Write cycle length = (NWE_CYCLE[8..7]*256+NWE_CYCLE[6..0]) clock cycle
;//       <o3.16..24> NRD_CYCLE: Total Read Cycle Length <0-511>
;//                     <i> Read cycle length = (NRD_CYCLE[8..7]*256+NRD_CYCLE[6..0]) clock cycle
;//     </h>
;//
;//     <h> Chip Select 1 Mode Register (SMC_MODE1)
;//       <o4.0>      READ_MODE:
;//                     <0=> The read operation is controlled by the NCS signal
;//                     <1=> The read operation is controlled by the NRD signal
;//       <o4.1>      WRITE_MODE:
;//                     <0=> The write operation is controlled by the NCS signal
;//                     <1=> The write operation is controlled by the NWE signal
;//       <o4.4..5>   EXNW_MODE: NWAIT Mode
;//                     <0=> Disabled
;//                     <2=> Frozen Mode
;//                     <3=> Ready Mode
;//       <o4.8>      BAT: Byte Access Type
;//                     <0=> 0
;//                     <1=> 1
;//                     <i>  0: - Write operation is controlled using: NCS, NWE, NBS0, NBS1, NBS2, NBS3
;//                     <i>     - Read  operation is controlled using: NCS, NRD, NBS0, NBS1, NBS2, NBS3
;//                     <i>  1: - Write operation is controlled using: NCS, NWR0, NWR1, NWR2, NWR3        
;//                     <i>     - Read  operation is controlled using: NCS, NRD
;//       <o4.12..13> DBW: Data Bus Width
;//                     <0=> 8-bit bus
;//                     <1=> 16-bit bus
;//                     <2=> 32-bit bus
;//       <o4.16..19> TDF_CYCLES: Data Float Time <0-15>
;//       <o4.20>     TDF_MODE: TDF Optimization Enabled
;//       <o4.24>     PMEN: Page Mode Enabled
;//       <o4.28..29> PS: Page Size
;//                     <0=> 4-byte page
;//                     <1=> 8-byte page
;//                     <2=> 16-byte page
;//                     <3=> 32-byte page
;//     </h>
;//   </e>
SMC_CS1_SETUP   EQU     0x00000000
SMC_SETUP1_Val  EQU     0x00000000
SMC_PULSE1_Val  EQU     0x01010101
SMC_CYCLE1_Val  EQU     0x00010001
SMC_MODE1_Val   EQU     0x10001000

;//   <e> SMC Chip Select 2 Configuration
;//     <h> Chip Select 2 Setup Register (SMC_SETUP2)
;//       <o1.0..5>   NWE_SETUP: NWE Setup Length <0-63>
;//                     <i> NWE setup length = (128*NWE_SETUP[5]+NWE_SETUP[4..0]) clock cycles
;//       <o1.8..13>  NCS_WR_SETUP: NCS Setup Length in WRITE Access <0-63>
;//                     <i> NCS setup length = (128*NCS_WR_SETUP[5]+NCS_WR_SETUP[4..0]) clock cycles
;//       <o1.16..21> NRD_SETUP: NRD Setup Length <0-63>
;//                     <i> NRD setup length = (128*NRD_SETUP[5]+NRD_SETUP[4..0]) clock cycles
;//       <o1.24..29> NCS_RD_SETUP: NCS Setup Length in READ Access <0-63>
;//                     <i> NCS setup length = (128*NCS_RD_SETUP[5]+NCS_RD_SETUP[4..0]) clock cycles
;//     </h>
;//
;//     <h> Chip Select 2 Pulse Register (SMC_PULSE2)
;//       <o2.0..6>   NWE_PULSE: NWE Pulse Length <0-127>
;//                     <i> NWE pulse length = (256*NWE_PULSE[6]+NWE_PULSE[5..0]) clock cycles
;//       <o2.8..14>  NCS_WR_PULSE: NCS Pulse Length in WRITE Access <0-127>
;//                     <i> NCS pulse length = (256*NCS_WR_PULSE[6]+NCS_WR_PULSE[5..0]) clock cycles
;//       <o2.16..22> NRD_PULSE: NRD Pulse Length <0-127>
;//                     <i> NRD pulse length = (256*NRD_PULSE[6]+NRD_PULSE[5..0]) clock cycles
;//       <o2.24..30> NCS_RD_PULSE: NCS Pulse Length in READ Access <0-127>
;//                     <i> NCS pulse length = (256*NCS_RD_PULSE[6]+NCS_RD_PULSE[5..0]) clock cycles
;//     </h>
;//
;//     <h> Chip Select 2 Cycle Register (SMC_CYCLE2)
;//       <o3.0..8>   NWE_CYCLE: Total Write Cycle Length <0-511>
;//                     <i> Write cycle length = (NWE_CYCLE[8..7]*256+NWE_CYCLE[6..0]) clock cycle
;//       <o3.16..24> NRD_CYCLE: Total Read Cycle Length <0-511>
;//                     <i> Read cycle length = (NRD_CYCLE[8..7]*256+NRD_CYCLE[6..0]) clock cycle
;//     </h>
;//
;//     <h> Chip Select 2 Mode Register (SMC_MODE2)
;//       <o4.0>      READ_MODE:
;//                     <0=> The read operation is controlled by the NCS signal
;//                     <1=> The read operation is controlled by the NRD signal
;//       <o4.1>      WRITE_MODE:
;//                     <0=> The write operation is controlled by the NCS signal
;//                     <1=> The write operation is controlled by the NWE signal
;//       <o4.4..5>   EXNW_MODE: NWAIT Mode
;//                     <0=> Disabled
;//                     <2=> Frozen Mode
;//                     <3=> Ready Mode
;//       <o4.8>      BAT: Byte Access Type
;//                     <0=> 0
;//                     <1=> 1
;//                     <i>  0: - Write operation is controlled using: NCS, NWE, NBS0, NBS1, NBS2, NBS3
;//                     <i>     - Read  operation is controlled using: NCS, NRD, NBS0, NBS1, NBS2, NBS3
;//                     <i>  1: - Write operation is controlled using: NCS, NWR0, NWR1, NWR2, NWR3        
;//                     <i>     - Read  operation is controlled using: NCS, NRD
;//       <o4.12..13> DBW: Data Bus Width
;//                     <0=> 8-bit bus
;//                     <1=> 16-bit bus
;//                     <2=> 32-bit bus
;//       <o4.16..19> TDF_CYCLES: Data Float Time <0-15>
;//       <o4.20>     TDF_MODE: TDF Optimization Enabled
;//       <o4.24>     PMEN: Page Mode Enabled
;//       <o4.28..29> PS: Page Size
;//                     <0=> 4-byte page
;//                     <1=> 8-byte page
;//                     <2=> 16-byte page
;//                     <3=> 32-byte page
;//     </h>
;//   </e>
SMC_CS2_SETUP   EQU     0x00000000
SMC_SETUP2_Val  EQU     0x00000000
SMC_PULSE2_Val  EQU     0x01010101
SMC_CYCLE2_Val  EQU     0x00010001
SMC_MODE2_Val   EQU     0x10001000

;//   <e> SMC Chip Select 3 Configuration
;//     <h> Chip Select 3 Setup Register (SMC_SETUP3)
;//       <o1.0..5>   NWE_SETUP: NWE Setup Length <0-63>
;//                     <i> NWE setup length = (128*NWE_SETUP[5]+NWE_SETUP[4..0]) clock cycles
;//       <o1.8..13>  NCS_WR_SETUP: NCS Setup Length in WRITE Access <0-63>
;//                     <i> NCS setup length = (128*NCS_WR_SETUP[5]+NCS_WR_SETUP[4..0]) clock cycles
;//       <o1.16..21> NRD_SETUP: NRD Setup Length <0-63>
;//                     <i> NRD setup length = (128*NRD_SETUP[5]+NRD_SETUP[4..0]) clock cycles
;//       <o1.24..29> NCS_RD_SETUP: NCS Setup Length in READ Access <0-63>
;//                     <i> NCS setup length = (128*NCS_RD_SETUP[5]+NCS_RD_SETUP[4..0]) clock cycles
;//     </h>
;//
;//     <h> Chip Select 3 Pulse Register (SMC_PULSE3)
;//       <o2.0..6>   NWE_PULSE: NWE Pulse Length <0-127>
;//                     <i> NWE pulse length = (256*NWE_PULSE[6]+NWE_PULSE[5..0]) clock cycles
;//       <o2.8..14>  NCS_WR_PULSE: NCS Pulse Length in WRITE Access <0-127>
;//                     <i> NCS pulse length = (256*NCS_WR_PULSE[6]+NCS_WR_PULSE[5..0]) clock cycles
;//       <o2.16..22> NRD_PULSE: NRD Pulse Length <0-127>
;//                     <i> NRD pulse length = (256*NRD_PULSE[6]+NRD_PULSE[5..0]) clock cycles
;//       <o2.24..30> NCS_RD_PULSE: NCS Pulse Length in READ Access <0-127>
;//                     <i> NCS pulse length = (256*NCS_RD_PULSE[6]+NCS_RD_PULSE[5..0]) clock cycles
;//     </h>
;//
;//     <h> Chip Select 3 Cycle Register (SMC_CYCLE3)
;//       <o3.0..8>   NWE_CYCLE: Total Write Cycle Length <0-511>
;//                     <i> Write cycle length = (NWE_CYCLE[8..7]*256+NWE_CYCLE[6..0]) clock cycle
;//       <o3.16..24> NRD_CYCLE: Total Read Cycle Length <0-511>
;//                     <i> Read cycle length = (NRD_CYCLE[8..7]*256+NRD_CYCLE[6..0]) clock cycle
;//     </h>
;//
;//     <h> Chip Select 3 Mode Register (SMC_MODE3)
;//       <o4.0>      READ_MODE:
;//                     <0=> The read operation is controlled by the NCS signal
;//                     <1=> The read operation is controlled by the NRD signal
;//       <o4.1>      WRITE_MODE:
;//                     <0=> The write operation is controlled by the NCS signal
;//                     <1=> The write operation is controlled by the NWE signal
;//       <o4.4..5>   EXNW_MODE: NWAIT Mode
;//                     <0=> Disabled
;//                     <2=> Frozen Mode
;//                     <3=> Ready Mode
;//       <o4.8>      BAT: Byte Access Type
;//                     <0=> 0
;//                     <1=> 1
;//                     <i>  0: - Write operation is controlled using: NCS, NWE, NBS0, NBS1, NBS2, NBS3
;//                     <i>     - Read  operation is controlled using: NCS, NRD, NBS0, NBS1, NBS2, NBS3
;//                     <i>  1: - Write operation is controlled using: NCS, NWR0, NWR1, NWR2, NWR3        
;//                     <i>     - Read  operation is controlled using: NCS, NRD
;//       <o4.12..13> DBW: Data Bus Width
;//                     <0=> 8-bit bus
;//                     <1=> 16-bit bus
;//                     <2=> 32-bit bus
;//       <o4.16..19> TDF_CYCLES: Data Float Time <0-15>
;//       <o4.20>     TDF_MODE: TDF Optimization Enabled
;//       <o4.24>     PMEN: Page Mode Enabled
;//       <o4.28..29> PS: Page Size
;//                     <0=> 4-byte page
;//                     <1=> 8-byte page
;//                     <2=> 16-byte page
;//                     <3=> 32-byte page
;//     </h>
;//   </e>
SMC_CS3_SETUP   EQU     0x00000000
SMC_SETUP3_Val  EQU     0x00000000
SMC_PULSE3_Val  EQU     0x01010101
SMC_CYCLE3_Val  EQU     0x00010001
SMC_MODE3_Val   EQU     0x10001000

;//   <e> SMC Chip Select 4 Configuration
;//     <h> Chip Select 4 Setup Register (SMC_SETUP4)
;//       <o1.0..5>   NWE_SETUP: NWE Setup Length <0-63>
;//                     <i> NWE setup length = (128*NWE_SETUP[5]+NWE_SETUP[4..0]) clock cycles
;//       <o1.8..13>  NCS_WR_SETUP: NCS Setup Length in WRITE Access <0-63>
;//                     <i> NCS setup length = (128*NCS_WR_SETUP[5]+NCS_WR_SETUP[4..0]) clock cycles
;//       <o1.16..21> NRD_SETUP: NRD Setup Length <0-63>
;//                     <i> NRD setup length = (128*NRD_SETUP[5]+NRD_SETUP[4..0]) clock cycles
;//       <o1.24..29> NCS_RD_SETUP: NCS Setup Length in READ Access <0-63>
;//                     <i> NCS setup length = (128*NCS_RD_SETUP[5]+NCS_RD_SETUP[4..0]) clock cycles
;//     </h>
;//
;//     <h> Chip Select 4 Pulse Register (SMC_PULSE4)
;//       <o2.0..6>   NWE_PULSE: NWE Pulse Length <0-127>
;//                     <i> NWE pulse length = (256*NWE_PULSE[6]+NWE_PULSE[5..0]) clock cycles
;//       <o2.8..14>  NCS_WR_PULSE: NCS Pulse Length in WRITE Access <0-127>
;//                     <i> NCS pulse length = (256*NCS_WR_PULSE[6]+NCS_WR_PULSE[5..0]) clock cycles
;//       <o2.16..22> NRD_PULSE: NRD Pulse Length <0-127>
;//                     <i> NRD pulse length = (256*NRD_PULSE[6]+NRD_PULSE[5..0]) clock cycles
;//       <o2.24..30> NCS_RD_PULSE: NCS Pulse Length in READ Access <0-127>
;//                     <i> NCS pulse length = (256*NCS_RD_PULSE[6]+NCS_RD_PULSE[5..0]) clock cycles
;//     </h>
;//
;//     <h> Chip Select 4 Cycle Register (SMC_CYCLE4)
;//       <o3.0..8>   NWE_CYCLE: Total Write Cycle Length <0-511>
;//                     <i> Write cycle length = (NWE_CYCLE[8..7]*256+NWE_CYCLE[6..0]) clock cycle
;//       <o3.16..24> NRD_CYCLE: Total Read Cycle Length <0-511>
;//                     <i> Read cycle length = (NRD_CYCLE[8..7]*256+NRD_CYCLE[6..0]) clock cycle
;//     </h>
;//
;//     <h> Chip Select 4 Mode Register (SMC_MODE4)
;//       <o4.0>      READ_MODE:
;//                     <0=> The read operation is controlled by the NCS signal
;//                     <1=> The read operation is controlled by the NRD signal
;//       <o4.1>      WRITE_MODE:
;//                     <0=> The write operation is controlled by the NCS signal
;//                     <1=> The write operation is controlled by the NWE signal
;//       <o4.4..5>   EXNW_MODE: NWAIT Mode
;//                     <0=> Disabled
;//                     <2=> Frozen Mode
;//                     <3=> Ready Mode
;//       <o4.8>      BAT: Byte Access Type
;//                     <0=> 0
;//                     <1=> 1
;//                     <i>  0: - Write operation is controlled using: NCS, NWE, NBS0, NBS1, NBS2, NBS3
;//                     <i>     - Read  operation is controlled using: NCS, NRD, NBS0, NBS1, NBS2, NBS3
;//                     <i>  1: - Write operation is controlled using: NCS, NWR0, NWR1, NWR2, NWR3        
;//                     <i>     - Read  operation is controlled using: NCS, NRD
;//       <o4.12..13> DBW: Data Bus Width
;//                     <0=> 8-bit bus
;//                     <1=> 16-bit bus
;//                     <2=> 32-bit bus
;//       <o4.16..19> TDF_CYCLES: Data Float Time <0-15>
;//       <o4.20>     TDF_MODE: TDF Optimization Enabled
;//       <o4.24>     PMEN: Page Mode Enabled
;//       <o4.28..29> PS: Page Size
;//                     <0=> 4-byte page
;//                     <1=> 8-byte page
;//                     <2=> 16-byte page
;//                     <3=> 32-byte page
;//     </h>
;//   </e>
SMC_CS4_SETUP   EQU     0x00000000
SMC_SETUP4_Val  EQU     0x00000000
SMC_PULSE4_Val  EQU     0x01010101
SMC_CYCLE4_Val  EQU     0x00010001
SMC_MODE4_Val   EQU     0x10001000

;//   <e> SMC Chip Select 5 Configuration
;//     <h> Chip Select 5 Setup Register (SMC_SETUP5)
;//       <o1.0..5>   NWE_SETUP: NWE Setup Length <0-63>
;//                     <i> NWE setup length = (128*NWE_SETUP[5]+NWE_SETUP[4..0]) clock cycles
;//       <o1.8..13>  NCS_WR_SETUP: NCS Setup Length in WRITE Access <0-63>
;//                     <i> NCS setup length = (128*NCS_WR_SETUP[5]+NCS_WR_SETUP[4..0]) clock cycles
;//       <o1.16..21> NRD_SETUP: NRD Setup Length <0-63>
;//                     <i> NRD setup length = (128*NRD_SETUP[5]+NRD_SETUP[4..0]) clock cycles
;//       <o1.24..29> NCS_RD_SETUP: NCS Setup Length in READ Access <0-63>
;//                     <i> NCS setup length = (128*NCS_RD_SETUP[5]+NCS_RD_SETUP[4..0]) clock cycles
;//     </h>
;//
;//     <h> Chip Select 5 Pulse Register (SMC_PULSE5)
;//       <o2.0..6>   NWE_PULSE: NWE Pulse Length <0-127>
;//                     <i> NWE pulse length = (256*NWE_PULSE[6]+NWE_PULSE[5..0]) clock cycles
;//       <o2.8..14>  NCS_WR_PULSE: NCS Pulse Length in WRITE Access <0-127>
;//                     <i> NCS pulse length = (256*NCS_WR_PULSE[6]+NCS_WR_PULSE[5..0]) clock cycles
;//       <o2.16..22> NRD_PULSE: NRD Pulse Length <0-127>
;//                     <i> NRD pulse length = (256*NRD_PULSE[6]+NRD_PULSE[5..0]) clock cycles
;//       <o2.24..30> NCS_RD_PULSE: NCS Pulse Length in READ Access <0-127>
;//                     <i> NCS pulse length = (256*NCS_RD_PULSE[6]+NCS_RD_PULSE[5..0]) clock cycles
;//     </h>
;//
;//     <h> Chip Select 5 Cycle Register (SMC_CYCLE5)
;//       <o3.0..8>   NWE_CYCLE: Total Write Cycle Length <0-511>
;//                     <i> Write cycle length = (NWE_CYCLE[8..7]*256+NWE_CYCLE[6..0]) clock cycle
;//       <o3.16..24> NRD_CYCLE: Total Read Cycle Length <0-511>
;//                     <i> Read cycle length = (NRD_CYCLE[8..7]*256+NRD_CYCLE[6..0]) clock cycle
;//     </h>
;//
;//     <h> Chip Select 5 Mode Register (SMC_MODE5)
;//       <o4.0>      READ_MODE:
;//                     <0=> The read operation is controlled by the NCS signal
;//                     <1=> The read operation is controlled by the NRD signal
;//       <o4.1>      WRITE_MODE:
;//                     <0=> The write operation is controlled by the NCS signal
;//                     <1=> The write operation is controlled by the NWE signal
;//       <o4.4..5>   EXNW_MODE: NWAIT Mode
;//                     <0=> Disabled
;//                     <2=> Frozen Mode
;//                     <3=> Ready Mode
;//       <o4.8>      BAT: Byte Access Type
;//                     <0=> 0
;//                     <1=> 1
;//                     <i>  0: - Write operation is controlled using: NCS, NWE, NBS0, NBS1, NBS2, NBS3
;//                     <i>     - Read  operation is controlled using: NCS, NRD, NBS0, NBS1, NBS2, NBS3
;//                     <i>  1: - Write operation is controlled using: NCS, NWR0, NWR1, NWR2, NWR3        
;//                     <i>     - Read  operation is controlled using: NCS, NRD
;//       <o4.12..13> DBW: Data Bus Width
;//                     <0=> 8-bit bus
;//                     <1=> 16-bit bus
;//                     <2=> 32-bit bus
;//       <o4.16..19> TDF_CYCLES: Data Float Time <0-15>
;//       <o4.20>     TDF_MODE: TDF Optimization Enabled
;//       <o4.24>     PMEN: Page Mode Enabled
;//       <o4.28..29> PS: Page Size
;//                     <0=> 4-byte page
;//                     <1=> 8-byte page
;//                     <2=> 16-byte page
;//                     <3=> 32-byte page
;//     </h>
;//   </e>
SMC_CS5_SETUP   EQU     0x00000000
SMC_SETUP5_Val  EQU     0x00000000
SMC_PULSE5_Val  EQU     0x01010101
SMC_CYCLE5_Val  EQU     0x00010001
SMC_MODE5_Val   EQU     0x10001000

;//   <e> SMC Chip Select 6 Configuration
;//     <h> Chip Select 6 Setup Register (SMC_SETUP6)
;//       <o1.0..5>   NWE_SETUP: NWE Setup Length <0-63>
;//                     <i> NWE setup length = (128*NWE_SETUP[5]+NWE_SETUP[4..0]) clock cycles
;//       <o1.8..13>  NCS_WR_SETUP: NCS Setup Length in WRITE Access <0-63>
;//                     <i> NCS setup length = (128*NCS_WR_SETUP[5]+NCS_WR_SETUP[4..0]) clock cycles
;//       <o1.16..21> NRD_SETUP: NRD Setup Length <0-63>
;//                     <i> NRD setup length = (128*NRD_SETUP[5]+NRD_SETUP[4..0]) clock cycles
;//       <o1.24..29> NCS_RD_SETUP: NCS Setup Length in READ Access <0-63>
;//                     <i> NCS setup length = (128*NCS_RD_SETUP[5]+NCS_RD_SETUP[4..0]) clock cycles
;//     </h>
;//
;//     <h> Chip Select 6 Pulse Register (SMC_PULSE6)
;//       <o2.0..6>   NWE_PULSE: NWE Pulse Length <0-127>
;//                     <i> NWE pulse length = (256*NWE_PULSE[6]+NWE_PULSE[5..0]) clock cycles
;//       <o2.8..14>  NCS_WR_PULSE: NCS Pulse Length in WRITE Access <0-127>
;//                     <i> NCS pulse length = (256*NCS_WR_PULSE[6]+NCS_WR_PULSE[5..0]) clock cycles
;//       <o2.16..22> NRD_PULSE: NRD Pulse Length <0-127>
;//                     <i> NRD pulse length = (256*NRD_PULSE[6]+NRD_PULSE[5..0]) clock cycles
;//       <o2.24..30> NCS_RD_PULSE: NCS Pulse Length in READ Access <0-127>
;//                     <i> NCS pulse length = (256*NCS_RD_PULSE[6]+NCS_RD_PULSE[5..0]) clock cycles
;//     </h>
;//
;//     <h> Chip Select 6 Cycle Register (SMC_CYCLE6)
;//       <o3.0..8>   NWE_CYCLE: Total Write Cycle Length <0-511>
;//                     <i> Write cycle length = (NWE_CYCLE[8..7]*256+NWE_CYCLE[6..0]) clock cycle
;//       <o3.16..24> NRD_CYCLE: Total Read Cycle Length <0-511>
;//                     <i> Read cycle length = (NRD_CYCLE[8..7]*256+NRD_CYCLE[6..0]) clock cycle
;//     </h>
;//
;//     <h> Chip Select 6 Mode Register (SMC_MODE6)
;//       <o4.0>      READ_MODE:
;//                     <0=> The read operation is controlled by the NCS signal
;//                     <1=> The read operation is controlled by the NRD signal
;//       <o4.1>      WRITE_MODE:
;//                     <0=> The write operation is controlled by the NCS signal
;//                     <1=> The write operation is controlled by the NWE signal
;//       <o4.4..5>   EXNW_MODE: NWAIT Mode
;//                     <0=> Disabled
;//                     <2=> Frozen Mode
;//                     <3=> Ready Mode
;//       <o4.8>      BAT: Byte Access Type
;//                     <0=> 0
;//                     <1=> 1
;//                     <i>  0: - Write operation is controlled using: NCS, NWE, NBS0, NBS1, NBS2, NBS3
;//                     <i>     - Read  operation is controlled using: NCS, NRD, NBS0, NBS1, NBS2, NBS3
;//                     <i>  1: - Write operation is controlled using: NCS, NWR0, NWR1, NWR2, NWR3        
;//                     <i>     - Read  operation is controlled using: NCS, NRD
;//       <o4.12..13> DBW: Data Bus Width
;//                     <0=> 8-bit bus
;//                     <1=> 16-bit bus
;//                     <2=> 32-bit bus
;//       <o4.16..19> TDF_CYCLES: Data Float Time <0-15>
;//       <o4.20>     TDF_MODE: TDF Optimization Enabled
;//       <o4.24>     PMEN: Page Mode Enabled
;//       <o4.28..29> PS: Page Size
;//                     <0=> 4-byte page
;//                     <1=> 8-byte page
;//                     <2=> 16-byte page
;//                     <3=> 32-byte page
;//     </h>
;//   </e>
SMC_CS6_SETUP   EQU     0x00000000
SMC_SETUP6_Val  EQU     0x00000000
SMC_PULSE6_Val  EQU     0x01010101
SMC_CYCLE6_Val  EQU     0x00010001
SMC_MODE6_Val   EQU     0x10001000

;//   <e> SMC Chip Select 7 Configuration
;//     <h> Chip Select 7 Setup Register (SMC_SETUP7)
;//       <o1.0..5>   NWE_SETUP: NWE Setup Length <0-63>
;//                     <i> NWE setup length = (128*NWE_SETUP[5]+NWE_SETUP[4..0]) clock cycles
;//       <o1.8..13>  NCS_WR_SETUP: NCS Setup Length in WRITE Access <0-63>
;//                     <i> NCS setup length = (128*NCS_WR_SETUP[5]+NCS_WR_SETUP[4..0]) clock cycles
;//       <o1.16..21> NRD_SETUP: NRD Setup Length <0-63>
;//                     <i> NRD setup length = (128*NRD_SETUP[5]+NRD_SETUP[4..0]) clock cycles
;//       <o1.24..29> NCS_RD_SETUP: NCS Setup Length in READ Access <0-63>
;//                     <i> NCS setup length = (128*NCS_RD_SETUP[5]+NCS_RD_SETUP[4..0]) clock cycles
;//     </h>
;//
;//     <h> Chip Select 7 Pulse Register (SMC_PULSE7)
;//       <o2.0..6>   NWE_PULSE: NWE Pulse Length <0-127>
;//                     <i> NWE pulse length = (256*NWE_PULSE[6]+NWE_PULSE[5..0]) clock cycles
;//       <o2.8..14>  NCS_WR_PULSE: NCS Pulse Length in WRITE Access <0-127>
;//                     <i> NCS pulse length = (256*NCS_WR_PULSE[6]+NCS_WR_PULSE[5..0]) clock cycles
;//       <o2.16..22> NRD_PULSE: NRD Pulse Length <0-127>
;//                     <i> NRD pulse length = (256*NRD_PULSE[6]+NRD_PULSE[5..0]) clock cycles
;//       <o2.24..30> NCS_RD_PULSE: NCS Pulse Length in READ Access <0-127>
;//                     <i> NCS pulse length = (256*NCS_RD_PULSE[6]+NCS_RD_PULSE[5..0]) clock cycles
;//     </h>
;//
;//     <h> Chip Select 7 Cycle Register (SMC_CYCLE7)
;//       <o3.0..8>   NWE_CYCLE: Total Write Cycle Length <0-511>
;//                     <i> Write cycle length = (NWE_CYCLE[8..7]*256+NWE_CYCLE[6..0]) clock cycle
;//       <o3.16..24> NRD_CYCLE: Total Read Cycle Length <0-511>
;//                     <i> Read cycle length = (NRD_CYCLE[8..7]*256+NRD_CYCLE[6..0]) clock cycle
;//     </h>
;//
;//     <h> Chip Select 7 Mode Register (SMC_MODE7)
;//       <o4.0>      READ_MODE:
;//                     <0=> The read operation is controlled by the NCS signal
;//                     <1=> The read operation is controlled by the NRD signal
;//       <o4.1>      WRITE_MODE:
;//                     <0=> The write operation is controlled by the NCS signal
;//                     <1=> The write operation is controlled by the NWE signal
;//       <o4.4..5>   EXNW_MODE: NWAIT Mode
;//                     <0=> Disabled
;//                     <2=> Frozen Mode
;//                     <3=> Ready Mode
;//       <o4.8>      BAT: Byte Access Type
;//                     <0=> 0
;//                     <1=> 1
;//                     <i>  0: - Write operation is controlled using: NCS, NWE, NBS0, NBS1, NBS2, NBS3
;//                     <i>     - Read  operation is controlled using: NCS, NRD, NBS0, NBS1, NBS2, NBS3
;//                     <i>  1: - Write operation is controlled using: NCS, NWR0, NWR1, NWR2, NWR3        
;//                     <i>     - Read  operation is controlled using: NCS, NRD
;//       <o4.12..13> DBW: Data Bus Width
;//                     <0=> 8-bit bus
;//                     <1=> 16-bit bus
;//                     <2=> 32-bit bus
;//       <o4.16..19> TDF_CYCLES: Data Float Time <0-15>
;//       <o4.20>     TDF_MODE: TDF Optimization Enabled
;//       <o4.24>     PMEN: Page Mode Enabled
;//       <o4.28..29> PS: Page Size
;//                     <0=> 4-byte page
;//                     <1=> 8-byte page
;//                     <2=> 16-byte page
;//                     <3=> 32-byte page
;//     </h>
;//   </e>
SMC_CS7_SETUP   EQU     0x00000000
SMC_SETUP7_Val  EQU     0x00000000
SMC_PULSE7_Val  EQU     0x01010101
SMC_CYCLE7_Val  EQU     0x00010001
SMC_MODE7_Val   EQU     0x10001000

;// </e> Static Memory Controller (SMC)


;----------------------- SDRAM Controller (SDRAMC) Definitions -----------------

; SDRAM Controller (SDRAMC) User Interface
SDRAMC_BASE     EQU     0xFFFFEA00      ; SDRAMC                 Base Address
SDRAMC_MR_OFS   EQU     0x00            ; Mode Register          Address Offsett
SDRAMC_TR_OFS   EQU     0x04            ; Refresh Timer Register Address Offsett
SDRAMC_CR_OFS   EQU     0x08            ; Configuration Register Address Offsett
SDRAMC_LPR_OFS  EQU     0x10            ; Low Power Register     Address Offsett
SDRAMC_MDR_OFS  EQU     0x24            ; Memory Device Register Address Offsett

; Constants
CMD_NORMAL      EQU     0x00            ; SDRAM Normal Mode
CMD_NOP         EQU     0x01            ; SDRAM NOP Command
CMD_PRCGALL     EQU     0x02            ; SDRAM All Banks Precharge Command
CMD_LMR         EQU     0x03            ; SDRAM Load Mode Register Command
CMD_RFSH        EQU     0x04            ; SDRAM Refresh Command

;// <e> SDRAM Controller (SDRAMC)
SDRAMC_SETUP    EQU     1

;//   <h> Refresh Timer Register (SDRAMC_TR)
;//     <o0.0..11>  COUNT: SDRAMC Refresh Timer Count <0-4095>
;//                 <i> This 12-bit field is loaded into a timer that generates
;//                 <i> the refresh pulse
;//   </h>
SDRAMC_TR_Val   EQU     0x000005DD

;//   <h> Configuration Register (SDRAMC_CR)
;//     <o0.0..1>   NC: Number of Column Bits
;//                 <0=> 8  <1=> 9  <2=> 10 <3=> 11
;//     <o0.2..3>   NR: Number of Row Bits
;//                 <0=> 11 <1=> 12 <2=> 13
;//     <o0.4>      NB: Number of Banks
;//                 <0=> 2  <1=> 4
;//     <o0.5..6>   CAS: CAS Latency
;//                 <1=> 1  <2=> 2  <3=> 3
;//     <o0.7>      DBW: Data Bus Width
;//                 <0=> 32 bits              <1=> 16 bits
;//     <o0.8..11>  TWR: Write Recovery Delay <0-15>
;//                 <i> Defines Write Recovery Time, in cycles
;//     <o0.12..15> TRC: Row Cycle Delay      <0-15>
;//                 <i> Defines delay between Refresh and an Activate 
;//                 <i> Command, in cycles
;//     <o0.16..19> TRP: Row Precharge Delay  <0-15>
;//                 <i> Defines delay between Precharge Command
;//                 <i> and another Command, in cycles
;//     <o0.20..23> TRCD: Row to Column Delay <0-15>
;//                 <i> Defines delay between Activate Command
;//                 <i> and a Read/Write Command, in cycles
;//     <o0.24..27> TRAS: Active to Precharge Delay <0-15>
;//                 <i> Defines delay between Activate Command
;//                 <i> and a Precharge Command, in cycles
;//     <o0.28..31> TXSR: Exit Self Refresh to Active Delay <0-15>
;//                 <i> Defines delay between SCKE set high
;//                 <i> and an Activate Command, in cycles
;//   </h>
SDRAMC_CR_Val   EQU     0x85227259

;//   <h> Low Power Register (SDRAMC_LPR)
;//     <o0.0..1>   LPCB: Low-power Configuration Bits
;//                 <0=> Low-power feature inhibited
;//                 <1=> Self-refresh command issued after access
;//                 <2=> Power-down command issued after access
;//                 <3=> Deep Power-down command issued (for low-power SDRAM)
;//     <o0.4..6>   PASR: Partial Array Self-refresh (only for low-power SDRAM)
;//     <o0.8..9>   TCSR: Temperature Compensated Self-refresh (only for low-power SDRAM) 
;//     <o0.10..11> DS: Drive Strength (only for low-power SDRAM) 
;//     <o0.12..13> TIMEOUT: Time to define when low-power mode is enabled
;//                 <0=> Low-power mode activated immediately after last transfer
;//                 <1=> Low-power mode activated 64 clock cycles after last transfer
;//                 <2=> Low-power mode activated 128 clock cycles after last transfer
;//   </h>
SDRAMC_LPR_Val  EQU     0x00000000

;//   <h> Memory Device Register (SDRAMC_MDR)
;//     <o0.0..1>     MD: Memory Device Type
;//                 <0=> SDRAM  <1=> Low-power SDRAM
;//   </h>
SDRAMC_MDR_Val  EQU     0x00000000

;// </e> SDRAM Controller (SDRAMC)


;----------------------- Watchdog (WDT) Definitions ----------------------------

; Watchdog
WDT_BASE        EQU     0xFFFFFD40      ; WDT                     Base Address
WDT_MR_OFS      EQU     0x04            ; Watchdog Timer Mode Reg Address Offset

;// <e0.15> Watchdog Disable
;// </e>
WDT_Val         EQU     0x00008000


;----------------------- Cache Definitions -------------------------------------

; Cache

; Constants
ICACHE_ENABLE   EQU     (1<<12)         ; Instruction Cache Enable Bit

;// <e> Instruction Cache Enable
;// </e>
ICACHE_SETUP    EQU     1


;----------------------- CODE --------------------------------------------------

                PRESERVE8
                

; Area Definition and Entry Point
;  Startup Code must be linked first at Address at which it expects to run.

                AREA    RESET, CODE, READONLY
                ARM

                IF      :LNOT::DEF:__EVAL 
                IF      :DEF:SIZE_INT_INFO
                IMPORT  ||Image$$ER_IROM1$$RO$$Length||
                IMPORT  ||Image$$RW_IRAM1$$RW$$Length||
                ELIF    :DEF:SIZE_EXT_INFO
                IMPORT  ||Image$$ER_ROM1$$RO$$Length||
                IMPORT  ||Image$$RW_RAM1$$RW$$Length||
                ENDIF
                ENDIF

                IF      :DEF:__RTX
                IMPORT  SWI_Handler
                ENDIF

; Exception Vectors
;  Mapped to Address 0.
;  Absolute addressing mode must be used.
;  Dummy Handlers are implemented as infinite loops which can be modified.

Vectors         LDR     PC,Reset_Addr         
                LDR     PC,Undef_Addr
                LDR     PC,SWI_Addr
                LDR     PC,PAbt_Addr
                LDR     PC,DAbt_Addr
                ; Reserved vector is used for image size information
                IF      :DEF:__EVAL
                  DCD   0x8000
                ELSE 
                  IF    :DEF:SIZE_INT_INFO
                    DCD ||Image$$ER_IROM1$$RO$$Length||+\
                        ||Image$$RW_IRAM1$$RW$$Length||
                  ELIF  :DEF:SIZE_EXT_INFO
                    DCD ||Image$$ER_ROM1$$RO$$Length||+\
                        ||Image$$RW_RAM1$$RW$$Length||
                  ELSE
                    NOP
                  ENDIF
                ENDIF
                LDR     PC,[PC,#-0xF20] ; Vector From AIC_IVR
                LDR     PC,[PC,#-0xF20] ; Vector From AIC_FVR

Reset_Addr      DCD     Reset_Handler
Undef_Addr      DCD     Undef_Handler
SWI_Addr        DCD     SWI_Handler
PAbt_Addr       DCD     PAbt_Handler
DAbt_Addr       DCD     DAbt_Handler
                DCD     0               ; Reserved Address
IRQ_Addr        DCD     IRQ_Handler
FIQ_Addr        DCD     FIQ_Handler

Undef_Handler   B       Undef_Handler
                IF      :LNOT::DEF:__RTX
SWI_Handler     B       SWI_Handler
                ENDIF
PAbt_Handler    B       PAbt_Handler
DAbt_Handler    B       DAbt_Handler
IRQ_Handler     B       IRQ_Handler
FIQ_Handler     B       FIQ_Handler


; Reset Handler

                EXPORT  Reset_Handler
Reset_Handler   

	IF      :DEF:__HW_INIT
; Setup Power Management Controller (PMC) --------------------------------------

                IF      (:LNOT::DEF:NO_PMC_INIT):LAND:(PMC_SETUP != 0)
                LDR     R0, =PMC_BASE

                ; System Clock Enable
                LDR     R1, =PMC_SCER_Val
                STR     R1, [R0, #PMC_SCER_OFS]

                ; Peripheral Clock Enable
                LDR     R1, =PMC_PCER_Val
                STR     R1, [R0, #PMC_PCER_OFS]

                ; Setup Main Oscillator
                IF      (CKGR_MOR_Val:AND:PMC_MOSCEN) != 0
                LDR     R1, =CKGR_MOR_Val
                STR     R1, [R0, #CKGR_MOR_OFS]

                ; Wait until Main Oscillator is stabilized
MOSCS_Loop      LDR     R2, [R0, #PMC_SR_OFS]
                ANDS    R2, R2, #PMC_MOSCS
                BEQ     MOSCS_Loop
                ENDIF

                ; Setup the PLL A
                IF      (CKGR_PLLAR_Val:AND:PMC_MUL) != 0  
                LDR     R1, =CKGR_PLLAR_Val
                STR     R1, [R0, #CKGR_PLLAR_OFS]

                ; Wait until PLL A is stabilized
PLLA_Loop       LDR     R2, [R0, #PMC_SR_OFS]
                ANDS    R2, R2, #PMC_LOCKA
                BEQ     PLLA_Loop
                ENDIF

                ; Setup the PLL B
                IF      (CKGR_PLLBR_Val:AND:PMC_MUL) != 0  
                LDR     R1, =CKGR_PLLBR_Val
                STR     R1, [R0, #CKGR_PLLBR_OFS]

                ; Wait until PLL B is stabilized
PLLB_Loop       LDR     R2, [R0, #PMC_SR_OFS]
                ANDS    R2, R2, #PMC_LOCKB
                BEQ     PLLB_Loop
                ENDIF

                ; Setup the Master Clock and the Processor Clock
                LDR     R1, =PMC_MCKR_Val
                LDR     R2, =(PMC_MCKR_Val:AND:0x0000001C)

                ; Program PRES field only
                STR     R2, [R0, #PMC_MCKR_OFS]

                ; Wait until Main Master Clock is ready
MCKR_Loop1      LDR     R2, [R0, #PMC_SR_OFS]
                ANDS    R2, R2, #PMC_MCKRDY
                BEQ     MCKR_Loop1

                ; Program all fields
                STR     R1, [R0, #PMC_MCKR_OFS]

                ; Wait until Main Master Clock is ready
MCKR_Loop2      LDR     R2, [R0, #PMC_SR_OFS]
                ANDS    R2, R2, #PMC_MCKRDY
                BEQ     MCKR_Loop2

                ; Setup Programmable Clock Register 0
                LDR     R1, =PMC_PCK0_Val
                STR     R1, [R0, #PMC_PCK0_OFS]

                ; Setup Programmable Clock Register 1
                LDR     R1, =PMC_PCK1_Val
                STR     R1, [R0, #PMC_PCK1_OFS]

                ; Setup Programmable Clock Register 2
                LDR     R1, =PMC_PCK2_Val
                STR     R1, [R0, #PMC_PCK2_OFS]

                ; Setup Programmable Clock Register 3
                LDR     R1, =PMC_PCK3_Val
                STR     R1, [R0, #PMC_PCK3_OFS]
                ENDIF   ; of IF      (:LNOT::DEF:NO_PMC_INIT):LAND:(PMC_SETUP != 0)


; Setup Static Memory Controller (SMC) -----------------------------------------

                ; Setup Static Memory Controller if enabled
                IF      SMC_SETUP != 0
                LDR     R0, =SMC_BASE

                ; Macro for setting the Static Memory Controller
                MACRO
$label          SMC_Cod $cs

$label          LDR     R1, =SMC_SETUP$cs._Val
                STR     R1, [R0, #SMC_SETUP$cs._OFS]
                LDR     R1, =SMC_PULSE$cs._Val
                STR     R1, [R0, #SMC_PULSE$cs._OFS]
                LDR     R1, =SMC_CYCLE$cs._Val
                STR     R1, [R0, #SMC_CYCLE$cs._OFS]
                LDR     R1, =SMC_MODE$cs._Val
                STR     R1, [R0, #SMC_MODE$cs._OFS]
                MEND

                IF      SMC_CS0_SETUP != 0  ; Setup SMC for CS0 if required
SMC_0           SMC_Cod 0
                ENDIF
                IF      SMC_CS1_SETUP != 0  ; Setup SMC for CS1 if required
SMC_1           SMC_Cod 1
                ENDIF
                IF      SMC_CS2_SETUP != 0  ; Setup SMC for CS2 if required
SMC_2           SMC_Cod 2
                ENDIF
                IF      SMC_CS3_SETUP != 0  ; Setup SMC for CS3 if required
SMC_3           SMC_Cod 3
                ENDIF
                IF      SMC_CS4_SETUP != 0  ; Setup SMC for CS4 if required
SMC_4           SMC_Cod 4
                ENDIF
                IF      SMC_CS5_SETUP != 0  ; Setup SMC for CS5 if required
SMC_5           SMC_Cod 5
                ENDIF
                IF      SMC_CS6_SETUP != 0  ; Setup SMC for CS6 if required
SMC_6           SMC_Cod 6
                ENDIF
                IF      SMC_CS7_SETUP != 0  ; Setup SMC for CS7 if required
SMC_7           SMC_Cod 7
                ENDIF

                ENDIF   ; of IF      SMC_SETUP != 0


; Setup Bus Matrix (MATRIX) ----------------------------------------------------

                IF      MATRIX_SETUP != 0
                LDR     R0, =MATRIX_BASE

                LDR     R1, =MATRIX_SCFG0_Val
                STR     R1, [R0, #MATRIX_SCFG0_OFS]
                LDR     R1, =MATRIX_SCFG1_Val
                STR     R1, [R0, #MATRIX_SCFG1_OFS]
                LDR     R1, =MATRIX_SCFG2_Val
                STR     R1, [R0, #MATRIX_SCFG2_OFS]
                LDR     R1, =MATRIX_SCFG3_Val
                STR     R1, [R0, #MATRIX_SCFG3_OFS]
                LDR     R1, =MATRIX_SCFG4_Val
                STR     R1, [R0, #MATRIX_SCFG4_OFS]

                LDR     R1, =MATRIX_MCFG0_Val
                STR     R1, [R0, #MATRIX_MCFG0_OFS]
                LDR     R1, =MATRIX_MCFG1_Val
                STR     R1, [R0, #MATRIX_MCFG1_OFS]
                LDR     R1, =MATRIX_MCFG2_Val
                STR     R1, [R0, #MATRIX_MCFG2_OFS]
                LDR     R1, =MATRIX_MCFG3_Val
                STR     R1, [R0, #MATRIX_MCFG3_OFS]
                LDR     R1, =MATRIX_MCFG4_Val
                STR     R1, [R0, #MATRIX_MCFG4_OFS]
                LDR     R1, =MATRIX_MCFG5_Val
                STR     R1, [R0, #MATRIX_MCFG5_OFS]

                LDR     R1, =MATRIX_PRAS0_Val
                STR     R1, [R0, #MATRIX_PRAS0_OFS]
                LDR     R1, =MATRIX_PRAS1_Val
                STR     R1, [R0, #MATRIX_PRAS1_OFS]
                LDR     R1, =MATRIX_PRAS2_Val
                STR     R1, [R0, #MATRIX_PRAS2_OFS]
                LDR     R1, =MATRIX_PRAS3_Val
                STR     R1, [R0, #MATRIX_PRAS3_OFS]
                LDR     R1, =MATRIX_PRAS4_Val
                STR     R1, [R0, #MATRIX_PRAS4_OFS]
                ENDIF   ; of IF      MATRIX_SETUP != 0

; Setup External Bus Interface (EBI) -------------------------------------------

                IF      (:LNOT::DEF:NO_EBI_INIT):LAND:(EBI_SETUP != 0)
                LDR     R0, =MATRIX_BASE
                LDR     R1, =EBI_CSA_Val
                STR     R1, [R0, #EBI_CSA_OFS]
                ENDIF   ; of IF      (:LNOT::DEF:NO_EBI_INIT):LAND:(EBI_SETUP != 0)


; Setup SDRAM Controller (SDRAMC) ----------------------------------------------

                ; Setup SDRAM Controller if enabled
                IF      (:LNOT::DEF:NO_SDRAM_INIT):LAND:(SDRAMC_SETUP != 0)

                ; Enable pins for SDRAM interfacing
                LDR     R0, =PIOC_BASE
                LDR     R1, =0xFFFF0000  
                STR     R1, [R0, #PIO_PUDR_OFS]
                STR     R1, [R0, #PIO_ASR_OFS]
                STR     R1, [R0, #PIO_PDR_OFS]

                LDR     R0, =SDRAMC_BASE
                LDR     R2, =EBI_CS1_ADDRESS
                MOV     R3, #0

                ; Setup Control Register of SDRAM Controller
                LDR     R1, =SDRAMC_CR_Val
                STR     R1, [R0, #SDRAMC_CR_OFS]

                MOV     R1, #1000
Wait_SDRAMC_0   SUBS    R1, R1, #1
                BNE     Wait_SDRAMC_0

                ; Write Nop Command to SDRAM
                MOV     R1, #CMD_NOP
                STR     R1, [R0, #SDRAMC_MR_OFS]
                STR     R3, [R2, #0]

                ; Write All Banks Precharge Command to SDRAM
                MOV     R1, #CMD_PRCGALL
                STR     R1, [R0, #SDRAMC_MR_OFS]
                STR     R3, [R2, #0]

                MOV     R1, #1000
Wait_SDRAMC_1   SUBS    R1, R1, #1
                BNE     Wait_SDRAMC_1

                ; Provide 8 Auto Refresh to SDRAM
                MOV     R1, #CMD_RFSH
                MOV     R4, R3

                STR     R1, [R0, #SDRAMC_MR_OFS]  ; Set 1 CBR
                STR     R4, [R2, #0x00]           ; Perform CBR
                STR     R4, [R2, #0x00]           ; Perform CBR
                STR     R4, [R2, #0x00]           ; Perform CBR
                STR     R4, [R2, #0x00]           ; Perform CBR
                STR     R4, [R2, #0x00]           ; Perform CBR
                STR     R4, [R2, #0x00]           ; Perform CBR
                STR     R4, [R2, #0x00]           ; Perform CBR
                STR     R4, [R2, #0x00]           ; Perform CBR

                ; Write a Load Mode Register Command to SDRAM
                MOV     R1, #CMD_LMR
                LDR     R4, =0x00000020
                STR     R1, [R0, #SDRAMC_MR_OFS]  ; Set LMR Operation
                STR     R4, [R2, #24]

                ; Write Nop Command to SDRAM
                MOV     R1, #CMD_NOP
                STR     R1, [R0, #SDRAMC_MR_OFS]
                STR     R3, [R2, #0]

                ; Enter Normal Mode
                MOV     R1, #CMD_NORMAL
                STR     R1, [R0, #SDRAMC_MR_OFS]
                STR     R3, [R2, #0x00]

                ; Setup Refresh Timer Register
                LDR     R1, =SDRAMC_TR_Val
                STR     R1, [R0, #SDRAMC_TR_OFS]

                ; Setup Other SDRAM Controller Registers
                LDR     R1, =SDRAMC_LPR_Val
                STR     R1, [R0, #SDRAMC_LPR_OFS]
                LDR     R1, =SDRAMC_MDR_Val
                STR     R1, [R0, #SDRAMC_MDR_OFS]
                ENDIF   ; of IF      (:LNOT::DEF:NO_SDRAM_INIT):LAND:(SDRAMC_SETUP != 0)

	ENDIF ;  IF      :DEF:__HW_INIT

; Watchdog Timer Setup ---------------------------------------------------------

                IF      WDT_Val != 0 
                LDR     R0, =WDT_BASE   ; Disable Watchdog
                LDR     R1, =WDT_Val
                STR     R1, [R0, #WDT_MR_OFS]
                ENDIF


; Copy Exception Vectors to Internal RAM ---------------------------------------

                IF      :DEF:VEC_TO_RAM
                ADR     R8, Vectors     ; Source
                LDR     R9, =IRAM_BASE  ; Destination
                LDMIA   R8!, {R0-R7}    ; Load Vectors 
                STMIA   R9!, {R0-R7}    ; Store Vectors 
                LDMIA   R8!, {R0-R7}    ; Load Handler Addresses 
                STMIA   R9!, {R0-R7}    ; Store Handler Addresses
                ENDIF


; Remap on-chip RAM to address 0 -----------------------------------------------

                IF      :DEF:REMAP
                LDR     R0, =MATRIX_BASE
                MOV     R1, #3          ; Remap for Instruction and Data Master
                STR     R1, [R0, #MATRIX_MRCR_OFS]    ; Execute Remap
                ENDIF


; Cache Setup ------------------------------------------------------------------

                IF      ICACHE_SETUP != 0
                MRC     p15, 0, R0, c1, c0, 0   ; Enable Instruction Cache
                ORR     R0, R0, #ICACHE_ENABLE
                MCR     p15, 0, R0, c1, c0, 0
                ENDIF


; Setup Stack for each mode ----------------------------------------------------

                LDR     R0, =Stack_Top

;  Enter Undefined Instruction Mode and set its Stack Pointer
                MSR     CPSR_c, #Mode_UND:OR:I_Bit:OR:F_Bit
                MOV     SP, R0
                SUB     R0, R0, #UND_Stack_Size

;  Enter Abort Mode and set its Stack Pointer
                MSR     CPSR_c, #Mode_ABT:OR:I_Bit:OR:F_Bit
                MOV     SP, R0
                SUB     R0, R0, #ABT_Stack_Size

;  Enter FIQ Mode and set its Stack Pointer
                MSR     CPSR_c, #Mode_FIQ:OR:I_Bit:OR:F_Bit
                MOV     SP, R0
                SUB     R0, R0, #FIQ_Stack_Size

;  Enter IRQ Mode and set its Stack Pointer
                MSR     CPSR_c, #Mode_IRQ:OR:I_Bit:OR:F_Bit
                MOV     SP, R0
                SUB     R0, R0, #IRQ_Stack_Size

;  Enter Supervisor Mode and set its Stack Pointer
                MSR     CPSR_c, #Mode_SVC:OR:I_Bit:OR:F_Bit
                MOV     SP, R0
                SUB     R0, R0, #SVC_Stack_Size

;  Enter User Mode and set its Stack Pointer
                MSR     CPSR_c, #Mode_USR
                IF      :DEF:__MICROLIB

                EXPORT __initial_sp

                ELSE

                MOV     SP, R0
                SUB     SL, SP, #USR_Stack_Size

                ENDIF

; Enter the C code -------------------------------------------------------------

                IMPORT  __main
                LDR     R0, =__main
                BX      R0



                IF      :DEF:__MICROLIB

                EXPORT  __heap_base
                EXPORT  __heap_limit

                ELSE
; User Initial Stack & Heap
                AREA    |.text|, CODE, READONLY

                IMPORT  __use_two_region_memory
                EXPORT  __user_initial_stackheap
__user_initial_stackheap

                LDR     R0, =  Heap_Mem
                LDR     R1, =(Stack_Mem + USR_Stack_Size)
                LDR     R2, = (Heap_Mem +      Heap_Size)
                LDR     R3, = Stack_Mem
                BX      LR
                ENDIF


                END
