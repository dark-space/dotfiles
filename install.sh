cd $HOME

for f in dotfiles/.??*; do
    echo -n $f
    if echo -n $f | grep '^dotfiles/.git' >/dev/null 2>&1; then
        echo " o"
        continue
    else
        echo " x"
    fi
    rm -f $(basename $f)
    ln -s $f $(basename $f)
done

mkdir -p .vim/backup

