module tinyd.bitmanip;

ulong bitfield_mask(ubyte offset, ubyte width) @nogc @trusted nothrow
{
    return ((1UL << width) - 1UL) << offset;
}

void bitfield_set(ulong* dst, ubyte offset, ubyte width, ulong value) @nogc @trusted nothrow
{
    ulong mask = bitfield_mask(offset, width);
    ulong temp = *dst & (~mask);
    *dst = temp | ((value << offset) & mask);
}

ulong bitfield_get(ulong* src, ubyte offset, ubyte width) @nogc @trusted nothrow
{
    ulong mask = bitfield_mask(offset, width);
    ulong temp = *src & mask;
    return temp >>> offset;
}