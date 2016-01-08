use v6;

use Panda::Builder;
use Native::Resources::Build;

class Build is Panda::Builder {
    method build($workdir) {
        make($workdir, "$workdir/resources/lib", :libname<linenoise>);
    }
}
