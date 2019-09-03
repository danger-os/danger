module vm.aarch64;

import tinyd.bitmanip;

alias ptr_t = ulong;

struct table_desc
{
    import tinyd.bitmanip;
    ulong _storage;

    enum DESC_OFFSET : ubyte
    {
        NSTABLE  = 63,
        APTABLE  = 61,
        XNTABLE  = 60,
        PXNTABLE = 59,
    }
    enum DESC_LENGTH : ubyte
    {
        NSTABLE  = 1,
        APTABLE  = 2,
        XNTABLE  = 1,
        PXNTABLE = 1,
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
}

void set_address_table_desc64k(table_desc* desc, ptr_t address) @nogc nothrow @safe
{
    bitfield_set(&(desc._storage), 16, 32, address);
}
ptr_t get_address_table_desc64k(table_desc* desc) @nogc nothrow @safe
{
    return bitfield_get(&(desc._storage), 16, 32);
}

void set_address_block_desc64k(table_desc* desc, ptr_t address) @nogc nothrow @safe
{
    bitfield_set(&(desc._storage), 29, 19, address);
}
ptr_t get_address_block_desc64k(table_desc* desc) @nogc nothrow @safe
{
    return bitfield_get(&(desc._storage), 29, 19);
}

void set_address_page_desc64k(table_desc* desc, ptr_t address) @nogc nothrow @safe
{
    bitfield_set(&(desc._storage), 16, 32, address);
}
ptr_t get_address_page_desc64k(table_desc* desc) @nogc nothrow @safe
{
    return bitfield_get(&(desc._storage), 16, 32);
}

void init(table_desc d)
{
    return;
}

enum DESC_TYPE
{
    LVL0_TABLE,
    LVL1_TABLE,
    LVL1_BLK,
    LVL2_TABLE,
    LVL2_BLK,
    LVL3_PAGE,
}


