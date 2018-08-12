LIB_DIR="$dotfiles/zsh"

PRE_COMMAND=""

function preexec_pipestatus() {
    PRE_COMMAND=$1
}

function precmd_pipestatus() {
    PIPESTATUS=$1
    if [ ! -z $PRE_COMMAND ]; then
        STATUS=$(perl $LIB_DIR/returnStatus.pl $PIPESTATUS)
        if [ $STATUS -eq 0 ]; then
            PROMPT=$'\n'$fg[white]"@END %D %* ["${PRE_COMMAND}"]"${reset_color}
            PROMPT+=$'\n'$PROMPT_STR
        elif [ $STATUS -eq 1 ]; then
            PROMPT=$'\n'$fg[cyan]"@END %D %* ["${PRE_COMMAND}"]=>["${PIPESTATUS}"]"${reset_color}
            PROMPT+=$'\n'$PROMPT_STR
        else
            PROMPT=$'\n'$fg[red]"@END %D %* ["${PRE_COMMAND}"]=>["${PIPESTATUS}"]"${reset_color}
            PROMPT+=$'\n'$PROMPT_STR
        fi
    fi
}

