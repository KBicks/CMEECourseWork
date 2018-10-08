#!/bin/bash
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: tiff2png.sh
# Desc: convert tiff files to png files
# Arguments: f-> .tiff
# Date: 07 Oct 2018

for f in *.tif;
    do
        echo "Converting $f";
        convert "$f" "$(basename "$f" .tif).jpg";
    done
exit
