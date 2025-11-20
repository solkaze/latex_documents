# LuaLaTeX を既定エンジンにする
$pdf_mode = 1;
$pdflatex = 'lualatex -synctex=1 -interaction=nonstopmode -halt-on-error %O %S';

# 必要なら platex 系を残してもいいが、Docker イメージに入れてなければ削除でOK
# $latex = 'uplatex %O -kanji=utf8 -no-guess-input-enc -synctex=1 -interaction=nonstopmode %S';

# biber を使う前提（jlreq + biblatexとか）
$biber  = 'biber %O --bblencoding=utf8 -u -U --output_safechars %B';

# 古典的 bibtex を使うなら（英語オンリーならこれで十分）
$bibtex = 'bibtex %O %B';

# インデックス（索引）作らないならコメントアウトでOK
# makeindex を使うなら（日本語索引までやるなら upmendex を入れて調整）
# $makeindex = 'makeindex %O -o %D %S';

# DVI 経由の設定は LuaLaTeXメインなら基本いらない
# $dvipdf = 'dvipdfmx %O -o %D %S';
# $dvips  = 'dvips %O -z -f %S | convbkmk -u > %D';
# $ps2pdf = 'ps2pdf %O %S %D';

# ビューア設定は Docker 内ではあまり意味ないのでコメントアウト推奨
# $pdf_previewer = "start %S";  # Windows 専用
