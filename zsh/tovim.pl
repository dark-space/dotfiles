#!/usr/bin/perl
use strict;
use warnings;

if (!defined $ENV{TMUX} || $ENV{TMUX} eq "") {
    &normalOpen(\@ARGV);
    exit;
}

foreach (@ARGV) {
    if (/^-/) {
        &normalOpen(\@ARGV);
        exit;
    }
}

my $target = "";
foreach (split("\n", `tmux list-panes -F "#{pane_pid}#{pane_id}"`)) {
    if (/^([^%]+)(%.+)$/) {
        my ($p, $t) = ($1, $2);
        if (`pstree $p` =~ /--vim$/) {
            $target = $t;
            last;
        }
    }
}

if ($target eq "") {
    &normalOpen(\@ARGV);
    exit;
}

my $abstPaths = &getPaths(\@ARGV);
print("tmux send-keys -t$target \":ar$abstPaths\" C-m; tmux select-pane -t$target");

sub normalOpen {
    my $args = "";
    foreach (@{$_[0]}) {
        $args .= " '" . &readlink($_) . "'";
    }
    print "eval \"vim$args\"";
}

sub readlink {
    if ($_[0] =~ m%^(/mnt/|/)[a-z]/%) {
        return `readlink -mz $_[0]`;
    }
    return $_[0];
}

sub getPaths {
    my $paths = "";
    foreach (@{$_[0]}) {
        if (/ /) {
            $_ = `readlink -mz "$_"`;
            s/ /\\ /g;
            $paths .= " " . $_;
        } else {
            $paths .= " " . `readlink -mz $_`;
        }
    }
    return $paths;
}

