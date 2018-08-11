" plugin置き場
set runtimepath+=~/.vim_local

let g:quickrun_config = {
\  "_": {
\    "runner" : "vimproc",
\    "hook/time/enable" : 1,
\    "outputter/buffer/split" : "botright",
\    "outputter/bufer/close_on_empty" : 1,
\  },
\}

