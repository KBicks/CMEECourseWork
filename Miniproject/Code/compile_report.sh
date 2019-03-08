#!/bin/bash
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: compile_report.sh
# Desc: Compiles miniproject report as a pdf document from a .tex file (with bibliography from .bib file).
# Arguments: 1-> .tex file 
# Date: 02 Mar 2019

# Compiles pdf from .tex files and bibliography

pdflatex miniproject.tex
pdflatex miniproject.tex
bibtex miniproject.bib
pdflatex miniproject.tex
pdflatex miniproject.tex

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