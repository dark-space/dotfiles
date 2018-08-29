function remove_windows_path() {
    local paths path ifs_tmp
    ifs_tmp=$IFS
    IFS=':' paths=($PATH); IFS=$ifs_tmp
    path=""
    for p in ${paths[@]}; do
        if [[ "$p" =~ ^/mnt/c/ ]]; then
            continue
        fi
        path+="$p:"
    done
    PATH=${path%:}
}

if [[ $SHELL =~ bash$ ]]; then
    export EXTERNAL_APP_PATH=$HOME/local
    if [ -e $HOME/.nimble/bin/nim ]; then
        export NIM_HOME=$HOME/.nimble
    fi

    remove_windows_path
    export PATH

    if shopt -q login_shell; then
        if [ -f ~/.bashrc ]; then
            . ~/.bashrc
        fi
    fi
fi

