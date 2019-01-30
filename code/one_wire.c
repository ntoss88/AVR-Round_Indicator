#include "one_wire.h"

//=====================================================================================================
// Send 1-wire reset
// Returns true if the device acked

bool one_wire_reset ()
{
    SET_BIT (one_wire_ddr, one_wire_bit);
    _delay_us (300); // из-за прерываний импульс удлинняется. поэтому специально укоротим, было 500
    CLR_BIT (one_wire_ddr, one_wire_bit);
    _delay_us (40);  // из-за прерываний импульс удлинняется. поэтому специально укоротим, было 70
    bool res = one_wire_pin & (1 << one_wire_bit) ? false : true;
    _delay_us (500);
    return res;
}

//=====================================================================================================
// Send a bit

static void one_wire_send_bit (bool bit)
{
    CLI;
    SET_BIT (one_wire_ddr, one_wire_bit);
    _delay_us (7);
    if (!bit)
        _delay_us (63);
    CLR_BIT (one_wire_ddr, one_wire_bit);
    SEI;
    _delay_us (250);
}

//=====================================================================================================
// Send a byte

void one_wire_send_byte (uint8_t b)
{
    for (uint8_t i = 8; i > 0; i--)
    {
        one_wire_send_bit (b & 1);
        b >>= 1;
    }
}

//=====================================================================================================
// Receive a bit

static bool one_wire_get_bit ()
{
    CLI;
    SET_BIT (one_wire_ddr, one_wire_bit);
    _delay_us (7);
    CLR_BIT (one_wire_ddr, one_wire_bit);
    _delay_us (7);
    bool bit = one_wire_pin & (1 << one_wire_bit) ? true : false;
    SEI;
    _delay_us (250);
    return bit;
}

//=====================================================================================================
// Receive a byte

uint8_t one_wire_get_byte ()
{
    uint8_t b = 0;
    for (uint8_t i = 8; i > 0; i--)
    {
        b >>= 1;
        b |= one_wire_get_bit () ? 0x80 : 0;
    }
    return b;
}

//=====================================================================================================
//
