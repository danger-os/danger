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
    
    if(id == 1)
    {        
        bool led = false;

        // Set GPIO16 to OUTPUT
        set_mode(16, GPIO_FSEL_MODE.OUT);
        set_mode(29, GPIO_FSEL_MODE.OUT);

        while (true)
        {
            write(16, led);
            write(29, led);
            delay(2000000);

            led = !led;
        }
    }

    if(id != 0)
    {
        while(true) {} // Spin if we are not cpu 0
    }

    uart_setup(9600);


    uart_put_byte('H');
    uart_put_byte('I');
    uart_put_byte(' ');
    uart_put_byte('T');
    uart_put_byte('H');
    uart_put_byte('E'); 
    uart_put_byte('R');
    uart_put_byte('E');
    uart_put_byte('\r');
    uart_put_byte('\n');

    ubyte buffer[64];
    ubyte hex_addr[16];
    ubyte hex_wd[8];

    int i;
    ubyte c;

    @nogc nothrow @safe bool is_hexchar(ubyte b)
    {
        return ((b >= 'A' && b <= 'F') || (b >= 'a' && b <= 'f') || (b >= '0' && b <= '9'));
    }

    @nogc nothrow @safe ubyte hex_nyb(ubyte b)
    {
        if(b >= 'A' && b <= 'F') return cast(ubyte)(b - 'A' + 0xa);
        else if(b >= 'a' && b <= 'f') return cast(ubyte)(b - 'a' + 0xa);
        else if(b >= '0' && b <= '9') return cast(ubyte)(b - '0');
        else return 0xff; // This should never be reached
    }

    @nogc nothrow @safe ubyte nyb_hex(ubyte b)
    {
        if(b >= 0x0 && b <= 0x9) return cast(ubyte)(b + '0');
        else if(b >= 0xa && b <= 0xf) return cast(ubyte)(b - 0xa + 'a');
        else return 'X'; // This should never be reached
    }

    while (true)
    {
        c = 'A';
        uart_put_byte('>');
        uart_put_byte(' ');

        for(i = 0; i < 32 && c != '\r' && c != '\n'; i++)
        {
            c = uart_get_byte();
            if (c == '\r' || c == '\n') {
                uart_put_byte('\r');
                uart_put_byte('\n');
            } else {
                uart_put_byte(c);
                buffer[i] = c;
            }
        }
        if(buffer[0] == 'd' &&
           buffer[1] == 'u' &&
           buffer[2] == 'm' &&
           buffer[3] == 'p' &&
           buffer[4] == ' ')
        {
            // Dump mem location
            for(i = 0; i < 16 && is_hexchar(buffer[i + 5]); i++)
            {
                hex_addr[i] = buffer[i + 5];
            }
            if(i < 16)
            {
                // Error
                uart_put_byte('E');
            }
            else
            {
                ulong addr = 0;
                uint mem_word = 0xffffffff;
                for(i = 0; i < 16; i++)
                {
                    addr <<= 4;
                    addr |= hex_nyb(hex_addr[i]);
                }
                mem_word = *(cast(uint*)addr);
                for(i = 7; i >= 0; i--)
                {
                    hex_wd[i] = nyb_hex(mem_word & 0xf);
                    mem_word >>= 4;
                }
                for(i = 0; i < 8; i++)
                {
                    uart_put_byte(hex_wd[i]);
                }
            }
        }

        // Newline before prompt
        uart_put_byte('\r');
        uart_put_byte('\n');
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

