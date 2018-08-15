#
# 独自のコマンドヒストリを作る
#
history_all=$HOME/.zsh/history_all.txt
history_basedir=$HOME/.zsh/histories

function preexec_history() {
    cmd=$1
    echo "$cmd$(builtin pwd)" >> $history_all
    local history_dir="${history_basedir}$(builtin pwd)"
    mkdir -p $history_dir
    echo "$cmd" >> $history_dir/history
}

fzf-history-widget() {
    local history_file="${history_basedir}$(builtin pwd)/history"
    if [ -e $history_file ]; then
        local selected=( \
            $(tac $history_file | unique | \
            FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=\"ctrl-r:toggle-sort\" $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" \
            ./$(__fzfcmd)) \
        )
        local ret=$?
        BUFFER="$selected"
        zle redisplay
        typeset -f zle-line-init >/dev/null && zle zle-line-init
        zle accept-line
        return $ret
    fi
}
zle -N fzf-history-widget
bindkey "^r" fzf-history-widget

