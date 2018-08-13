if [[ $SHELL =~ bash$ ]]; then
    export CLI_APP_PATH=$HOME/cli
    if [ -e $HOME/.nimble/bin/nim ]; then
        export NIM_HOME=$HOME/.nimble
    fi

    if shopt -q login_shell; then
        if [ -f ~/.bashrc ]; then
            . ~/.bashrc
        fi
    fi
fi

