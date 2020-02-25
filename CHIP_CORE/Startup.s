;/*****************************************************************************/
;/* STARTUP.S: Startup file for Dhrystone Example                             */
;/*****************************************************************************/
;/* <<< Use Configuration Wizard in Context Menu >>>                          */ 
;/*****************************************************************************/
;/* This file is part of the uVision/ARM development tools.                   */
;/* Copyright (c) 2005-2006 Keil Software. All rights reserved.               */
;/* This software may only be used under the terms of a valid, current,       */
;/* end user licence from KEIL for a compatible version of KEIL software      */
;/* development tools. Nothing else gives you the right to use this software. */
;/*****************************************************************************/


; *** Startup Code (executed after Reset) ***


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


; Internal RAM Address
RAM_Base        EQU     0x00000000      ; after Ramap
RAM_Base_Boot   EQU     0x00300000      ; after Reset until Remap 


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

Heap_Size       EQU     0x00010000

                AREA    HEAP, NOINIT, READWRITE, ALIGN=3
__heap_base
Heap_Mem        SPACE   Heap_Size
__heap_limit


;// <h> External Bus Interface (EBI)
EBI_BASE        EQU     0xFFE00000

;//   <e.13> Enable Chip Select 0 (CSR0)
;//     <o.20..31> BA: Base Address <0x0-0xFFF00000:0x100000><#/0x100000>
;//                <i> Start Address for Chip Select Signal
;//     <o.7..8>   PAGES: Page Size      <0=> 1M Byte    <1=> 4M Bytes
;//                                      <2=> 16M Bytes  <3=> 64M Bytes
;//                <i> Selects Active Bits in Base Address
;//     <o.0..1>   DBW: Data Bus Width   <1=> 16-bit     <2=> 8-bit
;//     <o.12>     BAT: Byte Access Type <0=> Byte-write
;//                                      <1=> Byte-select
;//     <e.5>      WSE: Enable Wait State Generation
;//       <o.2..4>   NWS: Number of Standard Wait States <1-8><#-1>
;//     </e>
;//     <o.9..11>  TDF: Data Float Output Time <0-7>
;//                <i> Number of Cycles Added after the Transfer
;//   </e>
EBI_CSR0_Val    EQU     0x010024A9

;//   <e.13> Enable Chip Select 1 (CSR1)
;//     <o.20..31> BA: Base Address <0x0-0xFFF00000:0x100000><#/0x100000>
;//                <i> Start Address for Chip Select Signal
;//     <o.7..8>   PAGES: Page Size      <0=> 1M Byte    <1=> 4M Bytes
;//                                      <2=> 16M Bytes  <3=> 64M Bytes
;//                <i> Selects Active Bits in Base Address
;//     <o.0..1>   DBW: Data Bus Width   <1=> 16-bit     <2=> 8-bit
;//     <o.12>     BAT: Byte Access Type <0=> Byte-write
;//                                      <1=> Byte-select
;//     <e.5>      WSE: Enable Wait State Generation
;//       <o.2..4>   NWS: Number of Standard Wait States <1-8><#-1>
;//     </e>
;//     <o.9..11>  TDF: Data Float Output Time <0-7>
;//                <i> Number of Cycles Added after the Transfer
;//   </e>
EBI_CSR1_Val    EQU     0x040034A5

;//   <e.13> Enable Chip Select 2 (CSR2)
;//     <o.20..31> BA: Base Address <0x0-0xFFF00000:0x100000><#/0x100000>
;//                <i> Start Address for Chip Select Signal
;//     <o.7..8>   PAGES: Page Size      <0=> 1M Byte    <1=> 4M Bytes
;//                                      <2=> 16M Bytes  <3=> 64M Bytes
;//                <i> Selects Active Bits in Base Address
;//     <o.0..1>   DBW: Data Bus Width   <1=> 16-bit     <2=> 8-bit
;//     <o.12>     BAT: Byte Access Type <0=> Byte-write
;//                                      <1=> Byte-select
;//     <e.5>      WSE: Enable Wait State Generation
;//       <o.2..4>   NWS: Number of Standard Wait States <1-8><#-1>
;//     </e>
;//     <o.9..11>  TDF: Data Float Output Time <0-7>
;//                <i> Number of Cycles Added after the Transfer
;//   </e>
EBI_CSR2_Val    EQU     0x20000000

