;
; @author:  Mottlö
; @version: 2019-12-04
;
;
				
				
				AREA BLINKEN, CODE, READONLY
				INCLUDE STM32_F103RB_MEM_MAP.INC

				INCLUDE ./uart.s
                INCLUDE ./wait_50ms.s
                INCLUDE ./init_ports.s
                INCLUDE ./bitbanding.s

				EXPORT __main
welcome_msg	        DCB "\rWelcome \r\n Verkehrsampel.s\r\n",0
status_msg 		    DCB "\rStatus\r\n",0
status_msg_time     DCB "\rTime: \r\n",0
status_msg_day      DCB "\rTag : 1\r\n Nacht : 0\r\n",0
status_msg_night    DCB "\rNacht : 1\r\nTag : 0\r\n",0
debug_msg           DCB "\rDEBUG\r\n",0

__main      ;B __reset
            
            BL init_ports
            MOV R0, #9600 ;Baudrate
            BL uart_init

            LDR R0, =welcome_msg
            BL uart_put_string

            
__reset ;CODE
            BL wait_50ms
            LDR R0, =debug_msg
            BL uart_put_string
            B __reset
            END
