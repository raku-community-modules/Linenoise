use v6;
use LibraryMake;

class Build {
    method build($srcdir) {
        my %vars = get-vars($srcdir);
        %vars<linenoise> = $*VM.platform-library-name('linenoise'.IO).basename;
        mkdir "$srcdir/resources/libraries" unless "$srcdir/resources/libraries".IO.e;
        process-makefile($srcdir, %vars);
        shell %vars<MAKE>, :cwd($srcdir);
    }
}
