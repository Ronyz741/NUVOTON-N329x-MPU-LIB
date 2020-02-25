;/*****************************************************************************/
;/* TMPA900.S: Startup file for Toshiba TMPA910 device series                 */
;/*****************************************************************************/
;/* <<< Use Configuration Wizard in Context Menu >>>                          */ 
;/*****************************************************************************/
;/* This file is part of the uVision/ARM development tools.                   */
;/* Copyright (c) 2005-2008 Keil Software. All rights reserved.               */
;/* This software may only be used under the terms of a valid, current,       */
;/* end user licence from KEIL for a compatible version of KEIL software      */
;/* development tools. Nothing else gives you the right to use this software. */
;/*****************************************************************************/


; The TMPA910.S code is executed after CPU Reset. This file may be 
; translated with the following SET symbols. In uVision these SET 
; symbols are entered under Options - ASM - Define.
;
; CLOCK_NO_INIT:       if set, the clock controller is not initialized
;
; MPMC0_NO_INIT:       if set, the MPMC0 memory controller is not initialized
;
; DMC_MPMC0_NO_INIT:   if set, the dynamic memory controller on MCMP0 memory 
;                      controller is not initialized
;
; SMC_MPMC0_CS0_SETUP: if set, the static memory controller on MCMP0 memory 
;                      controller controlling CS0 is not initialized
;
; SMC_MPMC0_CS1_SETUP: if set, the static memory controller on MCMP0 memory 
;                      controller controlling CS1 is not initialized
;
; SMC_MPMC0_CS2_SETUP: if set, the static memory controller on MCMP0 memory 
;                      controller controlling CS2 is not initialized
;
; SMC_MPMC0_CS3_SETUP: if set, the static memory controller on MCMP0 memory 
;                      controller controlling CS3 is not initialized
;
; REMAP:               if set, the startup code remaps on-chip RAM to address 0


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


;----------------------- Stack and Heap Definitions ----------------------------

; <h> Stack Configuration (Stack Sizes in Bytes)
;   <o0> Undefined Mode      <0x0-0xFFFFFFFF:8>
;   <o1> Supervisor Mode     <0x0-0xFFFFFFFF:8>
;   <o2> Abort Mode          <0x0-0xFFFFFFFF:8>
;   <o3> Fast Interrupt Mode <0x0-0xFFFFFFFF:8>
;   <o4> Interrupt Mode      <0x0-0xFFFFFFFF:8>
;   <o5> User/System Mode    <0x0-0xFFFFFFFF:8>
; </h>

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


; <h> Heap Configuration
;   <o>  Heap Size (in Bytes) <0x0-0xFFFFFFFF>
; </h>

Heap_Size       EQU     0x00000000

                AREA    HEAP, NOINIT, READWRITE, ALIGN=3
__heap_base
Heap_Mem        SPACE   Heap_Size
__heap_limit


;----------------------- Memory Definitions ------------------------------------

; Internal Memory Base Addresses
IROM_BASE       EQU     0x00000000
IRAM_BASE       EQU     0xF8002000

; External Memory Base Addresses
SMCCS0n_BASE    EQU     0x00000000   
DMCCSn_BASE     EQU     0x40000000
SMCCS1n_BASE    EQU     0x60000000


;----------------------- Clock Definitions -------------------------------------

; Clock Controller User Interface
CLOCK_BASE      EQU     0xF0050000
SYSCR0_OFS      EQU     0x00
SYSCR1_OFS      EQU     0x04
SYSCR2_OFS      EQU     0x08
SYSCR3_OFS      EQU     0x0C
SYSCR4_OFS      EQU     0x10
SYSCR5_OFS      EQU     0x14
SYSCR6_OFS      EQU     0x18
SYSCR7_OFS      EQU     0x1C
SYSCR8_OFS      EQU     0x20
CLKCR5_OFS      EQU     0x54

; Constants
LUPFLAG_BIT     EQU     (1 << 0)
PLLON_BIT       EQU     (1 << 7)
PROT_KEY1       EQU     0x5A
PROT_KEY2       EQU     0xA5

