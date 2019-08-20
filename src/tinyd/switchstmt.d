module tinyd.switchstmt;

extern(C):
int _d_switch_string(char[][] table, char[] compare)
{
    import tinyd.string;
    for (int i = 0; i < cast(int) table.length; i++)
    {
        if (table[i].compare(compare) == 0)
        {
            return i;
        }
    }
    return -1;
}