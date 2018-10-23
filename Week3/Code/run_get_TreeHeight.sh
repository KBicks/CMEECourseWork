#!/bin/bash
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: run_get_TreeHeight.sh
# Desc: Calculates tree heights using distance from base and angle to top in radians,
        # then creates a new csv output file containing the calculated heights in a new column.
# Arguments: Input
# Date: 23 Oct 2018

Input="../Data/trees.csv"
Rscript get_TreeHeight.R $Input
echo 'Heights calculated and saved'

exit