#include <fcntl.h>
#include <stdio.h>

int
main(void)
{
    printf("F_GETFL=%d\n", F_GETFL);
    printf("F_SETFL=%d\n", F_SETFL);
    printf("O_NONBLOCK=%d\n", O_NONBLOCK);

    return 0;
}