; <e> Clock Configuration
;   <h> System Control Register 1 (SYSCR1)
;     <o2.0..1>   GEAR: Clock Gear Selection
;                   <0=> fc
;                   <1=> fc/2
;                   <2=> fc/4
;                   <3=> fc/8
;   </h>
;   <h> System Control Register 2 (SYSCR2)
;     <o3.1>      FCSEL: PLL Output Clock Selection
;                   <0=> fOSCH
;                   <1=> fPLL
;   </h>
;   <h> System Control Register 3 (SYSCR3)
;     <o4.7>      PLLON: PLL Operation Enable
;     <o4.0..4>   ND: PLL Constant Value Setting
;                   <5=> x6
;                   <7=> x8
;   </h>
;   <h> System Control Register 4 (SYSCR4)
;     <o5.4..7>   RS: PLL Constant Value Setting
;                   <6=> PLL equal or over 140 MHz
;                   <7=> PLL less than 140 MHz at x6
;                   <9=> PLL less than 140 MHz at x8
;     <o5.0..1>   FS: PLL Constant Value Setting
;                   <1=> PLL equal or over 140 MHz
;                   <2=> PLL less than 140 MHz
;   </h>
;   <h> System Control Register 8 (SYSCR8)
;     <o6.4..5>   USBD_CLKSEL: USB Device Clock Selection
;                   <0=> fixed at GND
;                   <1=> 1/2 clock of X1USB
;                   <2=> clock of X1USB
;                   <3=> clock of X1
;     <o6.0..2>   USBH_CLKSEL: USB Host Clock Selection
;                   <0=> fixed at GND
;                   <1=> clock of X1USB
;                   <2=> 1/3 fPLL
;                   <3=> fixed at GND
;                   <4=> 1/4 fPLL
;                   <5=> clock of X1
;                   <6=> fixed at GND
;                   <7=> fixed at GND
;   </h>
;   <h> Clock Control Register (CLKCR5)
;     <o7.4>      USBH_CLKEN: USB Host Clock Selection
;                   <0=> disable
;                   <1=> enable
;     <o7.3>      SEL_SLC_MCLK: SMC_MCLK Selection
;                   <0=> fHCLK/2
;                   <1=> fHCLK
;     <o7.2>      SEL_TIM45: Timer4 and Timer5 Prescaler Selection
;                   <0=> fs (32.768 kHz) clock
;                   <1=> fHCLK/2
;     <o7.1>      SEL_TIM23: Timer2 and Timer3 Prescaler Selection
;                   <0=> fs (32.768 kHz) clock
;                   <1=> fHCLK/2
;     <o7.0>      SEL_TIM01: Timer0 and Timer1 Prescaler Selection
;                   <0=> fs (32.768 kHz) clock
;                   <1=> fHCLK/2
;   </h>
;   <e7.0> Enable Clock Registers Write Protection
;     <i> Activate protection of writing to following registers:
;     <i> SYSCR1, SYSCR2, SYSCR3, SYSCR4, SYSCR5, SYSCR8 and CLKCR5
;   </e>
; </e>
CLOCK_SETUP     EQU     1
SYSCR0_Val      EQU     0x00000022
SYSCR1_Val      EQU     0x00000000
SYSCR2_Val      EQU     0x00000002
SYSCR3_Val      EQU     0x00000087
SYSCR4_Val      EQU     0x00000095
SYSCR8_Val      EQU     0x00000000
CLKCR5_Val      EQU     0x0000005E
PROT_SETUP      EQU     0


;----------------------- MPMC0 Definitions -------------------------------------

; MPMC0 Memory Controller User Interface
MPMC0_DMC_BASE            EQU   0xF4300000
MPMC0_SMC_BASE            EQU   0xF4301000
DMC_MEMC_STATUS_3_OFS     EQU   0x0000
DMC_MEMC_CMD_3_OFS        EQU   0x0004
DMC_DIRECT_CMD_3_OFS      EQU   0x0008
DMC_MEMORY_CFG_3_OFS      EQU   0x000C
DMC_REFRESH_PRD_3_OFS     EQU   0x0010
DMC_CAS_LATENCY_3_OFS     EQU   0x0014
DMC_T_DQSS_3_OFS          EQU   0x0018
DMC_T_MRD_3_OFS           EQU   0x001C
DMC_T_RAS_3_OFS           EQU   0x0020
DMC_T_RC_3_OFS            EQU   0x0024
DMC_T_RCD_3_OFS           EQU   0x0028
DMC_T_RFC_3_OFS           EQU   0x002C
DMC_T_RP_3_OFS            EQU   0x0030
DMC_T_RRD_3_OFS           EQU   0x0034
DMC_T_WR_3_OFS            EQU   0x0038
DMC_T_WTR_3_OFS           EQU   0x003C
DMC_T_XP_3_OFS            EQU   0x0040
DMC_T_XSR_3_OFS           EQU   0x0044
DMC_T_ESR_3_OFS           EQU   0x0048
DMC_ID_0_CFG_3_OFS        EQU   0x0100
DMC_ID_1_CFG_3_OFS        EQU   0x0104
DMC_ID_2_CFG_3_OFS        EQU   0x0108
DMC_ID_3_CFG_3_OFS        EQU   0x010C
DMC_CHIP_0_CFG_3_OFS      EQU   0x0200
DMC_USER_CONFIG_3_OFS     EQU   0x0304
SMC_MEMC_STATUS_3_OFS     EQU   0x0000
SMC_MEMIF_CFG_3_OFS       EQU   0x0004
SMC_DIRECT_CMD_3_OFS      EQU   0x0010
SMC_SET_CYCLES_3_OFS      EQU   0x0014
SMC_SET_OPMODE_3_OFS      EQU   0x0018
SMC_SRAM_CYCLES0_0_3_OFS  EQU   0x0100
SMC_SRAM_CYCLES0_1_3_OFS  EQU   0x0120
SMC_OPMODE0_0_3_OFS       EQU   0x0104
SMC_OPMODE0_1_3_OFS       EQU   0x0124

