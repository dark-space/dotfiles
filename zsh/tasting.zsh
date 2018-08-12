function debug_print() {
    echo "[$LBUFFER][$RBUFFER][$BUFFERLINES]"
}
zle -N debug_print
#bindkey "^r^s" debug_print

