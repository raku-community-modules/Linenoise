use v6;

use NativeCall;

#| This module provides bindings to linenoise
#| (L<https://github.com/antirez/linenoise>) for Perl 6
#| via NativeCall.
module Linenoise:ver<0.1.1>:auth<github:hoelzro> {
    my constant $LIBLINENOISE       = %?RESOURCES<libraries/linenoise>;
    my constant $LIBCONSTANT_HELPER = %?RESOURCES<libraries/constant_helper>;
    my constant STDIN_FILENO = 0;

    my sub f_getfl_helper    (--> int32) is native($LIBCONSTANT_HELPER) { * }
    my sub f_setfl_helper    (--> int32) is native($LIBCONSTANT_HELPER) { * }
    my sub o_nonblock_helper (--> int32) is native($LIBCONSTANT_HELPER) { * }
    my sub _msc_ver_helper   (--> int32) is native($LIBCONSTANT_HELPER) { * }
    my sub MSCLIB {
        my $msc_ver = _msc_ver_helper();
        if $msc_ver && ($msc_ver < 1000 || $msc_ver >= 1300) {
            sprintf("msvcr%d.dll", $msc_ver == 800 ?? 10 !! ($msc_ver / 10) - 60);
        }
        else {
            "msvcrt.dll";
        }
    }

    my sub fcntl(int32 $fd, int32 $cmd, int32 $arg) returns int32 is native(Str) { * }
    my sub free(Pointer $p) is native($*DISTRO.is-win ?? &MSCLIB !! Str) { * }

    #| Completions objects are opaque data structures provided by linenoise
    #| that contain the current list of completions for the completions
    #| request.  See L<#linenoiseAddCompletion> for more details.
    our class Completions is repr('CPointer') {}

    my sub linenoise_raw(Str $prompt) returns Pointer[Str] is native($LIBLINENOISE) is symbol('linenoise') { * }

    #| Adds an entry to the current history list.  C<$line> must be C<.defined>!
    our sub linenoiseHistoryAdd(Str $line) is native($LIBLINENOISE) is export { * }

    #| Sets the maximum length of the history list.  Entries at the front of this list will be
    #| evicted.
    our sub linenoiseHistorySetMaxLen(int32 $len) returns int32 is native($LIBLINENOISE) is export { * }

    #| Saves the current history list to a file.
    our sub linenoiseHistorySave(Str $filename) returns int32 is native($LIBLINENOISE) is export { * }

    #| Loads a file and populates the history list from its contents.
    our sub linenoiseHistoryLoad(Str $filename) returns int32 is native($LIBLINENOISE) is export { * }

    #| Clears the screen.
    our sub linenoiseClearScreen() is native($LIBLINENOISE) is export { * }

    #| Enables/disables multi line history mode.
    our sub linenoiseSetMultiLine(int32 $ml) is native($LIBLINENOISE) is export { * }

    #| Puts linenoise into key code printing mode (used for debugging).
    our sub linenoisePrintKeyCodes() is native($LIBLINENOISE) is export { * }

    #| Sets up a completion callback, invoked when the user presses tab.  The
    #| callback gets the current line, and a completions object.  See
    #| L<#linenoiseAddCompletion> to see how to add completions from within
    #| a callback.
    our sub linenoiseSetCompletionCallback(&callback (Str, Completions)) is native($LIBLINENOISE) is export { * }

    #| Adds a completion to the current set of completions.  The first
    #| parameter is the completions object (which is passed into the callback),
    #| and the second is the completion to be added, as a full line.
    #| Completions are offered in the order in which they are provided to this
    #| function, so keep that in mind if you want your users to have a sorted
    #| list of completions.
    our sub linenoiseAddCompletion(Completions $completions, Str $completion) is native($LIBLINENOISE) is export { * }

    #| Prompts the user for a line of input after displaying L<$prompt>, and
    #| returns that line.  During this operation, standard input is set to
    #| blocking, and line editing functions provided by linenoise are available.
    our sub linenoise(Str $prompt) returns Str is export {
        unless $*DISTRO.is-win {
            my $flags = fcntl(STDIN_FILENO, f_getfl_helper(), 0);

            if $flags == -1 {
                fail "fcntl(\$*IN, F_GETFL, 0) failed";
            }

            KEEP fcntl(STDIN_FILENO, f_setfl_helper(), $flags);

            my $status = fcntl(STDIN_FILENO, f_setfl_helper(), $flags +& +^ o_nonblock_helper());

            if $status == -1 {
                fail "fcntl(\$*IN, F_SETFL, ~O_NONBLOCK) failed";
            }
        }

        my $p = linenoise_raw($prompt);

        if $p {
            my $line = $p.deref;
            free($p);
            $line;
        } else {
            Str
        }
    }
}

=begin pod

=head1 NAME

Linenoise

=head1 AUTHOR

Rob Hoelz <rob AT hoelz.ro>

=head1 SYNOPSIS

    use Linenoise;

    while (my $line = linenoise '> ').defined {
        say "got a line: $line";
    }

=head1 DESCRIPTION

This module provides bindings to linenoise
(L<https://github.com/antirez/linenoise>) for Perl 6 via NativeCall.

=head1 EXAMPLES

=head2 Basic History

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

=head2 Tab Completion

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

=end pod
