function __fzfcmd_dev() {
    echo "$HOME/fzf"
}

if which $(__fzfcmd_dev) >/dev/null 2>&1; then
    function fzf-git-widget() {
        local selected=($(unbuffer git status -sb | $(__fzfcmd_dev) --reverse --ansi --preview="git diff --color=always {2..}" --preview-window=up:80% -m | columns -S 2:))
        if [[ "$selected" =~ \\S ]]; then
            BUFFER="git add $selected"
            CURSOR=${#BUFFER}
            zle redisplay
            typeset -f zle-line-init >/dev/null && zle zle-line-init
        fi
    }
    zle -N fzf-git-widget
    bindkey "^g^i^t" fzf-git-widget
fi

