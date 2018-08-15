#
# 独自のコマンドヒストリを作る
#
history_all=$HOME/.zsh/history_all.txt
history_basedir=$HOME/.zsh/histories
history_session=""

function __fzfcmd_dev() {
    echo "$HOME/fzf"
}

function preexec_history() {
    cmd=$1
    echo "$cmd$(builtin pwd)" >> $history_all
    local history_dir="${history_basedir}$(builtin pwd)"
    mkdir -p $history_dir
    echo "$cmd" >> $history_dir/history
    history_session+="\n"$cmd
}

if which $(__fzfcmd_dev) >/dev/null 2>&1; then
    function fzf-history-widget() {
        local history_file="${history_basedir}$(builtin pwd)/history"
        if [ -e $history_file ]; then
            IFS=$'\n' local out=( \
                $(history | sed -e 's/^\s*\S\+\s*//' | tac | unique | grep -i "^$LBUFFER" | \
                FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=\"ctrl-r:toggle-sort\" $FZF_CTRL_R_OPTS +m --expect=ctrl-e" \
                $(__fzfcmd_dev)) \
            )
                #$(history | sed -e 's/^\s*\S\+\s*//' | tac | unique | grep -i "^$LBUFFER" | \
                #$(tac $history_all | sed -e 's/.\+$//' | unique | grep -i "^$LBUFFER" | \
                #$(echo -e $history_session | tac | unique | grep -i "^$LBUFFER" | \
                #$(tac $history_file | unique | grep -i "^$LBUFFER" | \
            local ret=$?
            local key=$(lines 1  <<< "$out")
            local cmd=$(lines 2: <<< "$out")
            if [ "$key" = "ctrl-e" ]; then
                BUFFER="$cmd"
                zle redisplay
                typeset -f zle-line-init >/dev/null && zle zle-line-init
                zle end-of-line
                return $ret
            else
                BUFFER="$out"
                zle redisplay
                typeset -f zle-line-init >/dev/null && zle zle-line-init
                zle accept-line
            fi
        fi
    }
    zle -N fzf-history-widget
    bindkey "^r" fzf-history-widget
fi

