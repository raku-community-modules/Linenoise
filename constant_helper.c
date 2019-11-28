#include <stdio.h>
#include <stdlib.h>

#if _WIN32 || _WIN64
# define F_GETFL    0
# define F_SETFL    0
# define O_NONBLOCK 0
#else
# include <fcntl.h>
#endif

int f_getfl_helper(void) {
    return F_GETFL;
}

int f_setfl_helper(void) {
    return F_SETFL;
}

int o_nonblock_helper(void) {
    return O_NONBLOCK;
}

int _msc_ver_helper(void) {
#if _WIN32 || _WIN64
#if defined(_MSC_VER)
    return _MSC_VER;
#endif
#else
    return -1;
#endif
}

int main() {
	return 0;
}
