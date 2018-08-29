function completion() {
    local buffer_length
    buffer_length=$#BUFFER
    BUFFER=$(perl $dotfiles/zsh/lib/expandByFzf.pl "$BUFFER" $CURSOR "$dotfiles")
    CURSOR+=$(($#BUFFER - $buffer_length - 2))
    zle vi-forward-blank-word-end
    zle forward-char
    zle reset-prompt
}
zle -N completion
bindkey "\e[Z" completion

function expandByFzf() {
    local buffer_length
    buffer_length=$#BUFFER
    BUFFER=$(perl $dotfiles/zsh/lib/expandByFzf.pl $BUFFER $CURSOR)
    CURSOR+=$(($#BUFFER - $buffer_length - 2))
    zle vi-forward-blank-word-end
    zle forward-char
    zle reset-prompt
}

function separate_and_complete() {
    if [ ! -z $RBUFFER ] && [ "X$RBUFFER[1]" != "X " ]; then
        zle set-mark-command
        if [ "X$RBUFFER[1]" = "X/" ]; then
            zle forward-char
        fi
        if [ "X$RBUFFER[2]" != "X " ]; then
            zle vi-forward-blank-word-end
        fi
        zle forward-char
        zle kill-region
        CUTBUFFER=" $CUTBUFFER"
        zle vi-put-before
        if [ "X$LBUFFER[-1]" != "X " ]; then
            zle vi-backward-blank-word
        fi
        zle backward-char
    fi
    zle expand-or-complete
}
