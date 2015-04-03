# NAME

Linenoise

# AUTHOR

Rob Hoelz <rob AT hoelz.ro>

# SYNOPSIS

```perl6
    use Linenoise;

    while (my $line = linenoise '> ').defined {
        say "got a line: $line";
    }
```

# DESCRIPTION

This module provides bindings to linenoise
(https://github.com/antirez/linenoise) for Perl 6 via NativeCall.
