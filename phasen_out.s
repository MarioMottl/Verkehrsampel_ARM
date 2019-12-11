;			AREA IN_OUT_BIT, CODE, READONLY
			INCLUDE STM32_F103RB_MEM_MAP.INC

;
;   R0: Phase to Output
;

;   R1: Buffer to Compare and Output
;   R2: Address to Output

;LED0    EQU PERIPH_BB_BASE + (GPIOB_ODR - PERIPH_BASE) * 0x20 + 8  * 4
;LED1    EQU PERIPH_BB_BASE + (GPIOB_ODR - PERIPH_BASE) * 0x20 + 9  * 4
;LED2    EQU PERIPH_BB_BASE + (GPIOB_ODR - PERIPH_BASE) * 0x20 + 10 * 4
;LED3    EQU PERIPH_BB_BASE + (GPIOB_ODR - PERIPH_BASE) * 0x20 + 11 * 4
;LED4    EQU PERIPH_BB_BASE + (GPIOB_ODR - PERIPH_BASE) * 0x20 + 12 * 4
;LED5    EQU PERIPH_BB_BASE + (GPIOB_ODR - PERIPH_BASE) * 0x20 + 13 * 4
;LED6    EQU PERIPH_BB_BASE + (GPIOB_ODR - PERIPH_BASE) * 0x20 + 14 * 4
;LED7    EQU PERIPH_BB_BASE + (GPIOB_ODR - PERIPH_BASE) * 0x20 + 15 * 4

;AMPEL_MAIN_ROT      EQU LED7
;AMPEL_MAIN_GELB     EQU LED6
;AMPEL_MAIN_GRUEN    EQU LED5
;AMPEL_SIDE_ROT      EQU LED4
;AMPEL_SIDE_GELB     EQU LED3
;AMPEL_SIDE_GRUEN    EQU LED2

output_phase    PROC
                PUSH{R0-R2, LR}
                LDR R2, =GPIOB_ODR

phase0out       LDR R1, =0x00 ; PHASE 0 -> ROT - ROT
                CMP R0, R1
                BNE phase1out
                LDR R1, =0x9000 ; ROT - ROT
                STR R1, [R2]
                POP{R0-R2, PC}
                
phase1out       LDR R1, =0x01 ; PHASE 1 -> ROT/GELB - ROT
                CMP R0, R1
                BNE pase2out
                LDR R1, =0xD000 ; ROT/GELB - ROT
                STR R1, [R2]
                POP{R0-R2, PC}

phase2out       LDR R1, =0x02 ; PHASE 2 -> GRÜN - ROT
                CMP R0, R1
                BNE phase3out
                LDR R1, =0x3000 ; GRÜN - ROT
                STR R1, [R2]
                POP{R0-R2, PC}

phase3out       LDR R1, =0x03 ; PHASE 3 -> GRÜN BLINKEN - ROT
                CMP R0, R1
                BNE phase4out
                LDR R1, =0x3000 ; GRÜN - ROT
                STR R1, [R2]
                POP{R0-R2, PC}

phase4out       LDR R1, =0x04 ; PHASE 4 -> GELB - ROT
                CMP R0, R1
                BNE phase5out
                LDR R1, =0x5000 ; GELB - ROT
                STR R1, [R2]
                POP{R0-R2, PC}

phase5out       LDR R1, =0x05 ; PHASE 5 -> ROT - ROT
                CMP R0, R1
                BNE phase6out
                LDR R1, =0x9000 ; ROT - ROT
                STR R1, [R2]
                POP{R0-R2, PC}

phase6out       LDR R1, =0x06 ; PHASE 6 -> ROT - ROT/GELB
                CMP R0, R1
                BNE phase7out
                LDR R1, =0x9800 ; ROT - ROT/GELB
                STR R1, [R2]
                POP{R0-R2, PC}

phase7out       LDR R1, =0x07 ; PHASE 7 -> ROT - GRÜN
                CMP R0, R1
                BNE phase8out
                LDR R1, =0x8400 ; ROT - GRÜN
                STR R1, [R2]
                POP{R0-R2, PC}

phase8out       LDR R1, =0x08 ; PHASE 8 -> ROT - GRÜN BLINKEND
                CMP R0, R1
                BNE phase9out
                LDR R1, =0x8400 ; ROT - GRÜN
                STR R1, [R2]
                POP{R0-R2, PC}

phase9out       LDR R1, 0x09 ; PHASE 9 -> ROT - GELB
                CMP R0, R1
                BNE phase0out
                LDR R1, =0x8400 ; ROT - GELB
                STR R1, [R2]
                POP{R0-R2, PC}

phase_not_out   LDR R1, =0x0000 ; OUTPUT NOTHING
                STR R1, [R2]
                POP{R0-R2, PC}

                POP{R0-R2, PC}
                ENDP
                END
