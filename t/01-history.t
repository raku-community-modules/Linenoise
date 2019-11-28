use v6; # -*- mode: perl6 -*-

use Test;

use Linenoise;

my $history-str = "say 33";
linenoiseHistoryAdd($history-str);
my $history-path = "$*TMPDIR/linenoise-history.txt";
linenoiseHistorySave($history-path);
is($history-path.IO.slurp.chomp,$history-str, "History saves OK");

done-testing;
