;*************************************************************************
;*C)Copyright HTL-HOLLABRUNN 2009-2011 All rights reserved. AUSTRIA *
;* *
;*FileName:Verkehrsampel.s *
;* Autor:Clemens Pruggmayer, Mario Mottl *
;* Version: V1.00 *
;* Date:06/10/2012 *
;*Description: Verkehrsampel mit einstellbarer Zeit und darüber hinaus Tag&Nacht Betrieb*
;*************************************************************************
;* History: test*
;* creation V1.00 *
;*************************************************************************

welcome_msg	        DCB "Welcome \r\n Verkehrsampel.s \r\n Version 0.1",0
status_msg 		    DCB "Status\r\n",0
status_msg_time     DCB "Time: ",0
status_msg_day      DCB "Tag : 1\r\n Nacht : 0",0
status_msg_night    DCB "Nacht : 1\r\nTag : 0",0


			AREA IN_OUT_BIT, CODE, READONLY
			INCLUDE STM32_F103RB_MEM_MAP.INC
			EXPORT __main
__main      BL init_ports
            MOV R0, #9600 ;Baudrate
            BL uart_init
            LDR R0, =welcome_msg
            BL uart_put_string
            
__reset ;CODE
            B __reset

;*************************************************************************
;* U N T E R P R O G R A M M: LightState *
;* *
;* Aufgabe: Große State machine für Ampelmöglichkeiten *
;* Input: keine *
;* return: keine *
;*************************************************************************

day_entry	PUSH {LR, R0} ; R0 sichern
			B phase0
night_entry	PUSH {LR, R0} ; R0 sicher
			B phase2

phase0		; Ausgeben
			LDR R0, =1	; 0.5sec ROT -> ROT/GELB
			BL wait_500ms
phase1		; Ausgeben
			; Equals Night?
			CBEQ {},phase2ret
			LDR R0, =4	; 2 sec ROT/GELB -> GRÜN
			BL wait_500ms
phase2		; Ausgeben
			BL waitvar	; GRÜN -> GRÜN_Blinkend variabel
phase3		; Ausgeben
			;				GRÜN BLINKEN
phase4		; Ausgeben
			LDR R0, =4	; 2sec GELB -> ROT
phase5		; Ausgeben
phase6		; Ausgeben
phase7		; Ausgeben
phase8		; Ausgeben
phase9		; Ausgeben

phase2ret	; Ausgeben
			POP {PC, R0}
			END
phase9ret	; Ausgeben
			POP {PC, R0}
			END

;******************************************************************************
;*            U N T E R P R O G R A M M:    wait_50ms                        *
;*                                                                            *
;* Aufgabe:   Wartet 50ms                                                    *
;* Input:                                                                     *
;* return:	 	                                                              *
;******************************************************************************
wait_50ms		PROC
				push 	{R0-R2,LR}	   ; save link register to Stack
                MOV     R0,#0x32	   ; wait 50ms
                MOV     R1,#0
wait_ms_loop	MOV		R2,#0x63B			
wait_ms_loop1	SUB 	R2,R2,#1
				CMP		R2,R1
				BNE		wait_ms_loop1
				SUB 	R0,R0,#1
				CMP		R0,R1
				BNE		wait_ms_loop
				POP 	{R0-R2,PC}	   ;restore link register to Programm Counter and return
				ENDP
				ALIGN
				END

;*************************************************************************
;* U N T E R P R O G R A M M: waitvar *
;* *
;* Aufgabe: Lese Schalter ein und warte *
;* Input: keine *
;* return: keine *
;*************************************************************************

waitvar			PROC;
				PUSH {R0,R1,LR}
				LDR R0,=GPIOA_IDR
				AND 
				POP {R0,R1,PC}
				END

;*************************************************************************
;* U N T E R P R O G R A M M: init_ports *
;* *
;* Aufgabe: Initialisiert Portleitungen für LED / Schalterplatine *
;* Input: keine *
;* return: keine *
;*************************************************************************
init_ports  push {R1,R0} ; save link register to Stack
            ;Start of definition of all Switches
            LDR R1,=GPIOA_CRL ; set Port Pins PA0-PA7 to Pull Up/Down
			LDR R0,=0x88888888 ; Schalter S0-S7
			STR R0,[R1]
            ;End of Switch definition
            LDR R1,=GPIOB_CRH ; set Port Pins PB8-PB15 to Push Pull
            ;Start of LED definition
			LDR R0, =0x33333300 ; Output Mode(50MHz)-LED0-LED7
			STR R0, [R1]
            ;End of LED definition
            POP {R1,R0} ;restore link register to PC
			END


