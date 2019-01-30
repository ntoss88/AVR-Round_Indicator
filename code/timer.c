#include "timer.h"

#include <stdbool.h>
#include <avr/io.h>
#include <avr/interrupt.h>

#include "macro_avr.h"

#define LED0_0 CLR_BIT(PORTB,1)
#define LED1_0 CLR_BIT(PORTB,0)
#define LED2_0 CLR_BIT(PORTD,7)
#define LED3_0 CLR_BIT(PORTD,6)
#define LED4_0 CLR_BIT(PORTD,5)
#define LED5_0 CLR_BIT(PORTB,7)
#define LED6_0 CLR_BIT(PORTB,6)
#define LED7_0 CLR_BIT(PORTD,4)
#define LED8_0 CLR_BIT(PORTD,3)
#define LED9_0 CLR_BIT(PORTD,2)

#define LED0_1 SET_BIT(PORTB,1)
#define LED1_1 SET_BIT(PORTB,0)
#define LED2_1 SET_BIT(PORTD,7)
#define LED3_1 SET_BIT(PORTD,6)
#define LED4_1 SET_BIT(PORTD,5)
#define LED5_1 SET_BIT(PORTB,7)
#define LED6_1 SET_BIT(PORTB,6)
#define LED7_1 SET_BIT(PORTD,4)
#define LED8_1 SET_BIT(PORTD,3)
#define LED9_1 SET_BIT(PORTD,2)

#define LEDL_0 CLR_BIT(PORTB,4)
#define LEDH_0 CLR_BIT(PORTB,5)
#define LEDL_1 SET_BIT(PORTB,4)
#define LEDH_1 SET_BIT(PORTB,5)

static uint8_t termo;
static bool blink;

//=====================================================================================================
// Setting the leds on
// val == 0 - least significant led is blinking
// val == [1 - 20] - switching leds on by the order
// val > 20 - overflow. most significant led is blinking, other leds are on

static void set_leds (uint8_t val)
{
    // all leds off
    LEDL_1;
    LEDH_1;
    LED0_0;
    LED1_0;
    LED2_0;
    LED3_0;
    LED4_0;
    LED5_0;
    LED6_0;
    LED7_0;
    LED8_0;
    LED9_0;
    // overflow check
    bool hi = false;
    if (val > 10)
    {
        val -= 10;
        hi = true;
    }
    // blinking
    if (val > 10)
    {
        if (blink)
            LED9_1;
        val = 9;
    }
    // setting leds
    switch (val)
    {
        case 10:
            LED9_1;
        case 9:
            LED8_1;
        case 8:
            LED7_1;
        case 7:
            LED6_1;
        case 6:
            LED5_1;
        case 5:
            LED4_1;
        case 4:
            LED3_1;
        case 3:
            LED2_1;
        case 2:
            LED1_1;
        case 1:
            LED0_1;
            break;
        case 0:
            if (blink)
                LED0_1;
            break;
        default:
            break;
    }
    // setting the group
    if (hi)
        LEDL_0;
    else
        LEDH_0;
}

//=====================================================================================================
// Timer 0 overflow interrupt

ISR (TIMER0_OVF_vect)
{
    static uint16_t div = 0;
    // Blink contol
    if (++ div >= (1024 * 8))
    {
        div = 0;
        blink = !blink;
    }
    // Dynamic indication
    // pwm duty = 1/8
    if ((div & 0x7) == 0)
        // set
        set_leds (termo);
    else
    {
        // off
        LEDL_1;
        LEDH_1;
        LED0_0;
        LED1_0;
        LED2_0;
        LED3_0;
        LED4_0;
        LED5_0;
        LED6_0;
        LED7_0;
        LED8_0;
        LED9_0;
    }
}

//=====================================================================================================
// Temperature setter

void set_termo (int16_t val)
{
    val += 8;
    val >>= 4;
    if (val <= 10)
        val = 0;
    else if (val > 30)
        val = 21;
    else
        val -= 10;
    termo = (uint8_t)val;
}

//=====================================================================================================
// Timer init

void timer_init ()
{
    // Timer 0 init
    // Clock 8MHz
    TCCR0A = 0;
    TCCR0B = 1; // 8000000/1024 = 7812.5 Hz
    TIMSK0 = 1;
}

//=====================================================================================================
//

