#!/bin/bash
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: csvtospace.sh
# Desc: change csv to space delimited files, via substitution of commas for spaces
# Arguments: 1-> comma delimited file 
# Date: 08 Oct 2018

echo "Creating a space delimited version of $1"
# replaces commas with spaces
cat $1 | tr -s "," " " >> $1.txt
echo "Done!"
exit