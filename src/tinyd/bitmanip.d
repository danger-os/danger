module tinyd.bitmanip;

ulong bitfield_mask(ubyte offset, ubyte width) @nogc @trusted nothrow
{
    return ((1UL << width) - 1UL) << offset;
}

ulong bitfield_get(ulong* src, ubyte offset, ubyte width) @nogc @trusted nothrow
{
    ulong mask = bitfield_mask(offset, width);
    ulong temp = *src & mask;
    return temp >>> offset;
}

void bitfield_set(ulong* dst, ubyte offset, ubyte width, ulong value) @nogc @trusted nothrow
{
    ulong mask = bitfield_mask(offset, width);
    ulong temp = *dst & (~mask);
    *dst = temp | ((value << offset) & mask);
}

void bitfield_plop(ulong* dst, ubyte offset, ubyte width, ulong value) @nogc @trusted nothrow
{
    ulong mask = bitfield_mask(offset, width);
    ulong temp = *dst & (~mask);
    *dst = temp | (value & mask);
}

ulong bitfield_crop(ulong* src, ubyte offset, ubyte width) @nogc @trusted nothrow
{
    ulong mask = bitfield_mask(offset, width);
    ulong temp = *src & mask;
    return temp;
}

