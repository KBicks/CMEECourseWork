#!/bin/bash

#PBS -l walltime=12:00:00
#PBS -l select=1:ncpus=1:mem=1gb
module load anaconda3/personal
module load intel-suite
echo "R is about to run"
R --vanilla < $HOME/kb2018_cluster.R
echo "R simulations complete"