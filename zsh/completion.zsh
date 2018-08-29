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

