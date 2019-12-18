;*************************************************************************
;* U N T E R P R O G R A M M: waitvar *
;* *
;* Aufgabe: Lese Schalter ein und warte *
;* Input: keine *
;* return: keine *
;*************************************************************************
				EXPORT waitvar
waitvar			PROC;
				PUSH {R0,R1,LR}
				LDR R0,=GPIOA_IDR
				AND 
				POP {R0,R1,PC}
                ENDP