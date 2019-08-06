module gpio_arm;

enum byte* GPIO_BASE = cast(byte*)0x3f200000;
enum byte* GPIO_PUD = cast(byte*)(cast(ulong)GPIO_BASE + cast(ulong)0x94);

enum GPIO_FSEL : byte*
{
    FSEL0 = cast(byte*)(cast(ulong)GPIO_BASE + cast(ulong)0x00),
    FSEL1 = cast(byte*)(cast(ulong)GPIO_BASE + cast(ulong)0x04),
    FSEL2 = cast(byte*)(cast(ulong)GPIO_BASE + cast(ulong)0x08),
    FSEL3 = cast(byte*)(cast(ulong)GPIO_BASE + cast(ulong)0x0c),
    FSEL4 = cast(byte*)(cast(ulong)GPIO_BASE + cast(ulong)0x10),
    FSEL5 = cast(byte*)(cast(ulong)GPIO_BASE + cast(ulong)0x14),
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

enum GPIO_PUD_CLK : byte*
{
    CLK0 = cast(byte*)(cast(ulong)GPIO_BASE + cast(ulong)0x98),
    CLK1 = cast(byte*)(cast(ulong)GPIO_BASE + cast(ulong)0x9c),
}

enum GPIO_PUD_CLK_DELAY = 150;

@nogc nothrow @trusted void disable_pull_up_down(ulong gpio_mask)
{
    
    uint i;
    *cast(uint*)GPIO_PUD = 0;
    for(i = 0; i < GPIO_PUD_CLK_DELAY; i++) {} // Delay
    // mask bottom 32 bits for clk 0
    *cast(uint*)GPIO_PUD_CLK.CLK0 = gpio_mask & 0xffffffff;
    // mask bottom 22 bits of top half for clk 1
    *cast(uint*)GPIO_PUD_CLK.CLK1 = (gpio_mask >> 32) & 0x3fffff;
    for(i = 0; i < GPIO_PUD_CLK_DELAY; i++) {} // Delay
    *cast(uint*)GPIO_PUD_CLK.CLK0 = 0;
    *cast(uint*)GPIO_PUD_CLK.CLK1 = 0;
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
    fn_sel_reg &= (~mask);
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


