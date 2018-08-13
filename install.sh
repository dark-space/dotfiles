#!/bin/sh 

develop=false
if [ $# -gt 0 ] && [ "$1" = "--dev" ]; then
    develop=true
fi

dotfiles() {
    cd $HOME
    for f in dotfiles/.??*; do
        if echo -n $f | grep '^dotfiles/.git' >/dev/null 2>&1; then
            continue
        fi
        rm -f $(basename $f)
        ln -s $f $(basename $f)
    done
}

vim() {
    cd $HOME
    mkdir -p .vim/backup
}

cli() {
    cd $HOME
    if $develop; then
        git clone https://github.com/dark-space/cli
        mkdir -p cli/bin
        sh cli/CompileAll.sh
    else
    echo "Not yet implemented"
    fi
}


dotfiles
vim
cli
