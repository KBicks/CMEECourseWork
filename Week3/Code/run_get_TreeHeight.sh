#!/bin/bash
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: run_get_TreeHeight.sh
# Desc: Runs get_TreeHeight.sh, using trees.csv as the input file.
# Arguments: Input -> csv file
# Date: 23 Oct 2018

# sets input file
Input="../Data/trees.csv"
# runs the Rscript using input specified above
Rscript get_TreeHeight.R $Input
# prints message below when complete
echo 'Heights calculated and saved.'
# exits process
exit