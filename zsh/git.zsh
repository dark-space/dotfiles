if which fzf >/dev/null 2>&1; then
    function fzf-git-add() {
        local selected
        selected=($($dotfiles/lib/unbuffer git status -s | grep -v '^[\d\dm[A-Z]' | fzf --no-sort --reverse --ansi --preview="git diff --color=always {2..}" --preview-window=up:80% -m | awk '{print $2}'))
        if [[ "$selected" =~ \\S ]]; then
            sed -e 's/\s\+/\n/g' -e 's/^/add /' <<< "$selected"
            git add $selected
        fi
    }
    alias ga='fzf-git-add'

    function fzf-git-branch() {
        local selected
        selected=$(git branch --color=always | fzf --no-sort --reverse --ansi | sed -e 's/^\s*\*\?\s\+//')
        if [[ "$selected" =~ \\S ]]; then
            git checkout $selected
        fi
    }
    alias gb='fzf-git-branch'

    function fzf-git-log-widget() {
        local selected
        selected=($(git log --graph --decorate --oneline --abbrev=40 --color=always | fzf --no-sort --reverse --ansi | grep -o '[0-9a-z]\{40\}'))
        if [[ "$selected" =~ \\S ]]; then
            BUFFER+="$selected"
            CURSOR=${#BUFFER}
            zle redisplay
            typeset -f zle-line-init >/dev/null && zle zle-line-init
        fi
    }
    zle -N fzf-git-log-widget
    bindkey "^g^l" fzf-git-log-widget

    function fzf-git-status-widget() {
        local selected
        selected=$($dotfiles/lib/unbuffer git status -sb | fzf --no-sort --reverse --ansi --preview="git diff --color=always {2..}" --preview-window=up:80%)
    }
    zle -N fzf-git-status-widget
    bindkey "^g^s" fzf-git-status-widget
else
    alias ga='git add'
    alias gb='git branch; git chechout'
fi

