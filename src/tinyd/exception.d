module tinyd.exception;

extern (C)
{
    void _d_arraybounds(string file, uint line)
    {
    }

    void _d_switch_error(string file, uint line)
    {
    }

    bool IS_ERR(void* error) {
        return 0 < cast(ulong) error && cast(ulong) error < 4096;
    }
    long PTR_ERR(void* error) {
        return cast(long) error;
    }
}