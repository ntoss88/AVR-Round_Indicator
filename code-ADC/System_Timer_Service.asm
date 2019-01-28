SysTimer_Interrupt:
	PUSH	R16
	IN		R16, SREG
	PUSH	R16
	AddTask 1
	POP		R16
	OUT		SREG, R16
	POP		R16
	RETI

Process_Timers:
	LDI		ZL, Low (Timers_Pool)
	LDI		ZH, High(Timers_Pool)
	LDI		R17, Timers_PoolSize
Process_Timers_Loop:
	LD		R18, Z		//Task index
	LDD		XL,  Z+1	//Timer  (lower byte)
	LDD		XH,  Z+2	//Timer (higher byte)
	CPI		R18, $FF
	BREQ	Process_Timers_EndLoop
	CPI		XL, 0
	CPC		XH, R0
	BREQ	Process_Timers_SetTask
	SBIW	X, 1
	STD		Z+1, XL
	STD		Z+2, XH
	RJMP	Process_Timers_EndLoop
Process_Timers_SetTask:
	MOV		R16, R18
	RCALL	Add_Task
	LDI		R18, $FF
	ST		Z, R18
Process_Timers_EndLoop:
	ADIW	Z, 3
	DEC		R17
	BRNE	Process_Timers_Loop
	RET
