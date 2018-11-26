#!/bin/bash
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: csvtospace.sh
# Desc: Convert comma to space delimited files, via substitution of 
# commas for spaces, file taken from command line.
# Arguments: 1-> comma delimited file 
# Date: 08 Oct 2018

echo "Creating a space delimited version of $1"
# replaces commas with spaces for input file
cat $1 | tr -s "," " " >> $1.txt
echo "Done!"
exit