function! TsvEdit(c)
perl << EOF
    my $column = VIM::Eval('a:c');
    use lib "$ENV{MY_LIB_PATH}/perl";
    use Tsv;
    my @lines = $curbuf->Get(1 .. $curbuf->Count());
    our $tsv = Tsv->new();
    $tsv->addFromTextLines(\@lines);
    if ($tsv->hasColumn($column)) {
        my @array = $tsv->getColumnArray($column);
        $curbuf->Delete(1, $curbuf->Count());
        $curbuf->Append(0, $column);
        $curbuf->Append(1, @array);
    }
EOF
endfunction

function! TsvLegends()
perl << EOF
    foreach ($tsv->getLegendArray()) {
        print "$_\n";
    }
EOF
endfunction

