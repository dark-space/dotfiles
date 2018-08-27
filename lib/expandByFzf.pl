#!/usr/bin/perl
use strict;
use warnings;

my ($buffer, $pos, $dotfiles_path) = @ARGV;

my ($head, $target, $tail) = &getTarget($buffer, $pos);
#`echo "[1] \"$head\"" >> $dotfiles_path/debug.txt`;
#`echo "[2] \"$target\"" >> $dotfiles_path/debug.txt`;
#`echo "[3] \"$tail\"" >> $dotfiles_path/debug.txt`;
my ($d, $f) = &splitPath($target);
#`echo "[d] \"$d\"" >> $dotfiles_path/debug.txt`;
#`echo "[f] \"$f\"" >> $dotfiles_path/debug.txt`;

my $filelist_colored = `ls -1pa --color=always "$d" | lines 3:`;
my $mixed_list = $filelist_colored;
if ($head =~ /^\s*$/ && $target !~ /\// && $target =~ /\S/) {
    my %files = ();
    foreach (split("\n", $filelist_colored)) {
        s/\[[\d;]+m//g;
        s/\/$//;
        $files{$_} = 1;
    }
    my @commands = ();
    my $c = `zsh $dotfiles_path/lib/compgen -abck | unique | grep -i '$f'`;
    foreach (split("\n", $c)) {
        if (not defined ($files{$_})) {
            push(@commands, "[33m" . $_ . "[0m");
        }
    }
    $mixed_list .= join("\n", @commands);
}
#open(OUT, ">", "$dotfiles_path/debug.txt");
#print OUT "$mixed_list\n";
#close(OUT);

my @grepped = ();
foreach (split("\n", $mixed_list)) {
    my $orig = $_;
    s/^\[[\d;]+m//;
    if ($_ =~ ("^" . quotemeta($f))) {
        push(@grepped, $orig);
    }
}
my $chosen = "";
if (scalar(@grepped) == 0) {
    $chosen = &fzf($d, "$f ", $mixed_list);
} elsif (scalar(@grepped) == 1) {
    ($chosen = $grepped[0]) =~ s/\[[\d;]+m//g;
} else {
    my $pre_test = join("\n", @grepped);
    $chosen = &fzf($d, "", $pre_test);
}

if (length($chosen) > 0) {
    my $expanded = "";
    foreach (split("\n", $chosen)) {
        if (length($expanded) > 0) { $expanded .= " "; }
        if ($target !~ /\//) {
            $expanded .= $_;
        } else {
            $expanded .= $d . "/" . $_;
        }
    }
    print $head . $expanded . $tail;
} else {
    print $buffer;
}

sub fzf {
    my ($d, $q, $texts) = @_;
    my $fzf_default_opts = "-m -e --ansi --reverse --border --height 50% --preview \"head $d/{}\" --select-1 -0";
    return `echo -n "$texts" | fzf --query="$q" $fzf_default_opts`;
}

sub getTarget {
    my ($b, $pos) = @_;
    if (length($b) == $pos || substr($b, $pos, 1) eq " ") {
        if (substr($b, $pos-1, 1) eq " ") {
            return (substr($b, 0, $pos), "", substr($b, $pos));
        } else {
            my ($from, $to) = &curIslandPos($b, $pos);
            return (substr($b, 0, $from), substr($b, $from, $to-$from), ($to >= length($b))? "" : substr($b, $to));
        }
    } else {
        my ($from, $to) = &curIslandPos($b, $pos);
        return (substr($b, 0, $from), substr($b, $from, $to-$from), substr($b, $to));
    }
}

sub curIslandPos {
    my ($b, $pos) = @_;;
    #print STDERR "\"$b\"(" . length($b) . ") $pos\n";
    if (substr($b, $pos, 1) eq " ") {
        my $left = rindex($b, " ", $pos-1) + 1;
        my $right = $pos;
        return ($left, $right);
    } else {
        my $left = rindex($b, " ", $pos) + 1;
        my $right = index($b, " ", $pos) - 1;
        if ($right < 0) { $right = length($b); }
        return ($left, $right);
    }
}

sub splitPath {
    my $path = $_[0];
    if ($path =~ /^(.*)\/([^\/]*)/) {
        return ($1, $2);
    } else {
        return (".", $path);
    }
}

