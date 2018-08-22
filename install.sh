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
    if $develop; then
        mkdir -p volt
        wget https://github.com/vim-volt/volt/releases/download/v0.3.4/volt-v0.3.4-linux-amd64 -O volt/volt
        chmod +x volt/volt
        volt/volt get https://github.com/zah/nim.vim
    fi
}

cli() {
    cd $HOME
    if $develop; then
        rm -fr cli
        git clone https://github.com/dark-space/cli
    else
        rm -fr cli
        git clone https://github.com/dark-space/cli cli-tmp
        mkdir -p cli
        mv cli-tmp/bin cli
        rm -fr cli-tmp
    fi
}

fzf() {
    cd $HOME
    EXTERNAL_APP_PATH=${EXTERNAL_APP_PATH:-$HOME/local}
    mkdir -p ${EXTERNAL_APP_PATH}/bin
    wget https://github.com/junegunn/fzf-bin/releases/download/0.17.4/fzf-0.17.4-linux_amd64.tgz
    tar xvf fzf-0.17.4-linux_amd64.tgz
    mv fzf ${EXTERNAL_APP_PATH}/bin
    rm -f fzf-0.17.4-linux_amd64.tgz
}

dotfiles
vim
cli
fzf

