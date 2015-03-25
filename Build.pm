use v6;

use Panda::Builder;
use LibraryMake;

class Build is Panda::Builder {
    method build($workdir) {
        run('git', 'submodule', 'init');
        run('git', 'submodule', 'update');
        mkdir("$workdir/blib");
        mkdir("$workdir/blib/lib");
        make($workdir, "$workdir/blib/lib");
    }
}