; Constants
MEMC_CMD_GO     EQU     (0x0 <<  0)     ; Go            Command
MEMC_CMD_SLEEP  EQU     (0x1 <<  0)     ; Sleep         Command
MEMC_CMD_WAKEUP EQU     (0x2 <<  0)     ; Wakeup        Command
MEMC_CMD_PAUSE  EQU     (0x3 <<  0)     ; Pause         Command
MEMC_CMD_CFG    EQU     (0x4 <<  0)     ; Configure     Command
PALL_CMD        EQU     (0x0 << 18)     ; Precharge All Command
AREFSH_MODE     EQU     (0x1 << 18)     ; Auto-Refresh  Command
MODE_CMD        EQU     (0x2 << 18)     ; MODE          Command
NORMAL_CMD      EQU     (0x3 << 18)     ; NORMAL        Command


; <e> MPMC0 Memory Controller Setup
MPMC0_SETUP     EQU     1

;   <e> Dynamic Memory Controller (DMC) Setup
DMC_MPMC0_SETUP EQU     1

;     <h> DMC Configuration Register (DMC_MEMORY_CFG_3)
;       <i> Configures operation of the memory controller
;       <o0.21..22> ACTIVE_CHIPS: Number of memory chips that can generate the Refresh command
;                   <0=> 1 chip
;       <o0.15..17> MEMORY_BURST: Read and write burst length for the SDRAM
;                   <0=> burst 1
;                   <1=> burst 2
;                   <2=> burst 4
;                   <3=> burst 8
;                   <4=> burst 16
;       <o0.14>     STOP_MEM_CLOCK: Memory Clock stop enable
;       <o0.13>     AUTO_POWER_DOWN: SDRAM auto power-down enable
;       <o0.7..12>  POWER_DOWN_PRD: Number of automatic power-down memory clocks <1-63>
;       <o0.6>      AP_BIT: Position of auto-precharge bit in memory address
;                   <0=> address bit 10
;                   <1=> address bit 8
;       <o0.3..5>   ROW_BITS: Number of row address bits
;                   <0=> 11 bits
;                   <1=> 12 bits
;                   <2=> 13 bits
;                   <3=> 14 bits
;                   <4=> 15 bits
;                   <5=> 16 bits
;       <o0.0..2>   COLUMN_BITS: Number of column address bits
;                   <0=> 8 bits
;                   <1=> 9 bits
;                   <2=> 10 bits
;                   <3=> 11 bits
;                   <4=> 12 bits
;     </h>
DMC_MEMORY_CFG_3_Val    EQU   0x00018011

