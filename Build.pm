use v6;

use Panda::Builder;
use LibraryMake;

class Build is Panda::Builder {
    method build($workdir) {
        mkdir("$workdir/blib");
        mkdir("$workdir/blib/lib");
        make($workdir, "$workdir/blib/lib");
    }
}
