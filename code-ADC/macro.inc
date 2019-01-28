.macro	AddTask		; AddTask <index>
	LDI		R16, @0
	RCALL	Add_Task
.endm

.macro	AddTimer	; AddTimer <index>, <time>
	LDI		R16, @0
	LDI		XL, Low((@1 / Timers_Discrete)  - 1)
	LDI		XH, High((@1 / Timers_Discrete) - 1)
	RCALL	Add_Timer
.endm