;     <o0.0..14>    DMC Refresh Time Register (DMC_REFRESH_PRD_3) <0x0-0x7FFF>
;       <i> REFRESH_PRD: Auto-refresh cycle (number of memory clocks)
;     <o1.1..3>     DMC CAS Latency Register (DMC_CAS_LATENCY_3) <0x0-0x7>
;       <i> CAS_LATENCY: CAS Latency setting (number of memory clocks)
;     <o2.0..1>     DMC t_dqss Register (DMC_T_DQSS_3) <0x0-0x3>
;       <i> T_DQSS: DQS setting (number of memory clocks) in the initial state
;     <o3.0..6>     DMC t_mrd Register (DMC_T_MRD_3) <0x0-0x7F>
;       <i> T_MRD: Mode register command time (number of memory clocks)
;     <o4.0..3>     DMC t_ras Register (DMC_T_RAS_3) <0x0-0xF>
;       <i> T_RAS: Time between RAS and Precharge (number of memory clocks)
;     <o5.0..3>     DMC t_rc Register (DMC_T_RC_3) <0x0-0xF>
;       <i> T_RC: Delay between Active bank A and Active bank B (number of memory clocks)
;     <h>           DMC t_rcd Register (DMC_T_RCD_3)
;       <o6.3..5>   SCHEDULE_RCD: Set min delay from RAS to CAS <0x0-0x7>
;       <o6.0..2>   T_RCD: Set min delay from RAS to CAS (number of memory clocks) <0x0-0x7>
;     </h>
;     <h>           DMC t_rfc Register (DMC_T_RFC_3)
;       <o7.5..9>   SCHEDULE_RFC: Autorefresh command time setting <0x0-0x1F>
;       <o7.0..4>   T_RFC: Autorefresh command time setting (number of memory clocks) <0x0-0x1F>
;     </h>
;     <h>           DMC t_rp Register (DMC_T_RP_3)
;       <o8.3..5>   SCHEDULE_RP: Precharge delay setting to RAS <0x0-0x7>
;       <o8.0..2>   T_RP: Precharge delay setting to RAS (number of memory clocks) <0x0-0x7>
;     </h>
;     <o9.0..3>     DMC t_rrd Register (DMC_T_RRD_3) <0x0-0xF>
;       <i> T_RRD: Delay time from Active bank A to Active bank B (number of memory clocks)
;     <o10.0..2>    DMC t_wr Register (DMC_T_WR_3) <0x0-0x7>
;       <i> T_WR: Delay from write last data to Precharge (number of memory clocks)
;     <o11.0..2>    DMC t_wrt Register (DMC_T_WRT_3) <0x0-0x7>
;       <i> T_WRT: Setting value from write last data to read command (number of memory clocks)
;     <o12.0..7>    DMC t_xp Register (DMC_T_XP_3) <0x0-0xFF>
;       <i> T_XP: Set the exit power-down command time (number of memory clocks)
;     <o13.0..7>    DMC t_xsr Register (DMC_T_XSR_3) <0x0-0xFF>
;       <i> T_XSR: Time from exit self-refresh command to other command (number of memory clocks)
;     <o14.0..7>    DMC t_esr Register (DMC_T_ESR_3) <0x0-0xFF>
;       <i> T_ESR: Minimum time from self-refresh entry to exit (number of memory clocks)
DMC_REFRESH_PRD_3_Val   EQU   0x000002EE
DMC_CAS_LATENCY_3_Val   EQU   0x00000006
DMC_T_DQSS_3_Val        EQU   0x00000000
DMC_T_MRD_3_Val         EQU   0x00000002
DMC_T_RAS_3_Val         EQU   0x00000004
DMC_T_RC_3_Val          EQU   0x00000006
DMC_T_RCD_3_Val         EQU   0x00000012
DMC_T_RFC_3_Val         EQU   0x00000087
DMC_T_RP_3_Val          EQU   0x00000012
DMC_T_RRD_3_Val         EQU   0x00000002
DMC_T_WR_3_Val          EQU   0x00000002
DMC_T_WTR_3_Val         EQU   0x00000001
DMC_T_XP_3_Val          EQU   0x00000000
DMC_T_XSR_3_Val         EQU   0x00000007
DMC_T_ESR_3_Val         EQU   0x0000000D

;     <h> DMC ID 0 Configuration Register (DMC_ID_0_CFG_3)
;       <i> Configures QoS parameters for AHB0: CPU Data
;       <o0.2..9>   QOS_MAX: Maximum QoS <0x0-0xFF>
;       <o0.1>      QOS_MIN: Minimum QoS selection
;                   <0=> QoS max mode
;                   <1=> QoS min mode
;       <o0.0>      QOS_ENABLE: Enable QoS
;     </h>
;     <h> DMC ID 1 Configuration Register (DMC_ID_1_CFG_3)
;       <i> Configures QoS parameters for AHB1: CPU Instruction
;       <o1.2..9>   QOS_MAX: Maximum QoS <0x0-0xFF>
;       <o1.1>      QOS_MIN: Minimum QoS selection
;                   <0=> QoS max mode
;                   <1=> QoS min mode
;       <o1.0>      QOS_ENABLE: Enable QoS
;     </h>
;     <h> DMC ID 2 Configuration Register (DMC_ID_2_CFG_3)
;       <i> Configures QoS parameters for AHB2: LCDC
;       <o2.2..9>   QOS_MAX: Maximum QoS <0x0-0xFF>
;       <o2.1>      QOS_MIN: Minimum QoS selection
;                   <0=> QoS max mode
;                   <1=> QoS min mode
;       <o2.0>      QOS_ENABLE: Enable QoS
;     </h>
;     <h> DMC ID 3 Configuration Register (DMC_ID_3_CFG_3)
;       <i> Configures QoS parameters for AHB3: Multilayer matrix 2
;       <i> (LCDDA, USB, DMAC1, DMAC2)
;       <o3.2..9>   QOS_MAX: Maximum QoS <0x0-0xFF>
;       <o3.1>      QOS_MIN: Minimum QoS selection
;                   <0=> QoS max mode
;                   <1=> QoS min mode
;       <o3.0>      QOS_ENABLE: Enable QoS
;     </h>
DMC_ID_0_CFG_3_Val      EQU   0x00000000
DMC_ID_1_CFG_3_Val      EQU   0x00000000
DMC_ID_2_CFG_3_Val      EQU   0x00000000
DMC_ID_3_CFG_3_Val      EQU   0x00000000

