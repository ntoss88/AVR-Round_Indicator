all:
	avr-gcc -c -Wall -mmcu=atmega48 -Wall -std=gnu99 -funsigned-char -funsigned-bitfields -ffunction-sections -fdata-sections -fshort-enums -MMD -MP -g -O2 -DTEST_CONDITION -I. -Iavr *.c
	avr-gcc -mmcu=atmega48 -Wl,--start-group -Wl,-lm  -Wl,--end-group -Wl,--gc-sections -g  -o test.elf *.o -Wl,-Map="test.map"
	avr-objcopy -O ihex -R .eeprom -R .fuse -R .lock -R .signature test.elf test.hex
	avr-size test.elf

clean:
	rm -rf *.o *.d *.map *.hex *.elf


