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
        ls -lp --color=always $1 | sed -e 's/^/[30;46m/' -e 's/$/[0m/'
        echo ""
        head $n $1
    else
        ls -lp --color=always $1 | sed -e 's/^/[30;46m/' -e 's/$/[0m/'
        echo ""
        od -Ax -tx1z $1 | head $n
    fi
else
    ls -dlp --color=always $1 | sed -e 's/^/[30;46m/' -e 's/$/[0m/'
    echo ""
    unbuffer ls -a --color=always $1 | head $n
fi

