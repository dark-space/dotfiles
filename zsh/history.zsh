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
    cmd=$(newline -z -r="\\n" <<< $1)
    cat <<< "$cmd$(builtin pwd)" >> $history_all
    local history_dir="${history_basedir}$(builtin pwd)"
    mkdir -p $history_dir
    cat <<< "$cmd" >> $history_dir/history
    history_session+="\n"$cmd
}

if which $(__fzfcmd_dev) >/dev/null 2>&1; then
    function read_history() {
        local type=$1
        if [ "$type" = "history" ]; then
            history | sed -e 's/^\s*\S\+\s*//' | tac | unique | grep -i "^$LBUFFER"
        elif [ "$type" = "directory" ]; then
            local history_here="${history_basedir}$(builtin pwd)/history"
            if [ ! -e $history_here ]; then
                mkdir -p $(dirname $history_here)
                touch $history_here
            fi
            tac $history_here | unique | grep -i "^$LBUFFER"
        elif [ "$type" = "all" ]; then
            tac $history_all | sed -e 's//\t[33m/' -e 's/$/[0m/' | unique | grep -i "^$LBUFFER"
        elif [ "$type" = "session" ]; then
            echo -e $history_session | tac | unique | grep -i "^$LBUFFER"
        fi
    }

    function fzf-history-widget() {
        local history_type=${HISTORY_TYPE:-"all"}
        while IFS=$'\n' local out=( \
            $(read_history $history_type | \
            FZF_DEFAULT_OPTS="--ansi --height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index $FZF_CTRL_R_OPTS +m --expect=ctrl-a,ctrl-e,ctrl-r,ctrl-d,ctrl-s,ctrl-h" \
            $(__fzfcmd_dev)) \
        ); do
            local ret=$?
            local key=$(lines 1  <<< "$out")
            if [ "$key" = "ctrl-a" ]; then
                BUFFER=$(lines 2: <<< "$out" | sed -e 's/\\n/\n/g')
                zle redisplay
                typeset -f zle-line-init >/dev/null && zle zle-line-init
                return $ret
            elif [ "$key" = "ctrl-e" ]; then
                BUFFER=$(lines 2: <<< "$out" | sed -e 's/\\n/\n/g')
                CURSOR=${#BUFFER}
                zle redisplay
                typeset -f zle-line-init >/dev/null && zle zle-line-init
                return $ret
            elif [ "$key" = "ctrl-r" ]; then
                history_type="all"
            elif [ "$key" = "ctrl-d" ]; then
                history_type="directory"
            elif [ "$key" = "ctrl-s" ]; then
                history_type="session"
            elif [ "$key" = "ctrl-h" ]; then
                history_type="history"
            else
                BUFFER=$(sed -e 's/\\n/\n/g' <<< "$out")
                zle redisplay
                typeset -f zle-line-init >/dev/null && zle zle-line-init
                zle accept-line
                break
            fi
        done
    }
    zle -N fzf-history-widget
    bindkey "^r" fzf-history-widget
fi

