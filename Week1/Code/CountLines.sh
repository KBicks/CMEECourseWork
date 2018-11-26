#!/bin/bash
# Author: Katie Bickerton k.bickerton@imperial.ac.uk
# Script: CountLines.sh
# Desc: Counts lines in input file, file required from the command line.
# Arguments: NumLines -> Integer (line count value), 1-> file (from terminal)
# Date: 07 Oct 2018

# counts lines within file input from the command line
NumLines=`wc -l < $1`
# returns the result of the count, set to argument "Numlines"
echo "The file $1 has $NumLines lines"
echo

exit 