;     <h> DMC Chip 0 Configuration Register (DMC_CHIP_0_CFG_3)
;       <o0.16>     BRC_N_RBC: Memory address structure
;                   <0=> row, bank, column
;                   <1=> bank, row, column
;       <o0.8..15>  ADDRESS_MATCH: Set the AHB address [31:24] and a comparison value <0x0-0xFF>
;       <o0.0..7>   ADDRESS_MASK: Set the mask value of AHB address [31:24] <0x0-0xFF>
;     </h>
DMC_CHIP_0_CFG_3_Val    EQU   0x000140E0

;     <h> DMC User Configuration Register (DMC_USER_CONFIG_3)
;       <o0.0>      SDR_WIDTH: Memory data bus width
;                   <0=> 16 bits
;                   <1=> 32 bits
;     </h>
DMC_USER_CONFIG_3_Val   EQU   0x00000001
;   </e>

;   <e> Static Memory Controller (SMC) Setup for CS0
;     <h> SMC Set Cycles Register (SMC_SET_CYCLES)
;       <o1.17..19> SET_T5: Turnaround time (tTR) <0-7>
;       <o1.14..16> SET_T4: Page cycle time (tPC) <0-7>
;       <o1.11..13> SET_T3: Delay time for smc_we_n_0 (tWP) <0-7>
;       <o1.8..10>  SET_T2: Delay time for smc_oe_n_0 (tCEOE) <0-7>
;       <o1.4..7>   SET_T1: Write cycle time (tWC) <0-15>
;       <o1.0..3>   SET_T0: Read cycle time (tRC) <0-15>
;     </h>
;     <h> SMC Set Opmode Register (SMC_SET_OPMODE)
;       <o2.13..15> SET_BURST_ALIGN: Memory burst boundary split setting
;                   <0=> burst can cross any address boundary
;                   <1=> split at the 32-beat burst boundary
;                   <2=> split at the 64-beat burst boundary
;                   <3=> split at the 128-beat burst boundary
;                   <4=> split at the 256-beat burst boundary
;       <o2.12>     SET_BLS: BLS timing setting
;                   <0=> chip select timing
;       <o2.11>     SET_ADV: Address valid setting
;                   <0=> Memory does not use the address signal smc_adv
;                   <1=> Memory uses the address signal smc_adv
;       <o2.7..9>   SET_WR_BL: Write burst length
;                   <0=> 1 beat
;                   <1=> 4 beats
;       <o2.6>      SET_WR_SYNC: wr_sync setting
;                   <0=> Asynchronous write mode
;                   <1=> Synchronous write mode
;       <o2.3..5>   SET_RD_BL: Read burst length
;                   <0=> 1 beat
;                   <1=> 4 beats
;       <o2.2>      SET_RD_SYNC: rd_sync setting
;                   <0=> Asynchronous write mode
;                   <1=> Synchronous write mode
;       <o2.0..1>   SET_MW: Memory data bus width setting
;                   <1=> 16 bits
;                   <2=> 32 bits
;     </h>
;   </e>
SMC_MPMC0_CS0_SETUP     EQU   1
SMC_SET_CYCLES_0_3_Val  EQU   0x0008E0BB
SMC_SET_OPMODE_0_3_Val  EQU   0x00000001

