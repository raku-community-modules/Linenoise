#!/usr/bin/env perl6

use v6;

sub get-constants(@lines) {
    gather for @lines -> $definition {
        my ( $key, $value ) = $definition.split('=');
        take $key, $value;
    }
}

sub MAIN {
    my %constants = get-constants(pipe('./constant-helper', :r).lines());

    for lines() -> $line {
        my $new-line = $line;
        if $line ~~ /my \s+ constant \s+ $<ident>=[\w+] \s* '=' \s* $<value>=['#`(FILL-ME-IN)']/ {
            $new-line.substr-rw($<value>.from, $<value>.chars) = '0x%x'.sprintf(%constants{~$<ident>});
        }
        say $new-line;
    }
}
