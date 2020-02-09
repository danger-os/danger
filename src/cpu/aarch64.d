module aarch64;

@nogc nothrow @trusted byte get_cpu_id()
{
    // 30th bit tells us this is a single processor system
    enum ulong uniprocessor_bitmask = (1 << 30);
    ulong mpidr;
    byte cpu_id;
    asm
    {
        "mrs %[mpidr], mpidr_el1"
        : [mpidr] "=r" mpidr;
    }

    if(mpidr & uniprocessor_bitmask)
    {
        // Single processor, so you are processor 0
        cpu_id = 0;    
    }
    else
    {
        // Bottom 8 bits are affinity 0
        cpu_id = cast(byte)(mpidr & 0xff);
    }

    return cpu_id;
}

@nogc nothrow @trusted ulong get_exception_level()
{
    ulong e_level;
    asm
    {
        "mrs %[el], currentel"
        : [el] "=r" e_level;
    }
    e_level >>= 2; // Bits [3:2] contain exception level
    return e_level;
}
