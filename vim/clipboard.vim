function! Clipboard()
    let file = $HOME . "/clip"
    let lines = split(@", "\n")
    call writefile(lines, file)
    let ret = system('clip ' . file)
endfunction
nnoremap <silent> <Space>y :call Clipboard()<CR>
