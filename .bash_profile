if [[ $SHELL =~ bash$ ]]; then
    export CLI_APP_PATH=$HOME/cli

    if shopt -q login_shell; then
        if [ -f ~/.bashrc ]; then
            . ~/.bashrc
        fi
    fi
fi

