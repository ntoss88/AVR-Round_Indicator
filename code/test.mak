# Конфигурация подпроекта
# Название проекта
APPS += test

# Описание проекта
DESC.test = Тестовый проект на stm32

# Какие файлы должны быть сгенерированы
RESULT.test = test.elf test.hex test.lss test.bin

# Поиск исходников
SRC.test = $(wildcard apps/test/*.c apps/test/*.S apps/test/$(TARGET)/*.c apps/test/$(TARGET)/*.S)

# Поиск заголовочных файлов
CFLAGS.test += -Iapps/test -Iapps/test/$(TARGET)

ifeq ($(TARGET),stm32)
# Скрипт линковки
LDSCRIPT.test = apps/test/stm32/stm32.ld
endif

ifeq ($(TARGET),stm32)
# Не использовать стандартную библиотеку
LDFLAGS.test = -nostdlib
endif

# Добавление библиотек к проекту
LIBS.test = 

# Добавление условной компиляции
CFLAGS+=-DTEST_CONDITION
