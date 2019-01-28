Show_Scale:	;[02]
//Toggle screen and light it
	;Keep current column
	IN		R18, PORTB
	;Shut all LEDs
	LDI		R16, $30
	OUT		PORTB, R16
	LDI		R16, $00
	OUT		PORTD, R16
	SBRC	R18, 4		;
	RJMP	Show_Scale_Show_B
Show_Scale_Show_A:
	;Get value of column A
	LDS		R16, Display1
	CPI		R16, 10 + 1
	BRLO	PC+2
	LDI		R16, 10
.ifdef Scale1_Bar
	LDI		ZL, Low (LED_Table1)
	LDI		ZH, High(LED_Table1)
.else
	LDI		ZL, Low (LED_Table2)
	LDI		ZH, High(LED_Table2)
.endif
	ADD		ZL, R16
	ADC		ZH, R0
	LSL		ZL
	ROL		ZH
	LPM		R16, Z+
	LPM		R17, Z
	ORI		R17, 1 << 4	;Light up A, fade down B
.ifdef Peak1
	LDI		ZL, Low (LED_Table2)
	LDI		ZH, High(LED_Table2)
	LDS		R18, DPeak1
	ADD		ZL, R18
	ADC		ZH, R0
	LSL		ZL
	ROL		ZH
	LPM		R18, Z+
	LPM		R19, Z
	OR		R16, R18
	OR		R17, R19
.endif
	OUT		PORTB, R17
	OUT		PORTD, R16
	RJMP	Show_Scale_Show_End
Show_Scale_Show_B:
	;Get value of column B
	LDS		R16, Display2
	CPI		R16, 10 + 1
	BRLO	PC+2
	LDI		R16, 10
.ifdef Scale2_Bar
	LDI		ZL, Low (LED_Table1)
	LDI		ZH, High(LED_Table1)
.else
	LDI		ZL, Low (LED_Table2)
	LDI		ZH, High(LED_Table2)
.endif
	ADD		ZL, R16
	ADC		ZH, R0
	LSL		ZL
	ROL		ZH
	LPM		R16, Z+
	LPM		R17, Z
	ORI		R17, 1 << 5	;Light up A, fade down B
.ifdef Peak2
	LDI		ZL, Low (LED_Table2)
	LDI		ZH, High(LED_Table2)
	LDS		R18, DPeak2
	ADD		ZL, R18
	ADC		ZH, R0
	LSL		ZL
	ROL		ZH
	LPM		R18, Z+
	LPM		R19, Z
	OR		R16, R18
	OR		R17, R19
.endif
	OUT		PORTB, R17
	OUT		PORTD, R16
Show_Scale_Show_End:
	AddTimer 2, 10
	RET

LED_Table1:
.dw		$0000		;0  ..........
.dw		$0200		;1  *.........
.dw		$0300		;2  **........
.dw		$0380		;3  ***.......
.dw		$03C0		;4  ****......
.dw		$03E0		;5  *****.....
.dw		$83E0		;6  ******....
.dw		$C3E0		;7  *******...
.dw		$C3F0		;8  ********..
.dw		$C3F8		;9  *********.
.dw		$C3FC		;10 **********

LED_Table2:
.dw		$0000		;0  ..........
.dw		$0200		;1  *.........
.dw		$0100		;2  .*........
.dw		$0080		;3  ..*.......
.dw		$0040		;4  ...*......
.dw		$0020		;5  ....*.....
.dw		$8000		;6  .....*....
.dw		$4000		;7  ......*...
.dw		$0010		;8  .......*..
.dw		$0008		;9  ........*.
.dw		$0004		;10 .........*

BlinkOn:	;[04] Включить мигающий светодиод
	LDI		R16, 1
	MOV		BlinkLED, R16
	AddTimer	5,	250
	RET

BlinkOff:	;[05] Выключить мигающий светодиод
	LDI		R16, 0
	MOV		BlinkLED, R16
	AddTimer	4,	150
	RET