;******************************************************************************
;*            U N T E R P R O G R A M M:    uart_init                         *
;*                                                                            *
;* Aufgabe:   Initialisiert USART1                                            *
;* Input:     R0....Baudrate                                                  *
;* return:	 	                                                              *
;******************************************************************************
uart_init			PROC
					LDR      R1,=RCC_APB2ENR		  ; GPIOA mit einem Takt versorgen 
					LDR		 R1,[R1]
					ORR      R1,R1,#0x4
					LDR      R2,=RCC_APB2ENR
					STR      R1,[R2]
    
					LDR      R1,=GPIOA_CRH  ; loesche PA.9 (TXD-Leitung) configuration-bits  
					LDR		 R1,[R1]
					BIC      R1,R1,#0xF0
					LDR      R2,=GPIOA_CRH
					STR      R1,[R2]

					MOV      R1,R2	   ; TX (PA9) - alt. out push-pull 
					LDR      R1,=GPIOA_CRH
					LDR		 R1,[R1]
					ORR      R1,R1,#0xB0
					STR      R1,[R2]

					MOV      R1,R2		;loesche PA.10 (RXD-Leitung) configuration-bits  
					LDR      R1,=GPIOA_CRH
					LDR		 R1,[R1]
					BIC      R1,R1,#0xF00
					STR      R1,[R2]

					MOV      R1,R2		; Rx (PA10) - inut floating 
					LDR      R1,=GPIOA_CRH
					LDR		 R1,[R1]
					ORR      r1,r1,#0x400
					STR      R1,[R2]

					LDR      R1,=RCC_APB2ENR    ; USART1 mit einem Takt versrogen 
					LDR		 R1,[R1]
					ORR      r1,r1,#0x4000
					LDR      R2,=RCC_APB2ENR
					STR      R1,[R2]

					LDR      R1,=baudrate_const  ; Baudrate f�r USART festlegen  
					LDR	 	 R1,[R1]
					UDIV     r1,r1,r0
					LDR      R2,=USART1_BRR
					STRH     R1,[R2]

					LDR      R1,=USART1_CR1		   ; aktiviere RX, TX 
					LDR      R1,[R1]
					ORR      R1,R1,#0x0C		   ; USART_CR1_RE = 1, (= Receiver Enable Bit)
					LDR      R2,=USART1_CR1		   ; USART_CR1_TE = 1, (= Transmitter Enable Bit) 
					STR      R1,[R2]

					LDR      R1,=USART1_CR1		   ; aktiviere USART 
					LDR      R1,[R1]
					ORR      R1,R1,#0x2000		   ; USART_CR1_UE = 1  (= UART Enable Bit)
					LDR      R2,=USART1_CR1
					STR      R1,[R2]
					BX       LR
                    ENDP
					
baudrate_const		DCD		8000000


;******************************************************************************
;*            U N T E R P R O G R A M M:    uart_put_char                     *
;*                                                                            *
;* Aufgabe:   Ausgabe eines Zeichens auf USART1                               *
;* Input:     R0....Zeichen                                                   *
;* return:	 	                                                              *
;******************************************************************************
uart_put_char	   PROC
				   LDR      R1,=USART1_SR		 ;Data Transmit Register leer? 
				   LDR      R1,[R1]
				   TST      R1,#0x80	 ; USART_SR_TXE = 1 (Last data already transferred ?)
				   BEQ		uart_put_char
				   LDR      R1,=USART1_DR
				   STR      r0,[r1]
				   BX       LR
				   ENDP

;******************************************************************************
;*            U N T E R P R O G R A M M:    uart_put_string                   *
;*                                                                            *
;* Aufgabe:   Ausgabe einer Zeichenkette (C Konvention) USART1                *
;* Input:     R0....Zeiger auf Sting                                          *
;* return:	                        	                                      *
;******************************************************************************
uart_put_string		PROC
					PUSH     {lr}
					MOV      r2,r0				 ; R2 = Anfangsadresse von String
					B        _check_eos
_next_char			LDRB     r0,[r2],#0x01
					BL       uart_put_char
_check_eos			LDRB     r0,[r2,#0x00]
					CMP      r0,#0x00	       ; '\0' Zeichen ? 
					BNE      _next_char
					POP      {PC}
					ENDP
					ALIGN

				END