cd $HOME
for f in dotfiles/.??*; do
    if echo -n $f | grep '^.git' >/dev/null 2>&1; then
        continue
    fi
    rm -f $(basename $f)
    ln -s $f $(basename $f)
done
