LIB_DIR="$dotfiles/zsh"

function override_backward-word() {
    if [ $CURSOR -gt 2 ] && [ "X$LBUFFER[-2,-1]" = "X /" ]; then
        zle backward-char
    else
        POS=$CURSOR
        zle backward-word
        if echo -n -- "$BUFFER[(($CURSOR+2)),$POS]" | grep '|' > /dev/null 2>&1; then
            LB=$LBUFFER
            RB=$RBUFFER
            RBUFFER='|'${RB#*|}
            LBUFFER=${LB}${RB%%|*}
        fi
    fi
}
zle -N override_backward-word

function override_forward-word() {
    if [ "X$RBUFFER[1]" = "X/" ]; then
        zle forward-char
    fi
    POS=$CURSOR
    zle forward-word
    if echo -n -- "$LBUFFER[(($POS+2)),-1]" | grep '|' > /dev/null 2>&1; then
        LB=$LBUFFER
        RB=$RBUFFER
        LBUFFER=${LB%|*}
        RBUFFER='|'${LB##*|}${RB}
    fi
    if echo -n -- "$LBUFFER[(($POS+2)),-1]" | grep '/' > /dev/null 2>&1; then
        LB=$LBUFFER
        RB=$RBUFFER
        LBUFFER=${LB%/*}
        RBUFFER='/'${LB##*/}${RB}
    fi
}
zle -N override_forward-word

function override_backward-kill-word() {
    zle set-mark-command
    zle override_backward-word
    zle kill-region
    if [ "X$LBUFFER[-1]" = "X/" ] && [ "X$RBUFFER[1]" = "X/" ]; then
        zle backward-delete-char
    fi
}
zle -N override_backward-kill-word

function override_backward-kill-blank-word() {
    zle set-mark-command
    zle vi-backward-blank-word
    zle kill-region
}
zle -N override_backward-kill-blank-word

function override_forward-kill-blank-word() {
    zle set-mark-command
    zle vi-forward-blank-word
    zle kill-region
}
zle -N override_forward-kill-blank-word

function kill-left-line() {
    zle set-mark-command
    zle beginning-of-line
    zle kill-region
}
zle -N kill-left-line

function override_expand-or-complete() {
    if [ ! -z $RBUFFER ] && [ "X$RBUFFER[1]" != "X " ]; then
        zle set-mark-command
        if [ "X$RBUFFER[1]" = "X/" ]; then
            zle forward-char
        fi
        if [ "X$RBUFFER[2]" != "X " ]; then
            zle vi-forward-blank-word-end
        fi
        zle forward-char
        zle kill-region
        CUTBUFFER=" $CUTBUFFER"
        zle vi-put-before
        if [ "X$LBUFFER[-1]" != "X " ]; then
            zle vi-backward-blank-word
        fi
        zle backward-char
    fi
    zle expand-or-complete
}
zle -N override_expand-or-complete

function readPathLink() {
    BUF_N=${#BUFFER}
    B=$(perl $LIB_DIR/readPathLink.pl "$BUFFER" $CURSOR)
    if [ ! -z $B ]; then
        BUFFER=$B
        CURSOR=$(($CURSOR + ${#BUFFER} - $BUF_N))
    fi
}
zle -N readPathLink

function expandByFzf() {
    BUFFER_LENGTH=$#BUFFER
    BUFFER=$(perl $LIB_DIR/expandByFzf.pl $BUFFER $CURSOR)
    CURSOR+=$(($#BUFFER - $BUFFER_LENGTH - 2))
    zle vi-forward-blank-word-end
    zle forward-char
    zle reset-prompt
}
zle -N expandByFzf

function copyBuffer() {
    clip <(echo -n $BUFFER)
}
zle -N copyBuffer

# 前の単語へ移動
bindkey ","    override_backward-word
# 次の単語へ移動
bindkey "."  override_forward-word
# 前のトークンへ移動
bindkey "<"    vi-backward-blank-word
# 次のトークンへ移動
bindkey ">"  vi-forward-blank-word
# 前の単語を削除
bindkey "^w"       override_backward-kill-word
# 前のトークンを削除
bindkey "^[8"    override_backward-kill-blank-word
# 次のトークンを削除
bindkey "^[9"    override_forward-kill-blank-word
# カーソルより左を削除
bindkey "^u"    kill-left-line
# 任意の位置から補完を行う
bindkey "^i"    override_expand-or-complete
# readPathLinkを適用する
bindkey "^@"    readPathLink
# ファイル選択にfzfを使う
bindkey "^[:"   expandByFzf
# charを検索して移動
bindkey "^]"    vi-find-next-char
# バッファの内容をコピー
bindkey "^d^b"  copyBuffer

