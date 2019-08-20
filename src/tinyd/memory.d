module tinyd.memory;

bool is_hexchar(ubyte b) @nogc nothrow @safe 
{
    return ((b >= 'A' && b <= 'F') || (b >= 'a' && b <= 'f') || (b >= '0' && b <= '9'));
}

ubyte hex_nyb(ubyte b) @nogc nothrow @safe 
{
    if (b >= 'A' && b <= 'F')      return cast(ubyte) (b - 'A' + 0xA);
    else if (b >= 'a' && b <= 'f') return cast(ubyte) (b - 'a' + 0xA);
    else if (b >= '0' && b <= '9') return cast(ubyte) (b - '0');
    else return 0xFF; // This should never be reached
}

ubyte nyb_hex(ubyte b) @nogc nothrow @safe
{
    if (b >= 0x0 && b <= 0x9)      return cast(ubyte) (b + '0');
    else if (b >= 0xA && b <= 0xF) return cast(ubyte) (b - 0xA + 'a');
    else return 'X'; // This should never be reached
}

void print_32(uint* ptr, ubyte[] buffer) @nogc @trusted nothrow
{
    uint mem_word = *ptr;
    for (int i = 7; i >= 0; i--)
    {
        buffer[i] = nyb_hex(mem_word & 0xF);
        mem_word >>= 4;
    }
}

void print_64(ulong* ptr, ubyte[] buffer) @nogc @trusted nothrow
{
    ulong mem_word = *ptr;
    for (int i = 15; i >= 0; i--)
    {
        buffer[i] = nyb_hex(mem_word & 0xF);
        mem_word >>= 4;
    }
}

ulong* hex_to_address(in ubyte[] hex_addr) @nogc @trusted nothrow
{
    ulong addr = 0;
    for (int i = 0; i < 16; i++)
    {
        addr <<= 4;
        addr |= hex_nyb(hex_addr[i]);
    }
    return cast(ulong*) addr;
}

extern(C):

void* memcpy(const void* src, void* dst, size_t n) @nogc @trusted nothrow {
    return null;
}