#!/bin/bash
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: ConcatenateTwoFiles.sh
# Desc: Merge two files
# Arguments: 1,2-> files to be merged, 3-> output file
# Date: 07 Oct 2018

cat $1 > $3
cat $2 >> $3
echo "Merged File is"
cat $3

exit