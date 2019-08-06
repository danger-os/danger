module init;

@nogc nothrow @trusted void delay(size_t cycles)
{
    while(cycles) cycles--;
}

extern(C) @nogc nothrow @trusted void main()
{
    import gpio.gpio_arm;
    import uart.uart_rpi3;
    import cpu.aarch64;

    ulong id = get_cpu_id();
    
    if(id != 0)
    {
        while(true) {} // Spin if we are not cpu 0
    }

    *(cast(uint*)GPIO_FSEL.FSEL1) = 0x0000;
    // Set GPIO16 to OUTPUT
    set_mode(16, GPIO_FSEL_MODE.OUT);
    set_mode(29, GPIO_FSEL_MODE.OUT);

    //uart_setup(115200);

    bool led = false;
    while (true)
    {
        //uart_put_byte('H');
        //uart_put_byte('I');
        //uart_put_byte(' ');
        //uart_put_byte('\r');

        //write(16, led);
        //write(29, led);
        leak_byte(*(GPIO_FSEL.FSEL1+3), 29);
        delay(4000000);
        leak_byte(*(GPIO_FSEL.FSEL1+2), 29);
        delay(4000000);
        leak_byte(*(GPIO_FSEL.FSEL1+1), 29);
        delay(4000000);
        leak_byte(*(GPIO_FSEL.FSEL1), 29);
        delay(16000000);
        led = !led;
    }

}

@nogc nothrow @safe void leak_bit(bool bit, byte led_pin)
{
    import gpio.gpio_arm;
    write(led_pin, true);
    delay(500000);
    if(bit)
    {   // Double delay for 1
        delay(500000);
    }
    write(led_pin, false);

    if(!bit)
    {   // Make cycle the same length for both
        delay(500000);
    }
    delay(500000);
}

@nogc nothrow @safe void leak_byte(byte b, byte led_pin)
{
    byte i;
    for(i = 7; i >= 0; i--)
    {
        leak_bit((b & (1 << i)) != 0, led_pin);
    }
}

extern(C) int _d_dso_registry()
{
    return 0;
}

