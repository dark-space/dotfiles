#
# 独自のディレクトリスタックを作る
#
directory_all=$HOME/.zsh/directory_all.txt
directory_session=""

function __fzfcmd_dev() {
    echo "$HOME/fzf"
}

function chpwd_directory() {
    builtin pwd >> $directory_all
    directory_session+="\n"$(builtin pwd)
}

if which $(__fzfcmd_dev) >/dev/null 2>&1; then
fi

#    function read_history() {
#        local history_type=$1
#        if [ "$history_type" = "history" ]; then
#            history | sed -e 's/^\s*\S\+\s*//' | tac | unique | grep -i "^$LBUFFER"
#        elif [ "$history_type" = "directory" ]; then
#            local history_here="${history_basedir}$(builtin pwd)/history"
#            if [ ! -e $history_here ]; then
#                mkdir -p $(dirname $history_here)
#                touch $history_here
#            fi
#            tac $history_here | unique | grep -i "^$LBUFFER"
#        elif [ "$history_type" = "all_there" ]; then
#            cat -n $directory_all | tac | unique -f=1 | sed -e 's//\t[44m/' -e 's/$/[0m/' | grep -i "^\s*[0-9]\+\s\+$LBUFFER"
#        elif [ "$history_type" = "all" ]; then
#            sed -e 's/.*$//' $directory_all | tac | unique | grep -i "^$LBUFFER"
#        elif [ "$history_type" = "session" ]; then
#            echo -e $directory_session | tac | unique | grep -i "^$LBUFFER"
#        fi
#    }
#
#    function __set_buffer() {
#        if [ "$1" = "all_there" ]; then
#            BUFFER=$(lines $(awk '{print $1}' <<< "$2") $directory_all | sed -e 's/^\(.*\)\([^]\+\)$/(cd "\2" \&\& \1)/' -e 's/\\n/\n/g')
#        else
#            BUFFER=$(sed -e 's/\\n/\n/g' <<< "$2")
#        fi
#    }
#
#    function fzf-history-widget() {
#        local fzf_default_opts="--no-sort --ansi +m --expect=ctrl-a,ctrl-e,ctrl-r,ctrl-d,ctrl-s,ctrl-h,ctrl-t "
#        local history_type=${HISTORY_TYPE:-"all"}
#        while IFS=$'\n' local out=( \
#            $(read_history $history_type | FZF_DEFAULT_OPTS=$fzf_default_opts $(__fzfcmd_dev))
#        ); do
#            local ret=$?
#            fzf_default_opts="--no-sort --ansi +m --expect=ctrl-a,ctrl-e,ctrl-r,ctrl-d,ctrl-s,ctrl-h,ctrl-t "
#            local key=$(lines 1  <<< "$out")
#            if [ "$key" = "ctrl-a" ]; then
#                out=$(lines 2 <<< "$out")
#                __set_buffer $history_type "$out"
#                zle redisplay
#                typeset -f zle-line-init >/dev/null && zle zle-line-init
#                return $ret
#            elif [ "$key" = "ctrl-e" ]; then
#                out=$(lines 2 <<< "$out")
#                __set_buffer $history_type "$out"
#                CURSOR=${#BUFFER}
#                zle redisplay
#                typeset -f zle-line-init >/dev/null && zle zle-line-init
#                return $ret
#            elif [ "$key" = "ctrl-r" ]; then
#                history_type="all"
#            elif [ "$key" = "ctrl-d" ]; then
#                history_type="directory"
#            elif [ "$key" = "ctrl-s" ]; then
#                history_type="session"
#            elif [ "$key" = "ctrl-h" ]; then
#                history_type="history"
#            elif [ "$key" = "ctrl-t" ]; then
#                history_type="all_there"
#                fzf_default_opts+="--preview=\"lines {1} $directory_all | sed -e 's/^.*//' | cmdpack 'sed -e \"s/^/[44m/\" -e \"s/$/[0m/\"' 'xargs unbuffer ls --color=always | head'\" --preview-window=up:30%"
#            else
#                __set_buffer $history_type "$out"
#                zle redisplay
#                typeset -f zle-line-init >/dev/null && zle zle-line-init
#                zle accept-line
#                break
#            fi
#        done
#    }
#    zle -N fzf-history-widget
#    bindkey "^r" fzf-history-widget
#fi




old() {
LIB_DIR="$dotfiles/zsh"
DIR_STACK="$HOME/.zsh_dirs"
PROC_DIR="$HOME/.zsh_proc/`hostname -s`-$$"
PROC_DIR_STACK="$PROC_DIR/dirs"
INDEX=0

# 最初の処理
{
    mkdir -p $PROC_DIR
    touch $DIR_STACK
    tail -n 49 $DIR_STACK > $PROC_DIR_STACK
    builtin pwd | tee -a $DIR_STACK >> $PROC_DIR_STACK
    INDEX=0
}

# cdされたら行う動作
function cd() {
    # 普通のcd をする
    builtin cd $@
    # cd が正常に行われた場合
    RESULT=$?
    if [ $RESULT -ne 0 ]; then
        return $RESULT
    fi
    # 新しいパスをファイルに書き込む
    builtin pwd | tee -a $DIR_STACK >> $PROC_DIR_STACK
    # パスのidnexを0に設定
    INDEX=0
}

function cd_move() {
    perl $LIB_DIR/unique.pl $PROC_DIR_STACK > ${PROC_DIR_STACK}.tmp
    TARGET=$1
    # パスリストからパスを取得
    TO=$(perl $LIB_DIR/getPath.pl ${PROC_DIR_STACK}.tmp $TARGET)
    # TARGETが範囲外だったら空文字列を返す
    if [ ! -z $TO ]; then
        builtin cd $TO
        # cd が正常に行われた場合
        if [ $? -eq 0 ]; then
            zle reset-prompt
            INDEX=$TARGET
        fi
    fi
}

function cd_prev() {
    cd_move $(($INDEX + 1))
}
zle -N cd_prev

function cd_next() {
    cd_move $(($INDEX - 1))
}
zle -N cd_next

function directoryProc() {
    LIST=$(perl $LIB_DIR/showList.pl $PROC_DIR_STACK | tac)
    if [ $? -ne 0 ]; then
        return 1
    fi
    TO=$(echo $LIST | fzf -e --border --height 50% --select-1)
    if [ ! -z $TO ]; then
        builtin cd $TO
        # cd が正常に行われた場合
        if [ $? -eq 0 ]; then
            zle reset-prompt
            INDEX=$TARGET
        fi
    fi
}
zle -N directoryProc
bindkey "^d^h"  directoryProc

function directoryAll() {
    LIST=$(perl $LIB_DIR/showList.pl $DIR_STACK | tac)
    if [ $? -ne 0 ]; then
        return 1
    fi
    TO=$(echo $LIST | fzf -e --border --height 50% --select-1)
    if [ ! -z $TO ]; then
        builtin cd $TO
        # cd が正常に行われた場合
        if [ $? -eq 0 ]; then
            zle reset-prompt
            INDEX=$TARGET
        fi
    fi
}
zle -N directoryAll
bindkey "^d^a"  directoryAll


# 前のディレクトリに戻る
bindkey "^d^p"  cd_prev
# 次のディレクトリに進む
bindkey "^d^n"  cd_next
}
