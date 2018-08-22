let s:dotfiles = fnamemodify(resolve(expand('<sfile>:p')), ":h")
for file in split(glob(s:dotfiles . "/vim/*.vim"))
    exec 'source ' . file
endfor
