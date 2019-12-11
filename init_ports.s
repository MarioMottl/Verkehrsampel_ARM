;*************************************************************************
;* U N T E R P R O G R A M M: init_ports *
;* *
;* Aufgabe: Initialisiert Portleitungen für LED / Schalterplatine *
;* Input: keine *
;* return: keine *
;*************************************************************************

init_ports  push {R1,R0, LR} ; save link register to Stack
            ;Start of definition of all Switches
            LDR R1,=GPIOA_CRL ; set Port Pins PA0-PA7 to Pull Up/Down
			LDR R0,=0x88888888 ; Schalter S0-S7
			STR R0,[R1]
            ;End of Switch definition
            LDR R1,=GPIOB_CRH ; set Port Pins PB8-PB15 to Push Pull
            ;Start of LED definition
			LDR R0, =0x33333333 ; Output Mode(50MHz)-LED0-LED7
			STR R0, [R1]
            ;End of LED definition
            POP {R1,R0, PC} ;restore link register to PC

            END
