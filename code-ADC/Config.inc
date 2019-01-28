;[CPU]
.equ	XTAL	=	1000000		;Fcpu, Hz

;[ADC Common]
.equ	Left_Align	=	1	;Always align to left? (1 - yes)

;Comment following lines to disable features
.equ	Blink 		=	1	;Blink if measured out of range
.equ	Peak1		=	1	;Peak meter on scale 1
.equ	Peak2		=	1	;Peak meter on scale 2
.equ	Delay_Dcrg1	=	1	;Ch.1 - Delay when lower
.equ	Delay_Dcrg2	=	1	;Ch.2 - Delay when lower

;[ADC Measurement]
.equ	Ref10		=	1	;REFS0	Always 1
.equ	Ref20		=	1	;REFS0	Always 1
.equ	Ref11		=	0	;REFS1	0 for Aref 5 V / 1 for 1.1V
.equ	Ref21		=	0	;REFS1	0 for Aref 5 V / 1 for 1.1V
.equ	DecRate		=	1	;Decrease rate if Delay applies

;[Scale values] 0...255
.equ	Scale1Min	=	150
.equ	Scale1Max	=	205
.equ	Scale2Min	=	0
.equ	Scale2Max	=	255
.equ	Peak1_Time	=	50	;Peak1 Decrease timeout, ms
.equ	Peak2_Time	=	150	;Peak1 Decrease timeout, ms

;[Scale format] Comment to toggle to Point mode
.equ	Scale1_Bar	=	1
.equ	Scale2_Bar	=	1


.if Scale1Max < Scale1Min
.error	"Scale 1 Max < Min!"
.endif
.if Scale2Max < Scale2Min
.error	"Scale 2 Max < Min!"
.endif
