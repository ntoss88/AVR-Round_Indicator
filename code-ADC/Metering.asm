ADC_Interrupt:
	PUSH	R16
	IN		R16, SREG
	PUSH	R16
	PUSH	R17
	PUSH	R18

	;Store value measured
	LDS		R17, ADCH
	;Which channel did we measure?
	LDS		R16, ADMUX
	ANDI	R16, $0F
	CPI		R16, 01
	BREQ	ADC_Interrupt_Channel2
ADC_Interrupt_Channel1:
	LDI		R16, Ref21<<REFS1 | Ref20<<REFS0 | Left_Align<<ADLAR | 1
	STS		ADMUX, R16
.ifdef Delay_Dcrg1
	LDS		R18, Meas2
	CP		R17, R18
	BRSH	ADC_Interrupt_Channel1_STS
	SUBI	R18, DecRate
	BRSH	ADC_Interrupt_Channel1_PreSTS
	LDI		R18, 0
ADC_Interrupt_Channel1_PreSTS:
	MOV		R17, R18
ADC_Interrupt_Channel1_STS:
.endif
	STS		Meas2, R17
	RJMP	ADC_Interrupt_Done
ADC_Interrupt_Channel2:
	LDI		R16, Ref11<<REFS1 | Ref10<<REFS0 | Left_Align<<ADLAR | 0
	STS		ADMUX, R16
.ifdef Delay_Dcrg2
	LDS		R18, Meas1
	CP		R17, R18
	BRSH	ADC_Interrupt_Channel2_STS
	SUBI	R18, DecRate
	BRSH	ADC_Interrupt_Channel2_PreSTS
	LDI		R18, 0
ADC_Interrupt_Channel2_PreSTS:
	MOV		R17, R18
ADC_Interrupt_Channel2_STS:
.endif
	STS		Meas1, R17
ADC_Interrupt_Done:
	AddTask 3
	POP		R18
	POP		R17
	POP		R16
	OUT		SREG, R16
	POP		R16
	RETI


ConvDone: ;[03]
//This task is called when an ADC convertion is completed
	;---- Channel 1
	LDS		R16, Meas1
.if Scale1Min > 0
	CPI		R16, Scale1Min+1
	BRSH	Scale1_1
	LDI		R16, 0
	ADD		R16, BlinkLED
	RJMP	Scale1_3
Scale1_1:
.endif
.if Scale1Max < 255
	CPI		R16, Scale1Max+1
	BRLO	Scale1_2
	LDI		R16, 10
.ifdef Scale1_Bar
	SUB		R16, BlinkLED
.else
	TST		BlinkLED
	BREQ	PC+2
	LDI		R16, 0
.endif
	RJMP	Scale1_3
Scale1_2:
.endif
	LDI		R17, Scale1Min
	SUB		R16, R17
	BRSH	PC + 2
	LDI		R16, 0
	LDI		R17, (Scale1Max - Scale1Min) / 10
	RCALL	Divide_8bit
Scale1_3:
	STS		Display1, R16
.ifdef Peak1
.ifdef Blink
	SUB		R16, BlinkLED
	BRLO	Scale1_Peak_1
.endif
	LDS		R17, DPeak1
	CP		R16, R17
	BRLO	Scale1_Peak_1
	STS		DPeak1, R16
Scale1_Peak_1:
.endif

	;---- Channel 2
	LDS		R16, Meas2
.if Scale2Min > 0
	CPI		R16, Scale2Min+1
	BRSH	Scale2_1
	LDI		R16, 0
	ADD		R16, BlinkLED
	RJMP	Scale2_3
Scale2_1:
.endif
.if Scale2Max < 255
	CPI		R16, Scale2Max
	BRLO	Scale2_2
	LDI		R16, 10
.ifdef Scale2_Bar
	SUB		R16, BlinkLED
.else
	TST		BlinkLED
	BREQ	PC+2
	LDI		R16, 0
.endif
	RJMP	Scale2_3
Scale2_2:
.endif
	LDI		R17, Scale2Min
	SUB		R16, R17
	BRSH	PC + 2
	LDI		R16, 0
	LDI		R17, (Scale2Max - Scale2Min) / 10
	RCALL	Divide_8bit
Scale2_3:
	STS		Display2, R16
.ifdef Peak2
.ifdef Blink
	SUB		R16, BlinkLED
	BRLO	Scale2_Peak_1
.endif
	LDS		R17, DPeak2
	CP		R16, R17
	BRLO	Scale2_Peak_1
	STS		DPeak2, R16
Scale2_Peak_1:
.endif
	RET

DecPeak1:	;[06] Decrease peak value on scale 1
.ifdef Peak1
	LDS		R16, DPeak1
	CPI		R16, 0+1
	BRLO	DecPeak1_1
	DEC		R16
	STS		DPeak1, R16
DecPeak1_1:
	AddTimer	6, Peak1_Time
.endif
	RET

DecPeak2:	;[07] Decrease peak value on scale 2
.ifdef Peak2
	LDS		R16, DPeak2
	CPI		R16, 0+1
	BRLO	DecPeak2_1
	DEC		R16
	STS		DPeak2, R16
DecPeak2_1:
	AddTimer	7, Peak2_Time
.endif
	RET
