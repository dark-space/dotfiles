function __fzfcmd_dev() {
    echo "$HOME/fzf"
}

if which $(__fzfcmd_dev) >/dev/null 2>&1; then
    function fzf-git-widget() {
        local selected=($(unbuffer git status -sb | $(__fzfcmd_dev) --reverse --ansi --preview="git diff --color=always {2..}" --preview-window=up:80% -m | grep -v '^##' | sed -e 's/^ \+//' | columns -S 2:))
        if [[ "$selected" =~ \\S ]]; then
            BUFFER="git add $selected"
            zle redisplay
            typeset -f zle-line-init >/dev/null && zle zle-line-init
            zle accept-line
        fi
    }
    zle -N fzf-git-widget
    bindkey "^g^a" fzf-git-widget

    function fzf-git-log-widget() {
        local selected=($(git log --graph --decorate --oneline --abbrev=40 --color=always | $(__fzfcmd_dev) --reverse --ansi | grep -o '[0-9a-z]\{40\}'))
        if [[ "$selected" =~ \\S ]]; then
            BUFFER+="$selected"
            CURSOR=${#BUFFER}
            zle redisplay
            typeset -f zle-line-init >/dev/null && zle zle-line-init
        fi
    }
    zle -N fzf-git-log-widget
    bindkey "^g^l" fzf-git-log-widget
fi

