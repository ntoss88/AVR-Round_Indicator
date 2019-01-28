.include "m48adef.inc"
.include "macro.inc"
.include "ports.inc"
.include "config.inc"

.equ	Task_QueueSize	=	10	;Length of task queue
.equ	Timers_PoolSize	=	5	;Amount of timers
.equ	Timers_Discrete	=	10	;Дискретность службы таймеров, мс

.def	BlinkLED	=	R15	;Status of blinking LED

.dseg
Task_Queue:	.byte	Task_QueueSize
Timers_Pool: .byte	Timers_PoolSize * 3
Meas1:		.byte	1		;Measured value on channel 1
Meas2:		.byte	1		;Measured value on channel 2
Display1:	.byte	1		;Value to be displayed on A column
Display2:	.byte	1		;Value to be displayed on B column
.ifdef Peak1
DPeak1:		.byte	1		;Peak value on scale 1
.endif
.ifdef Peak2
DPeak2:		.byte	1		;Peak value on scale 2
.endif

.cseg
.org 0
RJMP	Reset

.org OC0Aaddr
RJMP	SysTimer_Interrupt

.org ADCCaddr
RJMP	ADC_Interrupt

.org	INT_VECTORS_SIZE
Descpition:
.include "Descript.inc"
Reset:
	//Flush RAM
	LDI		ZL, Low (SRAM_START)
	LDI		ZH, High(SRAM_START)
	LDI		R16, 0
	LDI		XL, Low (RAMEnd)
	LDI		XH, High(RAMEnd)
Reset_Flush_RAM:
	ST		Z+, R16
	CP		ZL, XL
	CP		ZH, XH
	BRLO	Reset_Flush_RAM

	//Setup Timer 0
	//Prescaler 64, interrupt each 10ms
	LDI		R16, (XTAL/64) / (1000 / Timers_Discrete)
	OUT		OCR0A, R16
	LDI		R16, 1<<WGM01 | 0<<WGM00
	OUT		TCCR0A, R16
	LDI		R16, 0<<WGM02 | 0<<CS02 | 1<<CS01 | 1<<CS00
	OUT		TCCR0B, R16

	LDI		R16, 1<<OCIE0A
	STS		TIMSK0, R16
	//Clear task queue
	LDI		R16, Task_QueueSize
	LDI		R17, $FF
	LDI		ZL, Low (Task_Queue)
	LDI		ZH, High(Task_Queue)
Reset_ClearQueue:
	ST		Z+, R17
	DEC		R16
	BRNE	Reset_ClearQueue
	//Clear timers pool
	LDI		ZL, Low (Timers_Pool)
	LDI		ZH, High(Timers_Pool)
	LDI		R16, 0
	MOV		R0, R16
	LDI		R16, Timers_PoolSize
Reset_ClearTimers:
	ST		Z+, R17
	ST		Z+, R0
	ST		Z+, R0
	DEC		R16
	BRNE	Reset_ClearTimers

	//Setup ADC converter
	LDI		R16, 0
	STS		ADCSRB, R16
	LDI		R16, Ref11<<REFS1 | Ref10<<REFS0 | Left_Align<<ADLAR | 0
	STS		ADMUX, R16
	LDI		R16, 1<<ADEN | 1<<ADPS2 | 1<<ADPS1 | 0<<ADPS0 | 1<<ADIE | 1<<ADATE | 1<<ADSC
	STS		ADCSRA, R16

	//Set up ports
	LDI		R16,	$F3
	OUT		DDRB,	R16
	LDI		R16,	$30
	OUT		PORTB,	R16
	LDI		R16,	$FC
	OUT		DDRD,	R16
	LDI		R16,	$00
	OUT		PORTD,	R16
	OUT		DDRC,	R16
	//Disable input buffer for ADC inputs used
	LDI		R16,	1 << ADC1D | 1 << ADC0D
	STS		DIDR0,	R16

	SEI

	AddTimer 2, 10
.ifdef	Blink
	AddTimer 4, 150
.else
	LDI		R16, 0
	MOV		BlinkLED, R16
.endif
.ifdef	Peak1
	AddTimer	6, Peak1_Time
.endif
.ifdef	Peak2
	AddTimer	7, Peak2_Time
.endif
	RJMP	Main

Main:
	//Process task queue:
	//Take first task from queue, if any
	LDS		R16, Task_Queue
	CPI		R16, $FF
	BREQ	Process_Task_Queue_Done
	//If any task enqueued...
	LDI		R18, Task_QueueSize-1
	LDI		ZL, Low (Task_Queue)
	LDI		ZH, High(Task_Queue)
Advance_Queue_Loop:
	LDD		R17,Z+1
	ST		Z+, R17
	DEC		R18
	BRNE	Advance_Queue_Loop
	LDI		R17, $FF
	ST		Z, R17
	//Get address in ROM and give control
	LDI		R17, 0
	LDI		ZL, Low (Task_Table)
	LDI		ZH, High(Task_Table)
	ADD		ZL, R16
	ADC		ZH, R17
	LSL		ZL
	ROL		ZH
	LPM		R16, Z+
	LPM		R17, Z
	MOV		ZL, R16
	MOV		ZH, R17
	ICALL
	//After task routine terminates control will return here
Process_Task_Queue_Done:
	RJMP	Main


.include "Task_Table.inc"

Idle:
	RET

.include "LED_Lighting.asm"
.include "Metering.asm"
.include "Math.asm"

.include "System_Task_Handlers.asm"
.include "System_Timer_Service.asm"
