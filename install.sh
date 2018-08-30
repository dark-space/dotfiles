#!/bin/sh 

develop=false

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
    if [ ! -e volt/volt ]; then
        mkdir -p volt
        wget https://github.com/vim-volt/volt/releases/download/v0.3.4/volt-v0.3.4-linux-amd64 -O volt/volt
        chmod +x volt/volt
    fi
    if $develop; then
        volt/volt get https://github.com/zah/nim.vim
    fi
}

cli() {
    cd $HOME
    if $develop; then
        rm -fr cli
        git clone https://github.com/dark-space/cli
    fi
}

fzf() {
    cd $HOME
    EXTERNAL_APP_PATH=${EXTERNAL_APP_PATH:-$HOME/local}
    if ! which fzf >/dev/null 2>&1; then
        mkdir -p ${EXTERNAL_APP_PATH}/bin
        wget https://github.com/junegunn/fzf-bin/releases/download/0.17.4/fzf-0.17.4-linux_amd64.tgz
        tar xvf fzf-0.17.4-linux_amd64.tgz
        mv fzf ${EXTERNAL_APP_PATH}/bin
        rm -f fzf-0.17.4-linux_amd64.tgz
    fi
    if [ -e volt/volt ]; then
        volt/volt get https://github.com/junegunn/fzf
        ls -1d ~/.vim/pack/volt/opt/github.com_junegunn_fzf/* | grep -v 'plugin$' | xargs rm -fr
        volt/volt get https://github.com/junegunn/fzf.vim
    fi
}

nim() {
    cd $HOME
    if $develop; then
        if rm -fr /tmp/choosenim-0.3.2_linux_amd64 /tmp/untar-nim; then
            local count=0
            curl https://nim-lang.org/choosenim/init.sh -sSf > choosenim.sh
            while true; do
                sh choosenim.sh -y
                if [ $? -eq 0 ]; then
                    break
                fi
                count=$(($count + 1))
                if [ $count -ge 5 ]; then
                    echo "[41m[Error] Failed to installing nim.[0m"
                    break
                fi
            done
            rm -fr /tmp/choosenim-0.3.2_linux_amd64 /tmp/untar-nim
        fi
    fi
}


if [ $# -gt 0 ] && [ "$1" = "--dev" ]; then
    develop=true
    shift
fi
if [ $# -eq 0 ]; then
    dotfiles
    vim
    cli
    fzf
    nim
else
    while [ ! -z "$1" ]; do
        $1
        shift
    done
fi

