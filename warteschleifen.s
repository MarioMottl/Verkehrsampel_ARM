;******************************************************************************
;*            U N T E R P R O G R A M M:    wait_500ms                        *
;*                                                                            *
;* Aufgabe:   Wartet 500ms                                                    *
;* Input:                                                                     *
;* return:	 	                                                              *
;******************************************************************************
				EXPORT wait_500ms
wait_500ms		PROC
				push 	{R0-R2,LR}	   ; save link register to Stack
                MOV     R0,#0x1F4	  ;/1000 ; wait 500ms
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
				
;******************************************************************************
;*            U N T E R P R O G R A M M:    wait_5s	                          *
;*                                                                            *
;* Aufgabe:   Wartet 5s		                                                  *
;* Input:     none                                                            *
;* return:	  none	                                                          *
;******************************************************************************
				EXPORT wait_5s
wait_5s			PROC
				push 	{R0-R2,LR}	   ; save link register to Stack
                MOV     R0,#0x1388	   ; wait R0 * 1ms -> 5000ms
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