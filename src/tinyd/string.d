module tinyd.string;

ulong min(ulong a, ulong b)
{
    return (a < b) ? a : b;
}

int compare(char[] s1, char[] s2) {
    ulong minsize = min(s1.length, s2.length);
    for (ulong i = 0; i < minsize; i++)
    {
        if (s1[i] != s2[i]) {
            return s1[i] - s2[i];
        }
    }
    return cast(int) (s1.length - s2.length);
}