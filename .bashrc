if [ $# -eq 0 ] && [[ "$0" =~ ^- ]]; then
    dotfiles=$(dirname $(readlink -e ~/.bashrc))
else
    dotfiles=$(dirname $(readlink -e $0))
fi

if ! shopt -q login_shell; then
    if [ -f ~/.bash_profile ]; then
        . ~/.bash_profile
    fi
fi

if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

if grep '^Ubuntu' >/dev/null 2>&1 < /etc/issue; then
    if [ -f $dotfiles/bash/ubuntu.bash ]; then
        . $dotfiles/bash/ubuntu.bash
    fi
fi

if [[ $- =~ i ]] || [ -n $INTERACTIVE_APP ]; then
    PATH=.:${MY_TOOL_PATH}:${MY_BIN_PATH}:${JAVA_HOME}/bin:${PATH}
    unset INTERACTIVE_APP
fi

if [[ $- =~ i ]]; then
    PS1="[\u@\h \w]\n\$ "
    LS_COLORS='di=34;1'
    alias ls='ls --color'
    alias d='dirs -v'
    alias sort='LANG=C sort'
    alias j='tmux new-window -c $PWD; tmux a'
fi

