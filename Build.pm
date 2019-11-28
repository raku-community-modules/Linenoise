use v6;
use LibraryMake;

class Build {
    method build($srcdir) {
        my %vars = get-vars($srcdir);
        %vars<linenoise> = $*VM.platform-library-name('linenoise'.IO).basename;
        say "Creating directory";
        mkdir IO::Path.new("$srcdir/resources/libraries") unless "$srcdir/resources/libraries".IO.e;
        say "Processing makefile in $srcdir with %vars";
        process-makefile($srcdir, %vars);
        shell %vars<MAKE>, :cwd($srcdir);
    }
}
