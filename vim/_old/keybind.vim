inoremap <expr> <Tab> HybridTab()
inoremap <expr> [Z  HybridShiftTab()
inoremap <expr> /     HybridSlash()

function! HybridTab()
    if pumvisible()
        return ""
    endif
    if col(".") == 1
        return "	"
    endif
    let left = getline(".")[col(".")-2]
    if left == " " || left == "	"
        return "	"
    endif
    return ""
endfunction

function! HybridShiftTab()
    if pumvisible()
        return ""
    endif
    return "[Z"
endfunction

function! HybridSlash()
    if pumvisible()
        return ""
    endif
    return "/"
endfunction