;//   <e.13> Enable Chip Select 3 (CSR3)
;//     <o.20..31> BA: Base Address <0x0-0xFFF00000:0x100000><#/0x100000>
;//                <i> Start Address for Chip Select Signal
;//     <o.7..8>   PAGES: Page Size      <0=> 1M Byte    <1=> 4M Bytes
;//                                      <2=> 16M Bytes  <3=> 64M Bytes
;//                <i> Selects Active Bits in Base Address
;//     <o.0..1>   DBW: Data Bus Width   <1=> 16-bit     <2=> 8-bit
;//     <o.12>     BAT: Byte Access Type <0=> Byte-write
;//                                      <1=> Byte-select
;//     <e.5>      WSE: Enable Wait State Generation
;//       <o.2..4>   NWS: Number of Standard Wait States <1-8><#-1>
;//     </e>
;//     <o.9..11>  TDF: Data Float Output Time <0-7>
;//                <i> Number of Cycles Added after the Transfer
;//   </e>
EBI_CSR3_Val    EQU     0x30000000

;//   <e.13> Enable Chip Select 4 (CSR4)
;//     <o.20..31> BA: Base Address <0x0-0xFFF00000:0x100000><#/0x100000>
;//                <i> Start Address for Chip Select Signal
;//     <o.7..8>   PAGES: Page Size      <0=> 1M Byte    <1=> 4M Bytes
;//                                      <2=> 16M Bytes  <3=> 64M Bytes
;//                <i> Selects Active Bits in Base Address
;//     <o.0..1>   DBW: Data Bus Width   <1=> 16-bit     <2=> 8-bit
;//     <o.12>     BAT: Byte Access Type <0=> Byte-write
;//                                      <1=> Byte-select
;//     <e.5>      WSE: Enable Wait State Generation
;//       <o.2..4>   NWS: Number of Standard Wait States <1-8><#-1>
;//     </e>
;//     <o.9..11>  TDF: Data Float Output Time <0-7>
;//                <i> Number of Cycles Added after the Transfer
;//   </e>
EBI_CSR4_Val    EQU     0x40000000

;//   <e.13> Enable Chip Select 5 (CSR5)
;//     <o.20..31> BA: Base Address <0x0-0xFFF00000:0x100000><#/0x100000>
;//                <i> Start Address for Chip Select Signal
;//     <o.7..8>   PAGES: Page Size      <0=> 1M Byte    <1=> 4M Bytes
;//                                      <2=> 16M Bytes  <3=> 64M Bytes
;//                <i> Selects Active Bits in Base Address
;//     <o.0..1>   DBW: Data Bus Width   <1=> 16-bit     <2=> 8-bit
;//     <o.12>     BAT: Byte Access Type <0=> Byte-write
;//                                      <1=> Byte-select
;//     <e.5>      WSE: Enable Wait State Generation
;//       <o.2..4>   NWS: Number of Standard Wait States <1-8><#-1>
;//     </e>
;//     <o.9..11>  TDF: Data Float Output Time <0-7>
;//                <i> Number of Cycles Added after the Transfer
;//   </e>
EBI_CSR5_Val    EQU     0x50000000

;//   <e.13> Enable Chip Select 6 (CSR6)
;//     <o.20..31> BA: Base Address <0x0-0xFFF00000:0x100000><#/0x100000>
;//                <i> Start Address for Chip Select Signal
;//     <o.7..8>   PAGES: Page Size      <0=> 1M Byte    <1=> 4M Bytes
;//                                      <2=> 16M Bytes  <3=> 64M Bytes
;//                <i> Selects Active Bits in Base Address
;//     <o.0..1>   DBW: Data Bus Width   <1=> 16-bit     <2=> 8-bit
;//     <o.12>     BAT: Byte Access Type <0=> Byte-write
;//                                      <1=> Byte-select
;//     <e.5>      WSE: Enable Wait State Generation
;//       <o.2..4>   NWS: Number of Standard Wait States <1-8><#-1>
;//     </e>
;//     <o.9..11>  TDF: Data Float Output Time <0-7>
;//                <i> Number of Cycles Added after the Transfer
;//   </e>
EBI_CSR6_Val    EQU     0x60000000

