#
# 独自のディレクトリスタックを作る
#
directory_all=$HOME/.zsh/directory_all.txt
directory_session="$(builtin pwd)"
directory_index=1

function __add_directory_session() {
    if [ $# -gt 0 ]; then
        directory_session=$(lines :-1 <<< $directory_session)
        directory_index=$1
    else
        directory_session+=$'\n'$(builtin pwd)
        directory_index=$(wc -l <<< $directory_session)
    fi
}

function chpwd_directory() {
    builtin pwd >> $directory_all
    __add_directory_session
}

if which fzf >/dev/null 2>&1; then
    function read_directory() {
        local directory_type
        directory_type=$1
        if [ "$directory_type" = "all" ]; then
            tac $directory_all | unique
        elif [ "$directory_type" = "session" ]; then
            tac <<< $directory_session | unique
        fi
    }

    function fzf-directory-widget() {
        local directory_type query out
        directory_type=${DIRECTORY_TYPE:-"all"}
        query=""
        while out=$(read_directory $directory_type | fzf --query="$query" --print-query --no-sort --ansi +m --expect=ctrl-c,ctrl-d,ctrl-s --preview="cat <<< {} | cmdpack 'sed -e \"s/^/[44m/\" -e \"s/$/[0m/\"' 'xargs $dotfiles/lib/unbuffer ls --color=always | head'" --preview-window=up:30%); do
            local key selected
            query=$(lines 1 <<< "$out")
            key=$(lines 2 <<< "$out")
            selected=$(lines 3: <<< "$out")
            if [ "$key" = "ctrl-d" ]; then
                directory_type="all"
            elif [ "$key" = "ctrl-s" ]; then
                directory_type="session"
            elif [ "$key" = "ctrl-c" ]; then
                BUFFER="$query"
                CURSOR=${#BUFFER}
                zle redisplay
                typeset -f zle-line-init >/dev/null && zle zle-line-init
                break
            else
                builtin cd "$selected"
                zle reset-prompt
                break
            fi
        done
    }
    zle -N fzf-directory-widget
    bindkey "^d^d" fzf-directory-widget

    function cd_prev() {
        local prev_index
        prev_index=$(($directory_index - 1))
        if [ $prev_index -gt 0 ]; then
            if builtin cd $(lines $prev_index <<< $directory_session); then
                zle reset-prompt
                __add_directory_session $prev_index
            fi
        fi
    }
    zle -N cd_prev
    bindkey "^d^p" cd_prev

    function cd_next() {
        local next_index
        next_index=$(($directory_index + 1))
        if [ $next_index -le $(wc -l <<< $directory_session) ]; then
            if builtin cd $(lines $next_index <<< $directory_session); then
                zle reset-prompt
                __add_directory_session $next_index
            fi
        fi
    }
    zle -N cd_next
    bindkey "^d^n" cd_next
fi

