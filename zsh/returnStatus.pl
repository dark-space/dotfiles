#!/usr/bin/perl
use strict;
use warnings;

my @s = ();
foreach (@ARGV) {
    foreach (split(" ", $_)) {
        push(@s, $_);
    }
}
my $status = pop(@s);
if ($status != 0) {
    print 2;
    exit 0;
}
foreach (@s) {
    if ($_ != 0) {
        print 1;
        exit 0;
    }
}
print 0;
exit 0;

