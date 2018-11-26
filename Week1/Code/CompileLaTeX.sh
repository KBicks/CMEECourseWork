#!/bin/bash
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: CompileLaTeX.sh
# Desc: Compiles a pdf document (with bibliography) from a .tex file.
# Arguments: 1-> .tex file 
# Date: 08 Oct 2018

# Compiles pdf from .tex files and bibliography

pdflatex $1.tex
pdflatex $1.tex
bibtex $1
pdflatex $1.tex
pdflatex $1.tex
# Opens pdf viewer
evince $1.pdf &

## Cleanup
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