" filetypeによるplugin,indentの設定ファイルを読み込む
filetype plugin indent on
" 書き込み権限がないとき、!をつけても上書きしない
set cpoptions+=W
" 折り返したときは行番号の部分にも描画する
set cpoptions+=n
" 現在のバッファに変更があっても他のバッファに移れる
set hidden
" 行番号を表示
set number
" 保存したとき、前の保存状態をバックアップする
set backup
" バックアップ場所
set backupdir=~/.vim/backup
" エンコーディング
set fileencodings=utf-8,cp932
" インクリメンタルサーチ
set incsearch
" 検索文字をハイライト
set hlsearch
" タブなどに対して薄く文字を表示する
set list
" 表示する文字の設定
set listchars=tab:>\ ,trail:_,nbsp:%
" Ctrl+aのインクリメントを必ず10進数にする
set nrformats=
" 折り返ししない
set nowrap
" ステータスラインを常に表示する
set laststatus=2
" ステータスラインにフルパスを表示する
set statusline=%m%F%=\ [%{&fileencoding}/%{&fileformat}]
" インデントもBSで消せる
set backspace=indent,eol,start
" タブを押したらスペースで埋める
set expandtab
" タブは4文字
set tabstop=4
" 自動挿入されるタブも4文字
set shiftwidth=4
" 先頭の空白だけBackspaceでタブのように消す
set smarttab
" タブインデント行を<<した時に空白にしない
set preserveindent
" タブインデント行の次はタブにする。が効いていない？
set copyindent
" ファイル名補完では大文字小文字を区別しない
set fileignorecase
" 補完のとき、まずは最長マッチかつリスト出力、次から順に候補を選ぶ
set wildmode=list:longest,full
" =はファイル名を表す文字列と解釈しない
set isfname-=\=
" ctagsの場所
set tags+=~/.tags
" mapleaderの設定
let mapleader = " "

" カラーリング
autocmd ColorScheme * highlight Comment ctermfg=7 ctermbg=4
colorscheme default

nnoremap // I#<Esc>
nnoremap * *zz
nnoremap # #zz
nnoremap n nzz
nnoremap N Nzz
nnoremap [b :bp<CR>
nnoremap ]b :bn<CR>
nnoremap <Leader><CR> V:!sh<CR>

inoremap <C-c> <ESC>
inoremap <C-b> <Left>
inoremap <C-f> <Right>

cnoremap <C-a> <C-b>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>

vnoremap * y/<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>
vnoremap <Leader><CR> :!sh<CR>

