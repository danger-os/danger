module vm.aarch64;

enum uint NSTABLE = 63;
enum uint APTABLE = 61;
enum uint XNTABLE = 60;
enum uint PXNTABLE = 59;

struct table_desc
{
    import tinyd.bitmanip;
    ulong _storage;

    enum ubyte X_OFFSET = 1;
    enum ubyte X_LENGTH = 1;
    @property void x(ulong x) @nogc nothrow @safe {
        bitfield_set(&_storage, X_OFFSET, X_LENGTH, x);
    }
    @property ulong x() @nogc nothrow @safe {
        return bitfield_get(&_storage, X_OFFSET, X_LENGTH);
    }
}

void init(table_desc d)
{
    return;
}