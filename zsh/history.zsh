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
        local history_type=$1
        if [ "$history_type" = "history" ]; then
            history | sed -e 's/^\s*\S\+\s*//' | tac | unique | grep -i "^$LBUFFER"
        elif [ "$history_type" = "directory" ]; then
            local history_here="${history_basedir}$(builtin pwd)/history"
            if [ ! -e $history_here ]; then
                mkdir -p $(dirname $history_here)
                touch $history_here
            fi
            tac $history_here | unique | grep -i "^$LBUFFER"
        elif [ "$history_type" = "all_there" ]; then
            cat -n $history_all | tac | unique -f=1 | sed -e 's//\t[44m/' -e 's/$/[0m/' | grep -i "^\s*[0-9]\+\s\+$LBUFFER"
        elif [ "$history_type" = "all" ]; then
            sed -e 's/.*$//' $history_all | tac | unique | grep -i "^$LBUFFER"
        elif [ "$history_type" = "session" ]; then
            echo -e $history_session | tac | unique | grep -i "^$LBUFFER"
        fi
    }

    function __set_buffer() {
        if [ "$1" = "all_there" ]; then
            BUFFER=$(lines $(awk '{print $1}' <<< "$2") $history_all | sed -e 's/^\(.*\)\([^]\+\)$/(cd "\2" \&\& \1)/' -e 's/\\n/\n/g')
        else
            BUFFER=$(sed -e 's/\\n/\n/g' <<< "$2")
        fi
    }

    function fzf-history-widget() {
        local query=""
        local fzf_default_opts="--query=\"$query\" --print-query --no-sort --ansi +m --expect=ctrl-m,ctrl-a,ctrl-e,ctrl-r,ctrl-d,ctrl-s,ctrl-h,ctrl-t "
        local history_type=${HISTORY_TYPE:-"all"}
        while IFS=$'\n' local out=( \
            $(read_history $history_type | FZF_DEFAULT_OPTS=$fzf_default_opts $(__fzfcmd_dev))
        ); do
            cat <<< "$out" > ~/dotfiles/debug.txt
            query=$(lines 1 <<< "$out")
            if [[ "$query" =~ ^ctrl- ]]; then
                local key="$query"
                query=""
                out=$(lines 2.. <<< "$out")
            else
                local key=$(lines 2 <<< "$out")
                out=$(lines 3.. <<< "$out")
            fi
            fzf_default_opts="--query=\"$query\" --print-query --no-sort --ansi +m --expect=ctrl-m,ctrl-a,ctrl-e,ctrl-r,ctrl-d,ctrl-s,ctrl-h,ctrl-t "
            if [ "$key" = "ctrl-a" ]; then
                __set_buffer $history_type "$out"
                zle redisplay
                typeset -f zle-line-init >/dev/null && zle zle-line-init
            elif [ "$key" = "ctrl-e" ]; then
                __set_buffer $history_type "$out"
                CURSOR=${#BUFFER}
                zle redisplay
                typeset -f zle-line-init >/dev/null && zle zle-line-init
            elif [ "$key" = "ctrl-r" ]; then
                history_type="all"
            elif [ "$key" = "ctrl-d" ]; then
                history_type="directory"
            elif [ "$key" = "ctrl-s" ]; then
                history_type="session"
            elif [ "$key" = "ctrl-h" ]; then
                history_type="history"
            elif [ "$key" = "ctrl-t" ]; then
                history_type="all_there"
                fzf_default_opts+="--preview=\"lines {1} $history_all | sed -e 's/^.*//' | cmdpack 'sed -e \"s/^/[44m/\" -e \"s/$/[0m/\"' 'xargs unbuffer ls --color=always | head'\" --preview-window=up:30% "
            elif [ "$key" = "ctrl-m" ]; then
                __set_buffer $history_type "$out"
                zle redisplay
                typeset -f zle-line-init >/dev/null && zle zle-line-init
                zle accept-line
                break
            else
                break
            fi
        done
    }
    zle -N fzf-history-widget
    bindkey "^r" fzf-history-widget
fi

