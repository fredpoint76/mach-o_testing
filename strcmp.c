int strcmp (const char * s1, const char * s2)
{
    for(; *s1 == *s2; ++s1, ++s2)
        if(*s1 == 0)
            return 0;
    return *(unsigned char *)s1 < *(unsigned char *)s2 ? -1 : 1;
}

int strncmp (const char * const s1, const char * const s2, const int num)
{
    const unsigned char * const us1 = (const unsigned char *) s1;
    const unsigned char * const us2 = (const unsigned char *) s2;
 	int i;
 
    for(i = 0; i < num; ++i)
    {
        if(us1[i] < us2[i])
           return -1;
        else if(us1[i] > us2[i])
           return 1;
        else if(! us1[i]) /* null byte -- end of string */
           return 0;
    }
 
    return 0;
}
