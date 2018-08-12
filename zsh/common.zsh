# screen用に環境変数SHELLを設定
export SHELL=$(which zsh)
# 環境変数の設定
export PATH_CLEAN=${PATH_CLEAN-$PATH}
export PATH=.:${MY_TOOL_PATH}:${MY_BIN_PATH}:$HOME/.nimble/bin:${JAVA_HOME}/bin:${PATH}
# PATH の重複を消去する
typeset -U path
# プロンプトの設定
autoload -U colors
colors
PROMPT_STR="[%{$fg[green]%}%n@%m %{$fg[yellow]%}%d%{$reset_color%}]"$'\n'"$ "
PROMPT=$PROMPT_STR
# 言語設定
export ENCODING="utf8"

# zsh の補完機能を使うおまじない
autoload -Uz compinit
compinit
# 補完候補にも色を付ける
zstyle ':completion:*' list-colors 'di=34;1'
# ファイル名の途中でも補完候補とし、小文字は大文字としても検索
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' '+l:|=* r:|=*'
# _から始まる補完関数を補完候補にしない
zstyle ':completion::complete:-command-::' tag-order !functions
# Ctrl+s （ターミナルロック）を無効化
stty stop undef
# Ctrl+d でターミナルを閉じないようにする
setopt IGNOREEOF
# ヒストリはシェルとして共有する
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt share_history
# 特殊文字の中で「単語」の境界として扱う文字を指定
WORDCHARS="*?.-_[]~&;!#$%^(){}<>"
# ls で詰めて表示する
setopt list_packed
# 日本語表示がうまくいきますように…
setopt print_eight_bit
# ヒストリにはスペースなどを整形した状態で保存する
setopt hist_reduce_blanks
# 直前と同じヒストリは記録しない
setopt hist_ignore_dups
# コマンドラインでも # でコメントを書く
setopt interactive_comments

# deleteキーを使えるようにする
bindkey "^[[3~" delete-char
# Shift-Tabで補完候補を逆順に回す
bindkey "\e[Z"  reverse-menu-complete

# 一つ上のディレクトリへ移動
function cd_up() {
    cd ..
    zle reset-prompt
}
zle -N cd_up
bindkey "^d^u" cd_up

# alias
alias ls='ls --color'
alias grep='grep --color'
alias sort='LANG=C sort'
alias vim="sh $dotfiles/zsh/tovim.sh"
alias now='date +%Y%m%d_%H%M%S_%3N'