;//   <e.13> Enable Chip Select 7 (CSR7)
;//     <o.20..31> BA: Base Address <0x0-0xFFF00000:0x100000><#/0x100000>
;//                <i> Start Address for Chip Select Signal
;//     <o.7..8>   PAGES: Page Size      <0=> 1M Byte    <1=> 4M Bytes
;//                                      <2=> 16M Bytes  <3=> 64M Bytes
;//                <i> Selects Active Bits in Base Address
;//     <o.0..1>   DBW: Data Bus Width   <1=> 16-bit     <2=> 8-bit
;//     <o.12>     BAT: Byte Access Type <0=> Byte-write
;//                                      <1=> Byte-select
;//     <e.5>      WSE: Enable Wait State Generation
;//       <o.2..4>   NWS: Number of Standard Wait States <1-8><#-1>
;//     </e>
;//     <o.9..11>  TDF: Data Float Output Time <0-7>
;//                <i> Number of Cycles Added after the Transfer
;//   </e>
EBI_CSR7_Val    EQU     0x70000000

;//   <q.4>        DRP: Data Read Protocol
;//                     <0=> Standard Read
;//                     <1=> Early Read
EBI_MCR_Val     EQU     0x00000010

;// </h> End of EBI


; Power Mangement Controller (PMC) definitions
PMC_BASE        EQU     0xFFFF4000      ; PMC Base Address 
PMC_CGMR        EQU     0x20            ; PMC_CGMR Offset 
PMC_SR	        EQU     0x30            ; PMC_SR Offset 
PMC_MCKOSS      EQU     (3<<4)          ; Master Clock Output Selection
PMC_MCKO        EQU     (1<<6)          ; Master Clock Output Disable
PMC_PLLS        EQU     (1<<3)          ; PLL Selection
PMC_CSS         EQU     (1<<7)          ; Clock Source Selection
PMC_PRES        EQU     (7<<0)          ; Prescaler Selection
PMC_MUL         EQU     (0x7FF<<8)      ; Phase Lock Loop Factor
PMC_PLLCOUNT    EQU     (0xFF<<24)      ; PLL Lock Counter
PMC_PLL_LOCK    EQU     (1<<0)          ; PLL Lock Status 

;// <e> AT91M42800A PMC Clock Setup
;//   <o1.7>      CSS: Clock Source Selection
;//               <0=> Slow Clock
;//               <1=> PLL Output
;//   <o1.3>      PLLS: PLL Selection
;//               <0=> PLL A (5 - 20MHz)
;//               <1=> PLL B (20 - 80MHz)
;//   <o1.0..2>   PRES: Prescaler
;//               <0=> None
;//               <1=> Clock / 2    <2=> Clock / 4
;//               <3=> Clock / 8    <4=> Clock / 16
;//               <5=> Clock / 32   <6=> Clock / 64
;//   <o1.8..18>  MUL: Phase Lock Loop Factor <0-2047>
;//               <i> PLL Output is multiplied by MUL+1
;//   <o1.24..31> PLLCOUNT: PLL Lock Counter <0x0-0xFF>
;//               <i> PLL Lock Timer
;//   <o1.4..5>   MCKOSS: Master Clock Output Source Selection
;//               <0=> Slow Clock
;//               <1=> Master Clock
;//               <2=> Master Clock Inverted
;//               <3=> Master Clock / 2
;//   <q1.6>      MCKODS: Master Clock Output Disable <0-1>
;// </e>
PMC_SETUP       EQU     0
PMC_CGMR_Val    EQU     0x1003FF98


