#!/bin/bash
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: tabtocsv.sh
# Desc: substitute the tabs in the files with commas, saves the output into a .csv file
# Arguments: 1-> tab delimited file
# Date: 02 Oct 2018

echo "Creating a comma delimited version of $1 ..."
# Replace tabs with commas
cat $1 | tr -s "\t" "," >> $1.csv
echo "Done!"
exit