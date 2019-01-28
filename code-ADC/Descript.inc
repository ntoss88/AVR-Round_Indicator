;1.   XTAL Freq (10 - 1 MHz, 200 - 20 MHz, etc)
;2.   Scales info: bits 7-4 for scale 1, 3-0 for scale 2:
;      7,3  |  6,2  |  5,1  |  4,0
;       |       |       |       |
;       |       |       |       +--- Reserved for future uses
;       |       |       +----------- 1: Blink; 0: None
;       |       +------------------- 1: Peak hold; 0: None
;       +--------------------------- 1: Bar mode; 0: Point mode
;3,4. Scale1 Max, Min
;5,6. Scale2 Max, Min
;7.8  Input1, Input2:
;	  Bit7: 1: ADC, 0 - None
;		For ADC:
;			Bit6:	REFS 1
;			Bite5:	REFS 0




.set	Info1	=	0;
.ifdef Scale1_Bar
.set	Info1	=	Info1 | 1<<7
.endif
.ifdef Scale2_Bar
.set	Info1	=	Info1 | 1<<3
.endif
.ifdef Peak1
.set	Info1	=	Info1 | 1<<6
.endif
.ifdef Peak2
.set	Info1	=	Info1 | 1<<2
.endif
.ifdef Blink
.set	Info1	=	Info1 | 1<<5 | 1<<1
.endif
.set	Info2	=	0
.set	Info2	=	REF11 << 14 | REF10 << 13 | REF21 << 6 | REF20 << 5


.dW	(XTAL/100000)<<8 | Info1
.dW	Scale1Max<<8 | Scale1Min
.dW	Scale2Max<<8 | Scale2Min
.dW	Info2