; Advanced Power Mangement Controller (APMC) definitions
APMC_BASE       EQU     0xFFFF4000      ; APMC Base Address 
APMC_CGMR       EQU     0x20            ; APMC_CGMR Offset 
APMC_SR	        EQU     0x30            ; APMC_SR Offset 
APMC_MOSC_BYP   EQU     (1<<0)          ; Main Oscillator Bypass
APMC_MOSC_EN    EQU     (1<<1)          ; Main Oscillator Enable
APMC_MCKO_DIS   EQU     (1<<2)          ; Disable Master Clock Output
APMC_CSS        EQU     (3<<14)         ; Clock Source Selection
APMC_PRES       EQU     (7<<4)          ; Prescaler Selection
APMC_MUL        EQU     (0x3F<<8)       ; Phase Lock Loop Factor
APMC_OSCOUNT    EQU     (0xFF<<16)      ; Main Oscillator Counter
APMC_PLLCOUNT   EQU     (0x3F<<24)      ; PLL Lock Counter
APMC_MOSCS      EQU     (1<<0)          ; Main Osillator Status 
APMC_PLL_LOCK   EQU     (1<<1)          ; PLL Lock Status 

;// <e> AT91M55800A APMC Clock Setup
;//   <o1.14..15> CSS: Clock Source Selection
;//               <0=> Low-Frequency Clock
;//               <1=> Main Oscillator or External Clock
;//               <2=> Phase Lock Loop Output
;//   <o1.0>      MOSCBYP: Main Oscillator Bypass
;//               <0=> No: Crystal (XIN, XOUT)
;//               <1=> Yes: External Clock (XIN)
;//   <q1.1>      MOSCEN: Main Oscillator Enable <0-1>
;//               <i> Must be disabled in Bypass Mode
;//   <o1.4..6>   PRES: Prescaler
;//               <0=> None
;//               <1=> Clock / 2    <2=> Clock / 4
;//               <3=> Clock / 8    <4=> Clock / 16
;//               <5=> Clock / 32   <6=> Clock / 64
;//   <o1.8..13>  MUL: Phase Lock Loop Factor <0-63>
;//               <i> PLL Output is multiplied by MUL+1
;//   <o1.16..23> OSCOUNT: Main Oscillator Counter <0x0-0xFF>
;//               <i> Oscillator Startup Timer  
;//   <o1.24..29> PLLCOUNT: PLL Lock Counter <0x0-0x3F>
;//               <i> PLL Lock Timer
;//   <q1.2>      MCKODS: Master Clock Output Disable <0-1>
;// </e>
APMC_SETUP      EQU     0
APMC_CGMR_Val   EQU     0x032F8102


                PRESERVE8


; Area Definition and Entry Point
;  Startup Code must be linked first at Address at which it expects to run.

                AREA    RESET, CODE, READONLY
                ARM


; Exception Vectors (before Remap)
;  Mapped to Address 0 before Remap Command.
;  Relative addressing mode must be used.

Reset_Vec       B       Reset_Handler
Undef_Vec       B       Undef_Vec
SWI_Vec         B       SWI_Vec
PAbt_Vec        B       PAbt_Vec
DAbt_Vec        B       DAbt_Vec
                NOP
IRQ_Vec         B       IRQ_Vec
FIQ_Vec         B       FIQ_Vec


; Exception Vectors (after Remap)
;  Mapped to Address 0 after Remap Command.
;  Absolute addressing mode must be used.
;  Dummy Handlers are implemented as infinite loops which can be modified.

Vectors         LDR     PC, Reset_Addr         
                LDR     PC, Undef_Addr
                LDR     PC, SWI_Addr
                LDR     PC, PAbt_Addr
                LDR     PC, DAbt_Addr
                NOP                            ; Reserved Vector 
