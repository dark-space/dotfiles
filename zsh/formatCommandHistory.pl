#!/usr/bin/perl
use strict;
use warnings;

my ($all, $dir) = ($ARGV[1], $ARGV[2]);
$_ = $ARGV[0];
s/\t+/ /g;
s/[\r\n]+/; /g;
s/  +/ /g;

if (/^\s*[ha]a?(.*)$/) {
    if ($1 eq "" || $1 =~ /^\s+/) {
        exit 0;
    }
}

open(OUT, ">>", $all);
print OUT $_ . "\t\t@(" . $ENV{PWD} . ")\n";
close(OUT);
open(OUT, ">>", $dir);
print OUT $_ . "\n";
close(OUT);

