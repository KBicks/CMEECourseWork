#!/bin/bash
# Compiles pdf from .tex files and bibliography from .bib files

pdflatex $1.tex
pdflatex $1.tex
bibtex $1
pdflatex $1.tex
pdflatex $1.tex
# Opens pdf viewer
evince $1.pdf &

##Cleanup
# Removes extra files generated during compilation
rm *~
rm *.aux
rm *.dvi
rm *.log
rm *.nav
rm *.out
rm *.snm
rm *.toc
rm *.blg
rm *.bbl