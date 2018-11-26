#!/bin/bash
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: ConcatenateTwoFiles.sh
# Desc: Merge two files input from the terminal, with resulting file name
# specified in the command line.
# Arguments: 1,2-> files to be merged, 3-> output file, all specified in the 
# command line.
# Date: 07 Oct 2018

# copies contents of file 1 onto new file 3 using >
cat $1 > $3
# appends file 3 with contents of file 2, using >> 
# which prevents overwritting other content 
cat $2 >> $3
echo "Merged File is"
# returns contents of merged file
cat $3

exit