;               LDR     PC, IRQ_Addr
                LDR     PC, [PC, #-0xF20]      ; Vector from AIC_IVR 
;               LDR     PC, FIQ_Addr
                LDR     PC, [PC, #-0xF20]      ; Vector from AIC_FVR 

Reset_Addr      DCD     Soft_Reset
Undef_Addr      DCD     Undef_Handler
SWI_Addr        DCD     SWI_Handler
PAbt_Addr       DCD     PAbt_Handler
DAbt_Addr       DCD     DAbt_Handler
                DCD     0                      ; Reserved Address 
IRQ_Addr        DCD     IRQ_Handler
FIQ_Addr        DCD     FIQ_Handler

Soft_Reset      B       Soft_Reset
Undef_Handler   B       Undef_Handler
SWI_Handler     B       SWI_Handler
PAbt_Handler    B       PAbt_Handler
DAbt_Handler    B       DAbt_Handler
IRQ_Handler     B       IRQ_Handler
FIQ_Handler     B       FIQ_Handler


; Reset Handler

                EXPORT  Reset_Handler
Reset_Handler   

	IF      :DEF:__HW_INIT
; Setup PMC System Clock
                IF      PMC_SETUP <> 0
                LDR     R0, =PMC_BASE

;  Setup the PLL
                IF      (PMC_CGMR_Val:AND:PMC_MUL) <> 0
                LDR     R1, =(PMC_CGMR_Val:AND:(:NOT:PMC_CSS))
                STR     R1, [R0, #PMC_CGMR]

;  Wait until PLL stabilized
PLL_Loop        LDR     R2, [R0, #PMC_SR]
                ANDS    R2, R2, #PMC_PLL_LOCK
                BEQ     PLL_Loop
                ENDIF

;  Switch from Slow Clock to Selected Clock
                LDR     R1, =PMC_CGMR_Val
                STR     R1, [R0, #PMC_CGMR]

                ENDIF   ; PMC_SETUP


; Setup APMC System Clock
                IF      APMC_SETUP <> 0
                LDR     R0, =APMC_BASE

;  Enable Main Oscillator
                IF      (APMC_CGMR_Val:AND:APMC_MOSC_EN) <> 0
                LDR     R1, =(APMC_CGMR_Val:AND:(:NOT:(APMC_CSS:OR:APMC_MUL)))
                STR     R1, [R0, #APMC_CGMR]

;  Wait until Oscillator stabilized
MOSCS_Loop      LDR     R2, [R0, #APMC_SR]
                ANDS    R2, R2, #APMC_MOSCS
                BEQ     MOSCS_Loop
                ENDIF

;  Setup the PLL
                IF      (APMC_CGMR_Val:AND:APMC_MUL) <> 0
                LDR     R1, =(APMC_CGMR_Val:AND:(:NOT:APMC_CSS))
                STR     R1, [R0, #APMC_CGMR]

;  Wait until PLL stabilized
PLL_Loop        LDR     R2, [R0, #APMC_SR]
                ANDS    R2, R2, #APMC_PLL_LOCK
                BEQ     PLL_Loop
                ENDIF

;  Switch from Slow Clock to Selected Clock
                LDR     R1, =APMC_CGMR_Val
                STR     R1, [R0, #APMC_CGMR]

                ENDIF   ; APMC_SETUP


; Copy Exception Vectors to Internal RAM before Remap

                ADR     R8, Vectors
                IF      :DEF:REMAPPED
                MOV     R9, #RAM_Base
                ELSE
                MOV     R9, #RAM_Base_Boot
                ENDIF
                LDMIA   R8!, {R0-R7}           ; Load Vectors 
                STMIA   R9!, {R0-R7}           ; Store Vectors 
                LDMIA   R8!, {R0-R7}           ; Load Handler Addresses 
                STMIA   R9!, {R0-R7}           ; Store Handler Addresses 


; Initialise EBI and execute Remap

                LDR     R12, AfterRemapAdr     ; Get the Real Jump Address 
                ADR     R11, EBI_Table 
                LDMIA   R11, {R0-R10}          ; Load EBI Data 
                STMIA   R10, {R0-R9}           ; Store EBI Data with Remap 
                BX      R12                    ; Jump and flush Pipeline 

EBI_Table       DCD     EBI_CSR0_Val
                DCD     EBI_CSR1_Val
                DCD     EBI_CSR2_Val
                DCD     EBI_CSR3_Val
                DCD     EBI_CSR4_Val
                DCD     EBI_CSR5_Val
                DCD     EBI_CSR6_Val
                DCD     EBI_CSR7_Val
                DCD     0x00000001             ; Remap Command 
                DCD     EBI_MCR_Val
                DCD     EBI_BASE

AfterRemapAdr   DCD     AfterRemap

AfterRemap

		ENDIF	;	IF      :DEF:__HW_INIT
; Initialise Interrupt System
;  ...


; Setup Stack for each mode

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

;                IMPORT  init_serial
;                BL      init_serial
;                IMPORT  init_time
;                BL      init_time

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
