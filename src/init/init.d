module init;

@nogc nothrow @trusted void delay(size_t cycles)
{
    while(cycles) cycles--;
}

extern(C) @nogc nothrow @trusted void main()
{
    import gpio.gpio_arm;
    import uart.uart_rpi3;

    // Set GPIO16 to OUTPUT
    set_mode(16, GPIO_FSEL_MODE.OUT);
    set_mode(29, GPIO_FSEL_MODE.OUT);

    // uart_setup(9600);

    bool led = false;
    while (true)
    {
        // uart_put_byte('H');
        // uart_put_byte('I');
        // uart_put_byte(' ');
        // uart_put_byte('\r');

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

