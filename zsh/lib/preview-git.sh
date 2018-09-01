#!/bin/sh

n=-100
if [ $# -ge 2 ] && echo "$1" | grep '^-\d\+' >/dev/null 2>&1; then
    n=$1
    shift
fi

if [ -e "$1" ]; then
    git diff --color=always "$1" | head $n | grep '.'
    if [ $? -ne 0 ]; then
        head $n "$1"
    fi
else
    branch=$(git branch | grep '^\*' | strutil de)
    if echo "$1" | grep "^${branch}\.\.\." >/dev/null 2>&1; then
        git diff --color=always $branch
    else
        echo "renamed or removed."
    fi
fi

