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

    uart_put("HI THERE\r\n");

    ubyte buffer[64];

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
        uart_put("> ");
        
        ulong bytes_read = uart_get_echo_line(buffer);

        uint n = 0;
        for (n = 0; n < buffer.length; n++)
        {
            if (buffer[n] == ' ' ||
                buffer[n] == '\n' ||
                buffer[n] == '\r')
            {
                break;
            }
        }

        char[] cmd = cast(char[]) buffer[0..n];
        switch (cmd) {
            case "dump":
                // Dump mem location
                ubyte[16] hex_addr;
                for (i = 0; i < 16 && is_hexchar(buffer[i + 5]); i++)
                {
                    hex_addr[i] = buffer[i + 5];
                }
                if (i < 16)
                {
                    // Error
                    uart_put_byte('E');
                }
                else
                {
                    import tinyd.memory;
                    uint* address = cast(uint*) hex_to_address(hex_addr);
                    ubyte[16] hex_buffer;
                    address.print_32(hex_buffer);
                    uart_put(hex_buffer);
                }
                break;
            case "test":
                import vm.aarch64;
                table_entry desc;
                desc._storage = 0;
                desc.nstable = 1;

                import tinyd.memory;
                ulong* address = cast(ulong*) &desc;
                ubyte[16] hex_buffer;
                address.print_64(hex_buffer);
                uart_put(hex_buffer);
            break;
            case "elvl":
                import tinyd.memory;
                ulong elvl = get_exception_level();
                ubyte[16] e_level_hex;
                (&elvl).print_64(e_level_hex);
                uart_put(e_level_hex);
            break;
            case "cpun":
                import tinyd.memory;
                ulong cpun = get_cpu_id();
                ubyte[16] cpu_num_hex;
                (&cpun).print_64(cpu_num_hex);
                uart_put(cpu_num_hex);
            break;
            default:
                uart_put_byte('E');
            break;
        }

        // Newline before prompt
        uart_put("\r\n");
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

