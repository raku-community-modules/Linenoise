use v6;

use Panda::Builder;
use LibraryMake;

class Build is Panda::Builder {
    method build($workdir) {
        mkdir("$workdir/blib");
        mkdir("$workdir/blib/lib");
        my %vars = get-vars("$workdir/blib/lib");
        %vars<PREFIX> = $*VM.config<prefix>;

        process-makefile($workdir, %vars);
        shell(%vars<MAKE>);
    }
}
