
enum byte* UART_BASE = cast(byte*)0x3f215000;
enum byte* UART_ENABLES = cast(byte*)(cast(ulong)UART_BASE + cast(ulong)0x04);
enum byte* UART_IO      = cast(byte*)(cast(ulong)UART_BASE + cast(ulong)0x40);
enum byte* UART_LCR     = cast(byte*)(cast(ulong)UART_BASE + cast(ulong)0x4c);
enum byte* UART_LSR     = cast(byte*)(cast(ulong)UART_BASE + cast(ulong)0x54);
enum byte* UART_CNTL    = cast(byte*)(cast(ulong)UART_BASE + cast(ulong)0x60);
enum byte* UART_BAUD    = cast(byte*)(cast(ulong)UART_BASE + cast(ulong)0x68);

enum uint CLOCK_FREQ = 249753600;
enum uint OVERSAMPLE_RATE = 8;

enum UART_LSR_MASK : uint
{
    TX_IDLE = 0x40,
    TX_EMPTY = 0x20,
    RX_OVERRUN = 0x02,
    DATA_READY = 0x01,
}

@nogc nothrow @safe uint baud_reg_value(uint baudrate)
{
    return (CLOCK_FREQ / (OVERSAMPLE_RATE * baudrate)) - 1;
}

@nogc nothrow @trusted void uart_setup(uint baudrate)
{
    import gpio.gpio_arm;
    ulong gpio_pud_disable_mask;

    // Select uart1 function on GPIO 14 and 15
    set_mode(14, GPIO_FSEL_MODE.ALT5);
    set_mode(15, GPIO_FSEL_MODE.ALT5);

    // Enable uart
    *cast(uint*)UART_ENABLES |= 1; //TODO make more explicit
    // Disable Tx and Rx
    *cast(uint*)UART_CNTL = 0;
    // 8-bit mode
    *cast(uint*)UART_LCR |= 1; //TODO more explicit
    // Set baudrate
    *cast(uint*)UART_BAUD = baud_reg_value(baudrate);

    // Disable pull-up/pull-down for GPIOs 14 and 15
    gpio_pud_disable_mask = (1 << 14) | (1 << 15);
    disable_pull_up_down(gpio_pud_disable_mask);
    
    // Enable Tx and Rx
    *cast(uint*)UART_CNTL = 3;
}

@nogc nothrow @trusted void uart_put_byte(byte b)
{
    // Wait until there is space in the buffer
    while(!(*UART_LSR & UART_LSR_MASK.TX_EMPTY)) {}
    *cast(uint*)UART_IO = cast(uint)b; // Only works little endian
    // (we are assigning the LSbyte of the IO register)
}

