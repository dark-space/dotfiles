#
# 独自のディレクトリスタックを作る
#
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

