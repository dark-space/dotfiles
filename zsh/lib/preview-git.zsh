#!/usr/bin/zsh

n=-100
if [ $# -ge 2 ] && [[ "$1" =~ ^-\d+ ]]; then
    n=$1
    shift
fi

git diff --color=always "$1" | grep '.'
if [ $? -ne 0 ]; then
    head $n "$1"
fi

