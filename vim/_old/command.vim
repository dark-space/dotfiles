command! -nargs=* PartEdit      %!partEdit <args>
command! -nargs=* MergePartEdit %!partEditMerge <args>
command! -nargs=* HideHeader    %!hidePartHeader <args>
command! -range=% Expand        execute "normal msHmt:<line1>,<line2>!tab2space -n " . &tabstop . "<CR>'tzt`s"
command! -nargs=1 Quote         r!grep -i <args> % | head -n 1

