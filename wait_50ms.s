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