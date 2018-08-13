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

nim() {
    cd $HOME
    if ! $develop; then
        return
    fi
    if [ -e $HOME/.nimble ]; then
        return
    fi
    wget https://nim-lang.org/download/nim-0.18.0.tar.xz
    tar xvf nim-0.18.0.tar.xz
    cd nim-0.18.0
    sh build.sh
    bin/nim c koch
    ./koch tools
    mkdir -p $HOME/.nimble
    mv bin $HOME/.nimble
    cd -
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
        mkdir -p cli
        #Download bin
    fi
}


dotfiles
nim
vim
cli