;   <e> Static Memory Controller (SMC) Setup for CS1
;     <h> SMC Set Cycles Register (SMC_SET_CYCLES)
;       <o1.17..19> SET_T5: Turnaround time (tTR) <0-7>
;       <o1.14..16> SET_T4: Page cycle time (tPC) <0-7>
;       <o1.11..13> SET_T3: Delay time for smc_we_n_0 (tWP) <0-7>
;       <o1.8..10>  SET_T2: Delay time for smc_oe_n_0 (tCEOE) <0-7>
;       <o1.4..7>   SET_T1: Write cycle time (tWC) <0-15>
;       <o1.0..3>   SET_T0: Read cycle time (tRC) <0-15>
;     </h>
;     <h> SMC Set Opmode Register (SMC_SET_OPMODE)
;       <o2.13..15> SET_BURST_ALIGN: Memory burst boundary split setting
;                   <0=> burst can cross any address boundary
;                   <1=> split at the 32-beat burst boundary
;                   <2=> split at the 64-beat burst boundary
;                   <3=> split at the 128-beat burst boundary
;                   <4=> split at the 256-beat burst boundary
;       <o2.12>     SET_BLS: BLS timing setting
;                   <0=> chip select timing
;       <o2.11>     SET_ADV: Address valid setting
;                   <0=> Memory does not use the address signal smc_adv
;                   <1=> Memory uses the address signal smc_adv
;       <o2.7..9>   SET_WR_BL: Write burst length
;                   <0=> 1 beat
;                   <1=> 4 beats
;       <o2.6>      SET_WR_SYNC: wr_sync setting
;                   <0=> Asynchronous write mode
;                   <1=> Synchronous write mode
;       <o2.3..5>   SET_RD_BL: Read burst length
;                   <0=> 1 beat
;                   <1=> 4 beats
;       <o2.2>      SET_RD_SYNC: rd_sync setting
;                   <0=> Asynchronous write mode
;                   <1=> Synchronous write mode
;       <o2.0..1>   SET_MW: Memory data bus width setting
;                   <1=> 16 bits
;                   <2=> 32 bits
;     </h>
;   </e>
SMC_MPMC0_CS1_SETUP     EQU   0
SMC_SET_CYCLES_1_3_Val  EQU   0x00000000
SMC_SET_OPMODE_1_3_Val  EQU   0x00000000


; </e>


;----------------------- Cache Definitions -------------------------------------

; Constants
ICACHE_EN_BIT   EQU     (1<<12)                 ; Instruction Cache Enable Bit

; <e> Instruction Cache Enable
; </e>
ICACHE_SETUP    EQU     1


;----------------------- CODE --------------------------------------------------

                PRESERVE8
                

; Area Definition and Entry Point
;  Startup Code must be linked first at Address at which it expects to run.

                AREA    RESET, CODE, READONLY
                ARM

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
                NOP                             ; Reserved
                B       IRQ_Handler  
                LDR     PC,FIQ_Addr

Reset_Addr      DCD     Reset_Handler
Undef_Addr      DCD     Undef_Handler
SWI_Addr        DCD     SWI_Handler
PAbt_Addr       DCD     PAbt_Handler
DAbt_Addr       DCD     DAbt_Handler
FIQ_Addr        DCD     FIQ_Handler

Undef_Handler   B       Undef_Handler
                IF      :LNOT::DEF:__RTX
SWI_Handler     B       SWI_Handler
                ENDIF
