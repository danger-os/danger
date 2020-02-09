module vm.aarch64;

import tinyd.bitmanip;

alias ptr_t = ulong;

struct table_entry
{
    import tinyd.bitmanip;
    ulong _storage;

    enum DESC_OFFSET : ubyte
    {
        NSTABLE  = 63,
        APTABLE  = 61,
        XNTABLE  = 60,
        PXNTABLE = 59,
        UXN = 54,
        PXN = 53,
        CONTIGUOUS = 52,
        DIRTYBITMODIFIER = 51,
        NONGLOBAL = 11,
        ACCESSED = 10,
        SHAREABILITY = 8,
        ACCESSPERMISSIONS = 6,
        NONSECURE = 5,
        ATTRINDEX = 2,
    }

    enum DESC_LENGTH : ubyte
    {
        NSTABLE  = 1,
        APTABLE  = 2,
        XNTABLE  = 1,
        PXNTABLE = 1,
        UXN = 1,
        PXN = 1,
        CONTIGUOUS = 1,
        DIRTYBITMODIFIER = 1,
        NONGLOBAL = 1,
        ACCESSED = 1,
        SHAREABILITY = 2,
        ACCESSPERMISSIONS = 2,
        NONSECURE = 1,
        ATTRINDEX = 3,
    }

    @property void nstable(bool nstable) @nogc nothrow @safe
    {
        bitfield_set(&_storage, DESC_OFFSET.NSTABLE, DESC_LENGTH.NSTABLE, nstable);
    }
    @property bool nstable() @nogc nothrow @safe
    {
        return cast(bool) bitfield_get(&_storage, DESC_OFFSET.NSTABLE, DESC_LENGTH.NSTABLE);
    }

    @property void aptable(bool aptable) @nogc nothrow @safe
    {
        bitfield_set(&_storage, DESC_OFFSET.APTABLE, DESC_LENGTH.APTABLE, aptable);
    }
    @property bool aptable() @nogc nothrow @safe
    {
        return cast(bool) bitfield_get(&_storage, DESC_OFFSET.APTABLE, DESC_LENGTH.APTABLE);
    }

    @property void xntable(bool xntable) @nogc nothrow @safe
    {
        bitfield_set(&_storage, DESC_OFFSET.XNTABLE, DESC_LENGTH.XNTABLE, xntable);
    }
    @property bool xntable() @nogc nothrow @safe
    {
        return cast(bool) bitfield_get(&_storage, DESC_OFFSET.XNTABLE, DESC_LENGTH.XNTABLE);
    }

    @property void pxntable(bool pxntable) @nogc nothrow @safe
    {
        bitfield_set(&_storage, DESC_OFFSET.PXNTABLE, DESC_LENGTH.PXNTABLE, pxntable);
    }
    @property bool pxntable() @nogc nothrow @safe
    {
        return cast(bool) bitfield_get(&_storage, DESC_OFFSET.PXNTABLE, DESC_LENGTH.PXNTABLE);
    }

    @property void addr(ptr_t addr) @nogc nothrow @safe
    {
        bitfield_plop(&_storage, 16, 32, addr);
    }
    @property ptr_t addr() @nogc nothrow @safe
    {
        return bitfield_crop(&_storage, 16, 32);
    }

    @property void contiguous(bool contiguous) @nogc nothrow @safe
    {
        bitfield_set(&_storage, DESC_OFFSET.CONTIGUOUS, DESC_LENGTH.CONTIGUOUS, contiguous);
    }
    @property bool contiguous() @nogc nothrow @safe
    {
        return cast(bool) bitfield_get(&_storage, DESC_OFFSET.CONTIGUOUS, DESC_LENGTH.CONTIGUOUS);
    }

    @property void dirty(bool dirty) @nogc nothrow @safe
    {
        bitfield_set(&_storage, DESC_OFFSET.DIRTYBITMODIFIER, DESC_LENGTH.DIRTYBITMODIFIER, dirty);
    }
    @property bool dirty() @nogc nothrow @safe
    {
        return cast(bool) bitfield_get(&_storage, DESC_OFFSET.DIRTYBITMODIFIER, DESC_LENGTH.DIRTYBITMODIFIER);
    }

    @property void nonglobal(bool nonglobal) @nogc nothrow @safe
    {
        bitfield_set(&_storage, DESC_OFFSET.NONGLOBAL, DESC_LENGTH.NONGLOBAL, nonglobal);
    }
    @property bool nonglobal() @nogc nothrow @safe
    {
        return cast(bool) bitfield_get(&_storage, DESC_OFFSET.NONGLOBAL, DESC_LENGTH.NONGLOBAL);
    }

    @property void accessed(bool accessed) @nogc nothrow @safe
    {
        bitfield_set(&_storage, DESC_OFFSET.ACCESSED, DESC_LENGTH.ACCESSED, accessed);
    }
    @property bool accessed() @nogc nothrow @safe
    {
        return cast(bool) bitfield_get(&_storage, DESC_OFFSET.ACCESSED, DESC_LENGTH.ACCESSED);
    }

    @property void shareability(ubyte shareability) @nogc nothrow @safe
    {
        bitfield_set(&_storage, DESC_OFFSET.SHAREABILITY, DESC_LENGTH.SHAREABILITY, shareability);
    }
    @property ubyte shareability(ubyte shareability) @nogc nothrow @safe
    {
        return cast(ubyte) bitfield_get(&_storage, DESC_OFFSET.SHAREABILITY, DESC_LENGTH.SHAREABILITY);
    }

    @property void accesspermissions(ubyte accesspermissions) @nogc nothrow @safe
    {
        bitfield_set(&_storage, DESC_OFFSET.ACCESSPERMISSIONS, DESC_LENGTH.ACCESSPERMISSIONS, accesspermissions);
    }
    @property ubyte accesspermissions(ubyte accesspermissions) @nogc nothrow @safe
    {
        return cast(ubyte) bitfield_get(&_storage, DESC_OFFSET.ACCESSPERMISSIONS, DESC_LENGTH.ACCESSPERMISSIONS);
    }

    @property void nonsecure(bool nonsecure) @nogc nothrow @safe
    {
        bitfield_set(&_storage, DESC_OFFSET.NONSECURE, DESC_LENGTH.NONSECURE, nonsecure);
    }
    @property bool nonsecure() @nogc nothrow @safe
    {
        return cast(bool) bitfield_get(&_storage, DESC_OFFSET.NONSECURE, DESC_LENGTH.NONSECURE);
    }

    @property void attrindex(ubyte attrindex) @nogc nothrow @safe
    {
        bitfield_set(&_storage, DESC_OFFSET.ATTRINDEX, DESC_LENGTH.ATTRINDEX, attrindex);
    }
    @property ubyte attrindex(ubyte attrindex) @nogc nothrow @safe
    {
        return cast(ubyte) bitfield_get(&_storage, DESC_OFFSET.ATTRINDEX, DESC_LENGTH.ATTRINDEX);
    }

}

void init_table_desc(table_entry* desc)
{
    desc._storage = 0b11;
}

void init_page_desc(table_entry* desc)
{
    desc._storage = 0b11;
}

void init_invalid_desc(table_entry* desc)
{
    desc._storage = 0b00;
}



