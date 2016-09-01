use v6;

use Panda::Builder;
use LibraryMake;
use Shell::Command;

class Build is Panda::Builder {
    method build($workdir) {
        mkdir("$workdir/blib");
        mkdir("$workdir/blib/lib");
        my %vars = get-vars("$workdir/blib/lib");

        %vars<helper> = 'resources/libraries/' ~ $*VM.platform-library-name('liblinenoise'.IO);

        process-makefile($workdir, %vars);
        shell(%vars<MAKE>);
    }
}