PAbt_Handler    B       PAbt_Handler
DAbt_Handler    B       DAbt_Handler
IRQ_Handler     STMDB   SP!,{R0,PC}               ; Store R0, PC (PC is dummy)
                LDR     R0, =0xF4000F00           ; Address of VICADDRESS
                LDR     R0,[R0, #0]               ; IRQ Address from VICADDRESS
                STR     R0,[SP, #4]               ; Put address of IRQ on stack
                LDMIA   SP!,{R0,PC}               ; Jump to IRQ and restore R0
FIQ_Handler     B       FIQ_Handler


; Reset Handler

                EXPORT  Reset_Handler
Reset_Handler   


; Clock Setup ------------------------------------------------------------------

                IF      (:LNOT::DEF:CLOCK_NO_INIT):LAND:(CLOCK_SETUP != 0)
                LDR     R0, =CLOCK_BASE
                MOV     R1, #SYSCR1_Val
                STR     R1, [R0, #SYSCR1_OFS]
                MOV     R1, #CLKCR5_Val
                STR     R1, [R0, #CLKCR5_OFS]
                MOV     R1, #SYSCR3_Val
                STR     R1, [R0, #SYSCR3_OFS]
                IF      (SYSCR3_Val:AND:PLLON_BIT) != 0
PLL_Lock        LDR     R1, [R0, #SYSCR2_OFS]
                TST     R1, #LUPFLAG_BIT
                BEQ     PLL_Lock
                ENDIF   ;(SYSCR3_Val:AND:PLLON_BIT) != 0
                MOV     R1, #SYSCR4_Val
                STR     R1, [R0, #SYSCR4_OFS]
                MOV     R1, #SYSCR2_Val
                STR     R1, [R0, #SYSCR2_OFS]
                IF      (PROT_SETUP != 0)
                MOV     R1, =PROT_KEY1
                MOV     R2, =PROT_KEY1
                STR     R1, [R0, #SYSCR6_OFS]
                STR     R2, [R0, #SYSCR7_OFS]
                STR     R2, [R0, #SYSCR6_OFS]
                STR     R1, [R0, #SYSCR7_OFS]
                ENDIF   ;(PROT_SETUP != 0)
                ENDIF   ;(:LNOT::DEF:CLOCK_NO_INIT):LAND:(CLOCK_SETUP != 0)


; MPMC0 Memory Controller Setup ------------------------------------------------

                IF      (:LNOT::DEF:MPMC0_NO_INIT):LAND:(MPMC0_SETUP != 0)
                LDR     R0, =MPMC0_DMC_BASE
                LDR     R1, =MPMC0_SMC_BASE

;  Dynamic Memory Controller Setup ---------------------------------------------

                IF      (:LNOT::DEF:DMC_MPMC0_NO_INIT):LAND:(DMC_MPMC0_SETUP != 0)
                MOV     R2, #MEMC_CMD_CFG
                STR     R2, [R0, #DMC_MEMC_CMD_3_OFS]

                MOV     R2, #DMC_USER_CONFIG_3_Val
                STR     R2, [R0, #DMC_USER_CONFIG_3_OFS]

                MOV     R2, #DMC_CAS_LATENCY_3_Val
                STR     R2, [R0, #DMC_CAS_LATENCY_3_OFS]
                MOV     R2, #DMC_T_DQSS_3_Val
                STR     R2, [R0, #DMC_T_DQSS_3_OFS]
                MOV     R2, #DMC_T_MRD_3_Val
                STR     R2, [R0, #DMC_T_MRD_3_OFS]
                MOV     R2, #DMC_T_RAS_3_Val
                STR     R2, [R0, #DMC_T_RAS_3_OFS]
                MOV     R2, #DMC_T_RC_3_Val
                STR     R2, [R0, #DMC_T_RC_3_OFS]
                MOV     R2, #DMC_T_RCD_3_Val
                STR     R2, [R0, #DMC_T_RCD_3_OFS]
                LDR     R2, =DMC_T_RFC_3_Val
                STR     R2, [R0, #DMC_T_RFC_3_OFS]
                MOV     R2, #DMC_T_RP_3_Val
                STR     R2, [R0, #DMC_T_RP_3_OFS]
                MOV     R2, #DMC_T_RRD_3_Val
                STR     R2, [R0, #DMC_T_RRD_3_OFS]
                MOV     R2, #DMC_T_WR_3_Val
                STR     R2, [R0, #DMC_T_WR_3_OFS]
                MOV     R2, #DMC_T_WTR_3_Val
                STR     R2, [R0, #DMC_T_WTR_3_OFS]
                MOV     R2, #DMC_T_XP_3_Val
                STR     R2, [R0, #DMC_T_XP_3_OFS]
                MOV     R2, #DMC_T_XSR_3_Val
                STR     R2, [R0, #DMC_T_XSR_3_OFS]
                MOV     R2, #DMC_T_ESR_3_Val
                STR     R2, [R0, #DMC_T_ESR_3_OFS]
                LDR     R2, =DMC_REFRESH_PRD_3_Val
                STR     R2, [R0, #DMC_REFRESH_PRD_3_OFS]

                LDR     R2, =DMC_MEMORY_CFG_3_Val
                STR     R2, [R0, #DMC_MEMORY_CFG_3_OFS]

                LDR     R2, =DMC_ID_0_CFG_3_Val
                STR     R2, [R0, #DMC_ID_0_CFG_3_OFS]
                LDR     R2, =DMC_ID_1_CFG_3_Val
                STR     R2, [R0, #DMC_ID_1_CFG_3_OFS]
                LDR     R2, =DMC_ID_2_CFG_3_Val
                STR     R2, [R0, #DMC_ID_2_CFG_3_OFS]
                LDR     R2, =DMC_ID_3_CFG_3_Val
                STR     R2, [R0, #DMC_ID_3_CFG_3_OFS]

                LDR     R2, =DMC_CHIP_0_CFG_3_Val
                STR     R2, [R0, #DMC_CHIP_0_CFG_3_OFS]

                LDR     R3, =4800               ; ~100us at 192 MHz
                LDR     R4, =48                 ; ~1us at 192 MHz

                MOV     R6, R3                  ; ~100us at 192 MHz
Wait_0          SUBS    R6, R6, #1
                BNE     Wait_0

                MOV     R2, #NORMAL_CMD
                STR     R2, [R0, #DMC_DIRECT_CMD_3_OFS]

                MOV     R6, R3                  ; ~100us at 192 MHz
Wait_1          SUBS    R6, R6, #1
                BNE     Wait_1

                MOV     R2, #PALL_CMD
                STR     R2, [R0, #DMC_DIRECT_CMD_3_OFS]

                MOV     R6, R3                  ; ~100us at 192 MHz
Wait_2          SUBS    R6, R6, #1
                BNE     Wait_2

                MOV     R2, #AREFSH_MODE
                STR     R2, [R0, #DMC_DIRECT_CMD_3_OFS]

                MOV     R6, R4                  ; ~1us at 192 MHz
Wait_3          SUBS    R6, R6, #1
                BNE     Wait_3

                MOV     R2, #AREFSH_MODE
                STR     R2, [R0, #DMC_DIRECT_CMD_3_OFS]

                MOV     R6, R4                  ; ~1us at 192 MHz
Wait_4          SUBS    R6, R6, #1
                BNE     Wait_4

                LDR     R2, =(MODE_CMD:OR:(3<<4):OR:(3<<0))
                STR     R2, [R0, #DMC_DIRECT_CMD_3_OFS]

                MOV     R2, #NORMAL_CMD
                STR     R2, [R0, #DMC_DIRECT_CMD_3_OFS]

                MOV     R2, #MEMC_CMD_GO
                STR     R2, [R0, #DMC_MEMC_CMD_3_OFS]

                MOV     R6, R3                  ; ~100us at 192 MHz
Wait_5          SUBS    R6, R6, #1
                BNE     Wait_5
                ENDIF   ;(:LNOT::DEF:DMC_MPMC0_NO_INIT):LAND:(DMC_MPMC0_SETUP != 0)

;  Static Memory Controller Setup ----------------------------------------------

                IF      (:LNOT::DEF:SMC_MPMC0_CS0_NO_INIT):LAND:(SMC_MPMC0_CS0_SETUP != 0)
                LDR     R3, =SMC_SET_CYCLES_0_3_Val
                LDR     R4, =SMC_SET_OPMODE_0_3_Val
                MOV     R5, #(2<<21)
                STR     R3, [R0, #SMC_SET_CYCLES_3_OFS]
                STR     R3, [R0, #SMC_SET_OPMODE_3_OFS]
                STR     R3, [R0, #SMC_DIRECT_CMD_3_OFS]
                ENDIF   ;(:LNOT::DEF:SMC_MPMC0_CS0_NO_INIT):LAND:(SMC_MPMC0_CS0_SETUP != 0)

                IF      (:LNOT::DEF:SMC_MPMC0_CS1_NO_INIT):LAND:(SMC_MPMC0_CS1_SETUP != 0)
                LDR     R3, =SMC_SET_CYCLES_1_3_Val
                LDR     R4, =SMC_SET_OPMODE_1_3_Val
                MOV     R5, #(2<<21)
                STR     R3, [R0, #SMC_SET_CYCLES_3_OFS]
                STR     R3, [R0, #SMC_SET_OPMODE_3_OFS]
                STR     R3, [R0, #SMC_DIRECT_CMD_3_OFS]
                ENDIF   ;(:LNOT::DEF:SMC_MPMC0_CS1_NO_INIT):LAND:(SMC_MPMC0_CS1_SETUP != 0)


                ENDIF   ;(:LNOT::DEF:MPMC0_NO_INIT):LAND:(MPMC0_SETUP != 0)


; Remap on-chip RAM to address 0 -----------------------------------------------

REMAP_REG       EQU     0xF0000004

                IF      :DEF:REMAP
                LDR     R0, =REMAP_REG
                MOV     R1, #1
                STR     R1, [R0, #0]            ; Remap
                ENDIF


; Cache Setup ------------------------------------------------------------------

                IF      ICACHE_SETUP != 0
                MRC     p15, 0, R0, c1, c0, 0   ; Enable Instruction Cache
                ORR     R0, R0, #ICACHE_EN_BIT
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


; Enter the C code

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
