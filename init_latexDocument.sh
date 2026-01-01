#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat >&2 <<'USAGE'
Usage:
  ./init_latexDocument.sh <name>
  ./init_latexDocument.sh <dir> <name>

Creates under:
  <script_dir>/doc/<...>

Examples:
  ./init_latexDocument.sh Report        -> doc/Report/Report.tex
  ./init_latexDocument.sh School Report -> doc/School/Report/Report.tex
  ./init_latexDocument.sh School/Report -> doc/School/Report/Report.tex
USAGE
}

# スクリプトが置いてある場所を基準にする
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOC_ROOT="${SCRIPT_DIR}/doc"

if [ "$#" -eq 1 ]; then
  rel_path="$1"
elif [ "$#" -eq 2 ]; then
  rel_path="$1/$2"
else
  usage
  exit 1
fi

# 末尾の / を除去（"XXXX/" 対策）
rel_path="${rel_path%/}"

if [ -z "$rel_path" ]; then
  echo "Error: project path is empty." >&2
  exit 1
fi

project_dir="${DOC_ROOT}/${rel_path}"
target_name="$(basename "$rel_path")"

tex_file="${project_dir}/${target_name}.tex"
make_file="${project_dir}/Makefile"
out_dir="${project_dir}/out"

mkdir -p "$project_dir"
mkdir -p "$out_dir"

if [ -e "$tex_file" ] || [ -e "$make_file" ]; then
  {
    echo "Error: already exists:" >&2
    if [ -e "$tex_file" ]; then
      echo "  - $tex_file" >&2
    fi
    if [ -e "$make_file" ]; then
      echo "  - $make_file" >&2
    fi
  }
  exit 1
fi

cat > "$tex_file" <<EOF
\\documentclass[
  a4paper,10pt,
  line_length=48zw,
  number_of_lines=48
]{jlreq}

\\title{$target_name}
\\author{}
\\date{\\today}

\\begin{document}
\\maketitle

\\section{Introduction}
Hello, LaTeX.

\\end{document}
EOF

cat > "$make_file" <<EOF
# ==========================================
# LuaLaTeX Build Makefile
# ==========================================

# ------------------------------------------
# 設定 (Configuration)
# ------------------------------------------

# ビルド対象のメインファイル名（拡張子 .tex は不要）
TARGET = $target_name

# 使用するコマンド
LATEXMK = latexmk

# latexmk オプション設定
FLAGS = -lualatex -gg -synctex=1 -interaction=nonstopmode -file-line-error -f -outdir=./out

# クリーンアップ対象ファイル
EXTRA_CLEAN_FILES = *.synctex.gz *.nav *.snm *.vrb *.bcf *.run.xml *.xdv *.biber _minted*

# ------------------------------------------
# タスク定義 (Tasks)
# ------------------------------------------

.PHONY: all clean distclean check watch

all: \$(TARGET).pdf

\$(TARGET).pdf: \$(TARGET).tex
	\$(LATEXMK) \$(FLAGS) \$<

clean:
	\$(LATEXMK) -c
	rm -rf \$(EXTRA_CLEAN_FILES)

distclean: clean
	\$(LATEXMK) -C

watch:
	\$(LATEXMK) \$(FLAGS) -pvc \$(TARGET).tex
EOF

echo "Created:"
echo "  dir : $project_dir"
echo "  tex : $tex_file"
echo "  make: $make_file"
echo "  out : $out_dir"
