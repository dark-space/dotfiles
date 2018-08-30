let g:dotfiles = fnamemodify(resolve(expand('<sfile>:p')), ":h")
for file in split(glob(g:dotfiles . "/vim/*.vim"))
    exec 'source ' . file
endfor
