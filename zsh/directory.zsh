#
# 独自のディレクトリスタックを作る
#
directory_all=$HOME/.zsh/directory_all.txt
directory_session="$(builtin pwd)"

function __fzfcmd_dev() {
    echo "$HOME/fzf"
}

function chpwd_directory() {
    builtin pwd >> $directory_all
    directory_session+=$'\n'$(builtin pwd)
}

if which $(__fzfcmd_dev) >/dev/null 2>&1; then
    function read_directory() {
        local directory_type=$1
        if [ "$directory_type" = "all" ]; then
            tac $directory_all | unique
        elif [ "$directory_type" = "session" ]; then
            cat <<< $directory_session | unique
        fi
    }

    function fzf-directory-widget() {
        local directory_type=${DIRECTORY_TYPE:-"all"}
        while IFS=$'\n' local out=( \
            $(read_directory $directory_type | $(__fzfcmd_dev) --no-sort --ansi +m --expect=ctrl-d,ctrl-s --preview="cat <<< {} | cmdpack 'sed -e \"s/^/[44m/\" -e \"s/$/[0m/\"' 'xargs unbuffer ls --color=always | head'" --preview-window=up:30%)
        ); do
            local key=$(lines 1  <<< "$out")
            if [ "$key" = "ctrl-d" ]; then
                directory_type="all"
            elif [ "$key" = "ctrl-s" ]; then
                directory_type="session"
            else
                if [[ "$out" =~ \\S ]]; then
                    builtin cd "$out"
                    zle reset-prompt
                fi
                break
            fi
        done
    }
    zle -N fzf-directory-widget
    bindkey "^d" fzf-directory-widget
fi




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
