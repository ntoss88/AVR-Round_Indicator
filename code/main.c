#include <stdint.h>
#include <avr/io.h>
#include <avr/interrupt.h>

#include "macro_avr.h"
#include "ds18b20.h"
#include "timer.h"

//=====================================================================================================
// Program starts here

int main ()
{
    // Ports init
    DDRB = 0xF3;
    PORTB = 0xC3;
    PORTC = 0x00;
    DDRC = 0x00;
    DDRD = 0xfc;
    PORTD = 0xfc;

    // Timer 0 init
    timer_init ();

    // Global interrupts enabling
    SEI;

    // Main cycle
    while (1)
    {
        // Conversion takes ~750 ms
        start_conv ();
        _delay_ms (800);
        // Setting leds
        set_termo ((int16_t)read_conv ());
        _delay_ms (4200);
    }
}

//=====================================================================================================
//
