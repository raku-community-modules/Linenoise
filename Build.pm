use v6;
use LibraryMake;

class Build {
    method build($srcdir) {
        my %vars = get-vars($srcdir);
        %vars<linenoise> = %vars<DESTDIR>.IO.child('resources').child('libraries')
            .child($*VM.platform-library-name('linenoise'.IO)).Str;
        %vars<constant_helper> = %vars<DESTDIR>.IO.child('resources').child('libraries')
            .child($*VM.platform-library-name('constant_helper'.IO)).Str;
        mkdir "$srcdir/resources/libraries" unless "$srcdir/resources/libraries".IO.e;
        process-makefile($srcdir, %vars);
        shell(%vars<MAKE>);
        return 1;
    }
}
