use v6;

use Panda::Builder;
use LibraryMake;

class Build is Panda::Builder {
    method build($workdir) {
        mkdir("$workdir/blib");
        mkdir("$workdir/blib/lib");
        my %vars = get-vars("$workdir/blib/lib");
        my @shared-object-extensions = <.so .dll .dylib>.grep(* ne %vars<SO>);

        %vars<FAKESO> = @shared-object-extensions.map('resources/lib/liblinenoise' ~ *);

        my $fake-so-rules = @shared-object-extensions.map({
            "resources/lib/liblinenoise$_:\n\tperl6 -e \"print ''\" > resources/lib/liblinenoise$_"
        }).join("\n");

        process-makefile($workdir, %vars);
        spurt("$workdir/Makefile", $fake-so-rules, :append);
        shell(%vars<MAKE>);
    }
}
