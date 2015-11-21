#if _WIN32 || _WIN64
# define F_GETFL    0
# define F_SETFL    0
# define O_NONBLOCK 0
#else
# include <fcntl.h>
#endif

#include <stdio.h>
#include <stdlib.h>

static int
msc_version_to_dll_version(int msc_version)
{
    if(msc_version == 800) {
        return 10; /* 1.0 is an exception */
    } else {
        return (msc_version / 10) - 60;
    }
}

int
main(void)
{
    printf("F_GETFL=%d\n", F_GETFL);
    printf("F_SETFL=%d\n", F_SETFL);
    printf("O_NONBLOCK=%d\n", O_NONBLOCK);

#if _WIN32 || _WIN64
# if defined(_MSC_VER) && (_MSC_VER < 1000 || _MSC_VER >= 1300)
    printf("CLIB=\"msvcr%d.dll\"\n", msc_version_to_dll_version(_MSC_VER));
# else
    printf("CLIB=\"msvcrt.dll\"\n");
# endif
#else
    printf("CLIB=Str\n");
#endif

    return 0;
}
