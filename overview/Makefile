all: pdf

pdf: overview.pdf
md: generated/overview.md

overview.pdf: overview.tex
	pdflatex overview.tex

generated/overview.md: overview.tex
	pandoc -s overview.tex -o generated/overview.md

