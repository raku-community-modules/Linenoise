# Perl 6 Linenoise

Linenoise (https://github.com/antirez/linenoise) bindings for Perl 6.

**NOTE**: MoarVM current bundles linenoise as a VM-level operation; this is part of
an experiment to decouple it from the VM.

**NOTE**: This doesn't work with regular linenoise forked from antirez's repository; MoarVM is
up to something with standard input, so I have a local fix in place until the MoarVM developers
can help me fix it.
