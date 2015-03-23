use v6;

use NativeCall;

module Linenoise {
    # XXX these belong in separate modules, and are probably Linux-specific
    my constant STDIN_FILENO = 0;
    my constant F_GETFL      = 0x03;
    my constant F_SETFL      = 0x04;
    my constant O_NONBLOCK   = 0x800;

    my sub fcntl(Int $fd, Int $cmd, Int $arg) returns Int is native(Str) { * }

    our class Completions is repr('CPointer') {}

    my sub linenoise_raw(Str $prompt) returns Str is native('liblinenoise.so') is symbol('linenoise') { * }

    our sub linenoiseHistoryAdd(Str $line) is native('liblinenoise.so') is export { * }
    our sub linenoiseHistorySetMaxLen(int $len) returns int is native('liblinenoise.so') is export { * }
    our sub linenoiseHistorySave(Str $filename) returns int is native('liblinenoise.so') is export { * }
    our sub linenoiseHistoryLoad(Str $filename) returns int is native('liblinenoise.so') is export { * }
    our sub linenoiseClearScreen() is native('liblinenoise.so') is export { * }
    our sub linenoiseSetMultiLine(int $ml) is native('liblinenoise.so') is export { * }
    our sub linenoisePrintKeyCodes() is native('liblinenoise.so') is export { * }

    our sub linenoiseSetCompletionCallback(&callback (Str, Completions)) is native('liblinenoise.so') is export { * }
    our sub linenoiseAddCompletion(Completions $completions, Str $completion) is native('liblinenoise.so') is export { * }

    # XXX make sure this works with unpatched linenoise
    our sub linenoise(Str $prompt) returns Str is export {
        my $flags = fcntl(STDIN_FILENO, F_GETFL, 0);

        LEAVE fcntl(STDIN_FILENO, F_SETFL, $flags);

        fcntl(STDIN_FILENO, F_SETFL, $flags +& +^O_NONBLOCK);

        return linenoise_raw($prompt);
    }
}
