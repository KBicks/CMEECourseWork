#!/bin/bash
# Author: Katie Bickerton k.bickerton@imperial.ac.uk
# Script: CountLines.sh
# Desc: Counts lines in a file
# Arguments: NumLines -> Number of lines, 1-> file
# Date: 07 Oct 2018

NumLines=`wc -l < $1`
echo "The file $1 has $NumLines lines"
echo

exit 