function! PartEdit()
perl << EOF
    use lib "$ENV{MY_DEVELOP_PATH}/linux/partedit";
    use PartEdit;
    my @lines = $curbuf->Get(1 .. $curbuf->Count());
    our $partedit = PartEdit->new(\@lines);
    $partedit->editWQuoted();
    my @edit = @{$partedit->{edit}};
    $curbuf->Delete(1, $curbuf->Count());
    $curbuf->Append(0, @edit);
EOF
endfunction

function! PartEditMerge()
perl << EOF
    my @lines = $curbuf->Get(1 .. $curbuf->Count());
    $partedit->merge(\@lines);
    my @newLines = @{$partedit->{lines}};
    $curbuf->Delete(1, $curbuf->Count());
    $curbuf->Append(0, @newLines);
EOF
endfunction
