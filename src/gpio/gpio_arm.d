module gpio_arm;

enum byte* GPIO_BASE = cast(byte*) 0x3f200000;

enum GPIO_FSEL : byte*
{
    FSEL0 = GPIO_BASE + 0x00,
    FSEL1 = GPIO_BASE + 0x04,
    FSEL2 = GPIO_BASE + 0x08,
    FSEL3 = GPIO_BASE + 0x0c,
    FSEL4 = GPIO_BASE + 0x10,
    FSEL5 = GPIO_BASE + 0x14,
}

enum GPIO_FSEL_MODE : byte
{
    INP = 0b000,
    OUT = 0b001,
    ALT0 = 0b100,
    ALT1 = 0b101,
    ALT2 = 0b110,
    ALT3 = 0b111,
    ALT4 = 0b011,
    ALT5 = 0b010,
}

@nogc nothrow @trusted void set_mode(byte pin, byte mode)
{
    byte q = pin / 10;
    byte r = pin % 10;

    // register (function select) n
    byte* reg_add;
    reg_add = cast(byte*) GPIO_FSEL.FSEL0 + 4 * q;
    int fn_sel_reg = *(cast(int*)reg_add);

    // set the (three) bits corresponding to pin
    int mask = (7 << (3 * r));
    fn_sel_reg &= (!mask);
    fn_sel_reg |= ((7 & mode) << 3 * r);

    // write to register
    *(cast(int*)reg_add) = fn_sel_reg;
}

@nogc nothrow @trusted void write(byte pin, byte value)
{
    byte q = pin / 32;
    byte r = pin % 32;

    value = (value == 1);

    int* reg_add;
    reg_add = cast(int*) (GPIO_BASE + 0x1C + (4 * q) + (!value * 12));
    *reg_add = (1 << r);
}

