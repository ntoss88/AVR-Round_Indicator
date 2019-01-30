#include "ds18b20.h"

#include "one_wire.h"

//=====================================================================================================
// Start a temperature conversion

void start_conv ()
{
    if (one_wire_reset ())
    {
        one_wire_send_byte (0xCC);
        one_wire_send_byte (0x44);
    }
}

//=====================================================================================================
// Read a temperature conversion

uint16_t read_conv ()
{
    uint16_t res = 0;
    if (one_wire_reset ())
    {
        one_wire_send_byte (0xCC);
        one_wire_send_byte (0xBE);
        res = one_wire_get_byte ();
        res += ((uint16_t)one_wire_get_byte ()) << 8;
    }
    return res;
}

//=====================================================================================================
//


