#!/bin/sh
set -eu

CMD=$(perl $(dirname $(readlink -e $0))/tovim.pl "$@")
eval $CMD

