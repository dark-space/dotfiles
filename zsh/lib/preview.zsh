#!/usr/bin/zsh

n=-100
if [ $# -ge 2 ] && [[ "$1" =~ ^-\d+ ]]; then
    n=$1
    shift
fi

if [ ! -e $1 ]; then
    cmd=$(sed -e 's/^\.\///' <<< $1)
    which $cmd
elif [ -f $1 ]; then
    if file $1 | grep '\(text\|empty\)' >/dev/null 2>&1; then
        head $n $1
    else
        od -Ax -tx1z $1 | head $n
    fi
else
    ls -a --color $1 | lines 3.. | head $n
fi

