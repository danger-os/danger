module gpio_arm;

__gshared byte* GPIO_BASE = cast(byte*) 0x3f200000;

@nogc nothrow @trusted void set_mode(byte pin, byte mode)
{
    byte q = pin / 10;
    byte r = pin % 10;

    // register (function select) n
    byte* reg_add;
    reg_add = cast(byte*) GPIO_BASE + 4 * q;
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