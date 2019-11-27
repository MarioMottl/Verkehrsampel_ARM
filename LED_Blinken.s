;******************************************************************************
;* C) Copyright HTL - HOLLABRUNN  2009-2013 All rights reserved. AUSTRIA      * 
;*                                                                            * 
;* File Name:   LED_BLINKEN.s                                                 *
;* Autor: 		Josef Reisinger                                               *
;* Version: 	V1.00                                                         *
;* Date: 		01/10/2013                                                    *
;* Description: Blinken propgramm für LED0                                    *
;******************************************************************************
;* History: 	01.10.2013: REJ                                               *
;*  		 	creation V1.00	            			                      *
;******************************************************************************
				AREA BLINKEN, CODE, READONLY
				INCLUDE STM32_F103RB_MEM_MAP.INC
				EXPORT __main

;******************************************************************************
;*                        M A I N  P r o g r a m m:                           *
;******************************************************************************
__main			PROC
				BL   	init_port
				LDR 	R1,=GPIOB_ODR	; LEDs auf Portleitung PB8 - PB15
_main_again		LDR		R0,[R1]
                EOR     R0,R0,#0x100                  
				STR		R0,[R1]
				BL  	wait_500ms	   ; Warte 500ms
				B		_main_again
				ENDP

;******************************************************************************
;*            U N T E R P R O G R A M M:    init_ports                        *
;*                                                                            *
;* Aufgabe:   Initialisiert Portleitungen für LED der Schalterplatine         *
;* Input:     keine                                                           *
;* return:	  keine                                                           *
;******************************************************************************
init_port		PROC
				push {R0,R1,R2,LR}	   ; save link register to Stack

				MOV	R2, #0x8	 ; enable clock for GPIOB	(APB2 Peripheral clock enable register)
				LDR R1,	=RCC_APB2ENR
				LDR	R0, [R1]
				ORR	R0,	R0, R2
				STR R0, [R1]

				LDR R1,	=GPIOB_CRH	 ; set Port Pins PB8 (LED0) to Push Pull Output Mode (50MHz)
				LDR	R0, [R1]
				LDR	R2, =0xFFFFFFF0	 
				AND	R0,	R0, R2
				MOV	R2, #0x03     
				ORR	R0,	R0, R2
				STR R0, [R1]

				POP {R0,R1,R2,PC}	   ;restore link register to Programm Counter and return
				ENDP

;******************************************************************************
;*            U N T E R P R O G R A M M:    wait_500ms                        *
;*                                                                            *
;* Aufgabe:   Wartet 500ms                                                    *
;* Input:                                                                     *
;* return:	 	                                                              *
;******************************************************************************
wait_500ms		PROC
				push 	{R0-R2,LR}	   ; save link register to Stack
                MOV     R0,#0x1F4	   ; wait 500ms
                MOV     R1,#0
wait_ms_loop	MOV  	R2,#0x63B			
wait_ms_loop1	SUB 	R2,R2,#1
				CMP		R2,R1
				BNE		wait_ms_loop1
				SUB 	R0,R0,#1
				CMP		R0,R1
				BNE		wait_ms_loop
				POP 	{R0-R2,PC}	   ;restore link register to Programm Counter and return
                ENDP

				END




