#pragma once

#include <stdbool.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#include "macro_avr.h"

#define one_wire_port PORTC
#define one_wire_bit  1
#define one_wire_ddr  DDRC
#define one_wire_pin  PINC

bool one_wire_reset (void);
void one_wire_send_byte (uint8_t b);
uint8_t one_wire_get_byte (void);
