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

# EXAMPLES

## Basic History

```perl6
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

```perl6
use Linenoise;

my @commands = <help quit list get set>;

linenoiseSetCompletionCallback(-> $line, $c {
    my ( $prefix, $last-word ) = find-last-word($line);

    for @commands.grep(/^ "$last-word" /).sort -> $cmd {
        linenoiseHistoryAdd($c, $prefix ~ $cmd);
    }
});

while (my $line = linenoies '> ').defined {
    say "got a line: $line";
}
```
