module tinyd.array;

import tinyd.memory;

extern(C):

void[] _d_arraycopy(size_t size, void[] from, void[] to) @nogc @trusted nothrow
{
    memcpy(to.ptr, from.ptr, to.length * size);
    return to;
}