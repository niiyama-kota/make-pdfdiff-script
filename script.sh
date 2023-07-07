git init

touch ./.gitconfig
echo "[alias]
    ldiff = !sh -c 'latexdiff-vc --git --force -d diff -r "\${1:-HEAD}" main.tex && cd diff && latexmk' -

    prediff = !sh -c 'latexdiff-vc --git --force -d diff -r HEAD~ main.tex && cd diff && mv ./main.tex diff.tex && latexmk' -" > ./.gitconfig

touch ./.git/hooks/pre-commit
echo "#!/bin/sh


printf '\033[1;30;42m%s\033[m\n' 'Making diff.tex'
git prediff
# git add ./diff/diff.tex
git add .
" > ./.git/hooks/pre-commit

touch ./.latexmkrc
echo "#!/usr/bin/env perl

# LaTeX
\$latex = 'platex -kanji=utf8 -synctex=1 -halt-on-error -file-line-error --shell-escape %O %S';
\$max_repeat = 5;

# BibTeX
\$bibtex = 'pbibtex %O %S';
\$biber = 'biber --bblencoding=utf8 -u -U --output_safechars %O %S';

# index
\$makeindex = 'mendex %O -o %D %S';

# DVI / PDF
\$dvipdf = 'dvipdfmx %O -o %D %S';
\$pdf_mode = 3;

# preview
\$pvc_view_file_via_temporary = 0;
if ($^O eq 'linux') {
    \$dvi_previewer = "xdg-open %S";
    \$pdf_previewer = "xdg-open %S";
} elsif ($^O eq 'darwin') {
    \$dvi_previewer = "open %S";
    \$pdf_previewer = "open %S";
} else {
    \$dvi_previewer = "start %S";
    \$pdf_previewer = "start %S";
}

# clean up
\$clean_full_ext = "%R.synctex.gz"" > ./.latexmkrc
