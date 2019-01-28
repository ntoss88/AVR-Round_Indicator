Task_Table:
.dW Idle				;00 - Idle mode routine
.dW	Process_Timers		;01 - System timers service
.dW	Show_Scale			;02	- Высветить очередной стоблец (таймер)
.dW	ConvDone			;03 - Завершено преобразование АЦП
.dW	BlinkOn				;04 - Включить мигающий светодиод
.dW	BlinkOff			;05 - Выключить мигающий светодиод
.dW	DecPeak1			;06 - Уменьшить пиковый детектор 1
.dW	DecPeak2			;07 - Уменьшить пиковый детектор 2
