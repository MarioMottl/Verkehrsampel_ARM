;*************************************************************************
;*C)Copyright HTL-HOLLABRUNN 2009-2011 All rights reserved. AUSTRIA *
;* *
;*FileName:IN_OUT.s *
;* Autor:Josef Reisinger *
;* Version: V1.00 *
;* Date:06/10/2012 *
;*Description:In/Out Propgramm using Bit Banding *
;*************************************************************************
;* History: 12.11.2011: REJ *
;* creation V1.00 *
;*************************************************************************

			AREA IN_OUT_BIT, CODE, READONLY
			INCLUDE STM32_F103RB_MEM_MAP.INC
			EXPORT __main
__main 		BL init_ports
_main_again LDR R0,=GPIOA_IDR
			LDR R0,[R0] ; Load PAO-PA15 (Schalter = PA0-PA7)
			LDR R1,=GPIOB_ODR ;
			LDR R2,[R1] ;
			BFI R2,R0,#8,#8 ; Bitrichtige Ausgabe (S0 auf LED0,…)
			LDR R3, =0xFFFFFFFF
			EOR R2,R3
			STR R2,[R1] ; Ausgabe auf LED`s (PB8-PB15)
			B _main_again

;*************************************************************************
;* U N T E R P R O G R A M M: init_ports *
;* *
;* Aufgabe: Initialisiert Portleitungen für LED / Schalterplatine *
;* Input: keine *
;* return: keine *
;*************************************************************************
init_ports 	push {R0,R1,R2,LR} ; save link register to Stack
			LDR R2,=0x4 ; enable clock for GPIOA
			LDR R1,=RCC_APB2ENR ; in APB2 Peripheral clock enable
			LDR R0,[R1] ; Register
			ORR R0,R0,R2
			STR R0,[R1]
			LDR R1,=GPIOA_CRL ; set Port Pins PA0-PA7 to Pull Up/Down
			LDR R0,=0x88888888 ; Schalter S0-S7
			STR R0,[R1]
			LDR R1,=GPIOA_ODR ; GPIOA Output Register auf "1" sodass
			LDR R0,=0xFFFFFFFF ; Input Pull Up aktiviert ist!!
			STR R0, [R1]
			LDR R2,=0x8 ; enable clock for GPIOB
			LDR R1,=RCC_APB2ENR ; (APB2 Peripheral clock enable
			LDR R0,[R1] ; register)
			ORR R0,R0,R2
			STR R0, [R1]
			LDR R1,=GPIOB_CRH ; set Port Pins PB8-PB15 to Push Pull
			LDR R0, =0x33333333 ; Output Mode(50MHz)-LED0-LED7
			STR R0, [R1]
			POP {R0,R1,R2,PC} ;restore link register to PC
			END