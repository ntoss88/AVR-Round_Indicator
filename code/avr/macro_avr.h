#pragma once

#define F_CPU 8000000
#include <util/delay.h>

#define SEI sei()
#define CLI cli()

#define SET_BIT(reg,bit)            \
(__extension__({                            \
    __asm__                                 \
    (                                       \
        "SBI %0, %1"   "\n\t"               \
        : : "I" (_SFR_IO_ADDR(reg)), "I" (bit) \
    );                                      \
}))

#define CLR_BIT(reg,bit)            \
(__extension__({                            \
    __asm__                                 \
    (                                       \
        "CBI %0, %1"   "\n\t"               \
        : : "I" (_SFR_IO_ADDR(reg)), "I" (bit) \
    );                                      \
}))


union __aliasing_through
{
    uint16_t u16;
    uint32_t u32;
    uint64_t u64;
}
#ifdef __GNUC__
  __attribute__((may_alias))
#endif
;

typedef union __aliasing_through __aliasing_through_t;

/// Получить little-endian uint32 из массива data со смещением ofs байт.
#define GET_LE32(data,ofs)	((__aliasing_through_t *)((char *)(data) + (ofs)))->u32
/// Записать little-endian uint32 в массива data по смещению ofs байт.
#define PUT_LE32(data,ofs,x)	(((__aliasing_through_t *)((char *)(data) + (ofs)))->u32 = (x))
/// Получить little-endian uint16 из массива data со смещением ofs байт.
#define GET_LE16(data,ofs)	((__aliasing_through_t *)((char *)(data) + (ofs)))->u16
/// Записать little-endian uint32 в массива data по смещению ofs байт.
#define PUT_LE16(data,ofs,x)	(((__aliasing_through_t *)((char *)(data) + (ofs)))->u16 = (x))

/// Длина статического массива в элементах
#define ARRAY_LEN(arr)		((sizeof (arr)) / (sizeof ((arr) [0])))
/// Размер элемента сатического массива в байтах
#define ITEM_SIZE(arr)		(sizeof ((arr) [0]))

