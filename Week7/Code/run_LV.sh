#!/bin/bash
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: run_LV.sh
# Desc: Runs Lotka-Volterra simulations in python.
# Arguments: none 
# Date: 15 Nov 2018


echo "Running profile on r-selected Lotka-Volterra model."
ipython3 -m cProfile LV1.py
echo "Complete."

echo "Running profile on k-selected Lotka-Volterra model."
ipython3 -m cProfile LV2.py 1 0.5 1.5 0.75
echo "Complete."