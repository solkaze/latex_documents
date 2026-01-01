# ==========================================
# LuaLaTeX Build Makefile
# ==========================================

# ------------------------------------------
# 設定 (Configuration)
# ------------------------------------------

# ビルド対象のメインファイル名（拡張子 .tex は不要）
# 例: main.tex なら "main" と記述
TARGET = main

# 使用するコマンド
LATEXMK = latexmk

# latexmk オプション設定
# settings.json の "Latexmk (LuaLaTeX)" 設定を反映
# -lualatex                : LuaLaTeX エンジンを使用
# -gg                      : 前回のビルド情報を破棄してクリーンビルド (Go Good)
# -synctex=1               : SyncTeX を有効化 (VS Code でのジャンプ機能用)
# -interaction=nonstopmode : エラー時に停止せず続行
# -file-line-error         : エラー箇所を「ファイル:行」形式で表示
# -f                       : エラーがあっても可能な限りPDF生成を試みる
# -outdir=.                : 出力先をカレントディレクトリに固定
FLAGS = -lualatex -gg -synctex=1 -interaction=nonstopmode -file-line-error -f -outdir=./out

# クリーンアップ対象ファイル
# settings.json の "clean.fileTypes" に含まれるが、
# latexmk -c だけでは消えない可能性のあるものを追加指定
EXTRA_CLEAN_FILES = *.synctex.gz *.nav *.snm *.vrb *.bcf *.run.xml *.xdv *.biber _minted*

# ------------------------------------------
# タスク定義 (Tasks)
# ------------------------------------------

.PHONY: all clean distclean check

# デフォルトターゲット: PDFをビルド
all: $(TARGET).pdf

# PDF生成ルール
# $< は依存ファイル(main.tex)、$@ はターゲット(main.pdf)を表します
$(TARGET).pdf: $(TARGET).tex
	$(LATEXMK) $(FLAGS) $<

# クリーンアップ (一時ファイルの削除)
# latexmk -c で一般的な中間ファイルを削除し、
# rm コマンドで残り(SyncTeXファイルなど)を削除します
clean:
	$(LATEXMK) -c
	rm -rf $(EXTRA_CLEAN_FILES)

# 完全削除 (PDF も含めて削除)
distclean: clean
	$(LATEXMK) -C

# 変更監視モード (Continuous Preview)
# ファイル変更を検知して自動ビルドし続けるモード (-pvc)
watch:
	$(LATEXMK) $(FLAGS) -pvc $(TARGET).tex
