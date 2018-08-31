let g:fzf_complete_path_options = ['--ansi', '--preview', g:dotfiles . '/zsh/lib/preview.zsh {}', '--preview-window', 'right:70%']
imap <S-Tab> <plug>(fzf-complete-path)

