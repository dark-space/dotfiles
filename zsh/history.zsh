#
# 独自のコマンドヒストリを作る
#
LIB_DIR="$dotfiles/zsh"
HISTORY_LIST="$HOME/.zsh_histories"
BASE_DIR="$HOME/.zsh_dir_history"

NEXT_BUFFER=""

function preexec_history() {
    DIR="${BASE_DIR}$(builtin pwd)"
    mkdir -p $DIR
    perl $LIB_DIR/formatCommandHistory.pl $1 $HISTORY_LIST "$DIR/history"
}

function precmd_history() {
    if [ ! -z $NEXT_BUFFER ]; then
        print -z $NEXT_BUFFER
    fi
    NEXT_BUFFER=""
}

bindkey "^r" history-incremental-pattern-search-backward

