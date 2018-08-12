if [ $# -eq 0 ] && [[ $0 =~ ^- ]]; then
    dotfiles=$(dirname $(readlink -e ~/.zshrc))
else
    dotfiles=$(dirname $(readlink -e $0))
fi
for f in $dotfiles/zsh/*.zsh; do
    source $f
done

function zshaddhistory() {
}

function preexec() {
    preexec_history "$@"
    preexec_pipestatus "$@"
}

function chpwd() {
}

function precmd() {
    PIPESTATUS=$pipestatus
    precmd_history "$@"
    precmd_pipestatus $PIPESTATUS "$@"
}

