Add_Task:
//Put a task into queue
//Input:  R16 - task index
//Output: R16 = $00 if success
//        R16 = $FF if queue full
	Push	ZL
	Push	ZH
	Push	R17
	Push	R18
	LDI		ZL, Low (Task_Queue)
	LDI		ZH, High(Task_Queue)
    LDI		R17, Task_QueueSize

Add_TaskLoop:
	LD		R18, Z+
	CPI		R18, $FF
	BREQ	Add_Task_Add
	DEC		R17
	BRNE	Add_TaskLoop
Add_Task_Full:
	LDI		R16, $FF
	RJMP	Add_Task_Done
Add_Task_Add:
    ST		-Z, R16
	LDI		R16, $00
Add_Task_Done:
	POP		R18
	POP		R17
	POP		ZH
	POP		ZL
	RET


Add_Timer:
//Put a task into timers pool
//Input:  R16   - task index
//		  XL:XH - time (in milliseconds)
//Output: R16 = $00 if success
//        R16 = $FF if queue full
	PUSH ZL
	PUSH ZH
	PUSH R17
	PUSH R18


	LDI		R17, Timers_PoolSize
	LDI		ZL, Low (Timers_Pool)
	LDI		ZH, High(Timers_Pool)
Add_Timer_Find_Loop:
	LD		R18, Z
	CP		R18, R16
	BREQ	Add_Timer_Refresh
	DEC		R17
	BRNE	Add_Timer_Find_Loop	

	LDI		R17, Timers_PoolSize
	LDI		ZL, Low (Timers_Pool)
	LDI		ZH, High(Timers_Pool)
Add_Timer_Loop:
	LD		R18, Z
	CPI		R18, $FF
	BREQ	Add_Timer_Add
	ADIW	Z,3
	DEC		R17
	BRNE	Add_Timer_Loop
	LDI	R16, $FF
	RJMP	Add_Timer_End
Add_Timer_Add:
	ST		Z, R16
Add_Timer_Refresh:
	STD		Z+1, XL
	STD		Z+2, XH
	LDI		R16, $00
Add_Timer_End:
	POP	R18
	POP	R17
	POP	ZH
	POP	ZL
	RET
