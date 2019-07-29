module init;

@nogc nothrow @trusted void delay(size_t cycles)
{
    while(cycles) cycles--;
}

extern(C) @nogc nothrow @trusted void main()
{
    import gpio.gpio_arm;

    // Set GPIO16 to OUTPUT
    set_mode(16, GPIO_FSEL_MODE.OUT);
    set_mode(29, GPIO_FSEL_MODE.OUT);

    bool led = false;
    while (true)
    {
        write(16, led);
        write(29, led);
        delay(500000);
        led = !led;
    }

}



extern(C) int _d_dso_registry()
{
    return 0;
}

