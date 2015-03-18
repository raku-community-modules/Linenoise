use v6;

use NativeCall;

module Linenoise {
    our sub linenoise(Str $prompt) returns Str is native('liblinenoise.so') is export { * }
}
