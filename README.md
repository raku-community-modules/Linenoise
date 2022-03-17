[![Actions Status](https://github.com/raku-community-modules/Linenoise/workflows/test/badge.svg)](https://github.com/raku-community-modules/Linenoise/actions)
[![Actions Status](https://github.com/raku-community-modules/Linenoise/workflows/macos/badge.svg)](https://github.com/raku-community-modules/Linenoise/actions)
[![Actions Status](https://github.com/raku-community-modules/Linenoise/workflows/windows/badge.svg)](https://github.com/raku-community-modules/Linenoise/actions)

# Name

Linenoise

# Author

Rob Hoelz <rob AT hoelz.ro>

# Synopsis

```raku
use Linenoise;

while (my $line = linenoise '> ').defined {
    say "got a line: $line";
}
```

# Description

This module provides bindings to linenoise ([https://github.com/antirez/linenoise](https://github.com/antirez/linenoise)) for Raku via NativeCall.

# Installation

You can install via zef:

```
$ zef install Linenoise
```

Note that since this module has binary components, you'll need a working C compiler.  Everything you need can be found under the `build-essential` package
on Debian-based Linux distributions, such as Ubuntu.

# Examples

## Basic History

```raku
use Linenoise;

my constant HIST_FILE = '.myhist';
my constant HIST_LEN  = 10;

linenoiseHistoryLoad(HIST_FILE);
linenoiseHistorySetMaxLen(HIST_LEN);

while (my $line = linenoise '> ').defined {
    linenoiseHistoryAdd($line);
    say "got a line: $line";
}

linenoiseHistorySave(HIST_FILE);
```

## Tab Completion

```raku
use Linenoise;

my @commands = <help quit list get set>;

linenoiseSetCompletionCallback(-> $line, $c {
    my ( $prefix, $last-word ) = find-last-word($line);

    for @commands.grep(/^ "$last-word" /).sort -> $cmd {
        linenoiseAddCompletion($c, $prefix ~ $cmd);
    }
});

while (my $line = linenoise '> ').defined {
    say "got a line: $line";
}
```

COPYRIGHT AND LICENSE
=====================

Copyright 2015 - 2017 Rob Hoelz

Copyright 2018 - 2022 Raku Community

This library is free software; you can redistribute it and/or modify it under the MIT license.
