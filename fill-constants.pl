#!/usr/bin/env perl6

use v6;

sub get-constants(@lines) {
    gather for @lines -> $definition {
        my ( $key, $value ) = $definition.split('=');
        take $key, val($value);
    }
}

sub MAIN {
    my %constants = get-constants(run('./constant-helper', :out).out.lines()).flat;

    for lines() -> $line {
        my $new-line = $line;
        if $line ~~ /my \s+ constant \s+ $<ident>=[\w+] \s* '=' \s* $<value>=['#`(FILL-ME-IN)']/ {
            my $ident = ~$<ident>;

            if %constants{$ident} ~~ Str {
                $new-line.substr-rw($<value>.from, $<value>.chars) = %constants{$ident};
            } else {
                $new-line.substr-rw($<value>.from, $<value>.chars) = '0x%x'.sprintf(%constants{$ident});
            }
        }
        elsif $line.contains('#`(FILL-THIS)') {
            $new-line = $new-line.subst('#`(FILL-THIS)',$*DISTRO.is-win ?? ("'" ~ CompUnit::RepositoryRegistry.repository-for-name("site").Str ~ "'") !! "''");
        }
        say $new-line;
    }
}
