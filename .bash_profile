# .bash_profile
#echo -n "bash_profile $- "
#shopt login_shell
if [[ $SHELL =~ bash$ ]]; then
    export MY_BIN_PATH=$HOME/bin
    if [[ $(cat /etc/issue) =~ Ubuntu ]]; then
        export MY_BIN_PATH_LOCAL=$HOME/usr/ubuntu/bin
    fi
    export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
    export MY_DEVELOP_PATH=$HOME/develop
    export MY_LIB_PATH=$HOME/Lib
    export MY_TOOL_PATH=$HOME/Tool

    PATH=$PATH:$HOME/.local/bin:$HOME/bin
    export PATH
    export LANGUAGE=ja_JP.UTF-8

    if shopt -q login_shell; then
        if [ -f ~/.bashrc ]; then
            . ~/.bashrc
        fi
    fi
fi

