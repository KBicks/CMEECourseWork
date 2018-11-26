#!/bin/bash
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: tiff2png.sh
# Desc: Converts tiff files to png files, using a for loop and imagemagick.
# Arguments: f-> .tiff file from command line
# Date: 07 Oct 2018

# for loop which converts each tiff file found to png files
for f in *.tif;
    do
        echo "Converting $f";
        convert "$f" "$(basename "$f" .tif).jpg";
    done
exit
