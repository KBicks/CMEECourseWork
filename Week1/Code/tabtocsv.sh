#!/bin/bash
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: tabtocsv.sh
# Desc: Converts a tab delimited file to a comma delimited file (.csv) via substitution of tabs for commas.
# Arguments: 1 -> tab delimited file
# Date: 02 Oct 2018

echo "Creating a comma delimited version of $1 ..."
# cat to create new file, >> saves it to new file with name ending .csv
# tr replaces tabs in input file with commas
cat $1 | tr -s "\t" "," >> $1.csv
# states when completed
echo "Done!"
exit