Divide_8bit:
;Divides one 8-bit unsigned number by another
;Input:		R16	- divident
;			R17 - divider
;Output:	R16 - quotient
;			R17	- remainder
	PUSH	R18		;Save registers
	PUSH	R19
	PUSH	R20
	LDI		R18, 0	;Here will be part of divident
	LDI		R19, 0	;Here will be result
	LDI		R20, 8	;Cycle counter
Divide_8bit_Loop:
	LSL		R16		;Get bit from divident
	ROL		R18		;Put bit to temp register

	CP		R18, R17
	BRSH	PC+3
	LSL		R19
	RJMP	Divide_8bit_1
	SEC
	ROL		R19
	SUB		R18, R17

Divide_8bit_1:
	DEC		R20
	BRNE	Divide_8bit_Loop

	MOV		R16, R19
	MOV		R17, R18

	POP		R20		;Return registers
	POP		R19
	POP		R18
	RET


Divide_16_8bit:
;Divides 16-bit unsigned number by 8-bit
;Input:		XL:XH - divident
;			R17 - divider
;Output:	XL:XH - quotient
;			R17	- remainder
	PUSH	R16		;Save registers
	PUSH	R18
	PUSH	R19
	PUSH	R20
	PUSH	R21
	LDI		R18, 0	;Here will be part of divident (lower byte)
	LDI		R16, 0	;Here will be part of divident (higher byte)
	LDI		R19, 0	;Here will be result (lover byte)
	LDI		R21, 0	;Here will be result (higher byte)
	LDI		R20, 16	;Cycle counter
Divide_16_8bit_Loop:
	LSL		XL		;Get highest bit from divident
	ROL		XH
	ROL		R18		;Put bit to temporary register (lower byte)
	ROL		R16		;(higher byte)

	CP		R18, R17
	CPC		R16, R0	;R0 always keeps ZERO value
	BRSH	PC+4
	LSL		R19
	ROL		R21
	RJMP	Divide_16_8bit_1
	SEC
	ROL		R19
	ROL		R21
	SUB		R18, R17
	SBC		R16, R0

Divide_16_8bit_1:
	DEC		R20
	BRNE	Divide_16_8bit_Loop

	MOV		XL,  R19
	MOV		XH,  R21
	MOV		R17, R18

	POP		R21		;Return registers
	POP		R20
	POP		R19
	POP		R18
	POP		R16
	RET
