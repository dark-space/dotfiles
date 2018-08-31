#!/usr/bin/zsh

n=-100
if [ $# -ge 2 ] && [[ "$1" =~ ^-\d+ ]]; then
    n=$1
    shift
fi

if grep '\]$' <<< "$1" >/dev/null 2>&1; then
    echo -n ""
    return
fi

git diff --color=always "$1" | head $n | grep '.'
if [ $? -ne 0 ]; then
    head $n "$1"
fi

