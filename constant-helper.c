#if _WIN32 || _WIN64
# define F_GETFL    0
# define F_SETFL    0
# define O_NONBLOCK 0
#else
# include <fcntl.h>
#endif

#include <stdio.h>

int
main(void)
{
    printf("F_GETFL=%d\n", F_GETFL);
    printf("F_SETFL=%d\n", F_SETFL);
    printf("O_NONBLOCK=%d\n", O_NONBLOCK);

    return 0;
}
