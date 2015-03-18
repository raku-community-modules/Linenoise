use v6;

use NativeCall;

module Linenoise {
    our class Completions is repr('CPointer') {}

    our sub linenoise(Str $prompt) returns Str is native('liblinenoise.so') is export { * }
    our sub linenoiseHistoryAdd(Str $line) is native('liblinenoise.so') is export { * }
    our sub linenoiseHistorySetMaxLen(int $len) returns int is native('liblinenoise.so') is export { * }
    our sub linenoiseHistorySave(Str $filename) returns int is native('liblinenoise.so') is export { * }
    our sub linenoiseHistoryLoad(Str $filename) returns int is native('liblinenoise.so') is export { * }
    our sub linenoiseClearScreen() is native('liblinenoise.so') is export { * }
    our sub linenoiseSetMultiLine(int $ml) is native('liblinenoise.so') is export { * }
    our sub linenoisePrintKeyCodes() is native('liblinenoise.so') is export { * }

    our sub linenoiseSetCompletionCallback(&callback (Str, Completions)) is native('liblinenoise.so') is export { * }
    our sub linenoiseAddCompletion(Completions $completions, Str $completion) is native('liblinenoise.so') is export { * }
}
