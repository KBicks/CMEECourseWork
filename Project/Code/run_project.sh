#!/bin/bash
# Author: Katie Bickerton k.bickerton@imperial.ac.uk
# Script: run_project.sh
# Desc: Runs coding files for CMEE main project.
# Arguments: none
# Date: 28 Jul 2019

echo "Starting code"


echo "Starting center of activity calculations (COA), this may take some
time due to volume of data."
Rscript COA.R
echo "COA calculations complete"
echo "MCP and KUD calculations, this may take some time complete."
Rscript MCP_KUD.R
echo "MCP and KUD calculated"
echo "Starting MCP and KUD subset calculations, which may take some time."
Rscript MCP_KUD_subsets.R
echo "MCP and KUD calculations complete"
echo "Starting network analysis"
Rscript Movement_Networks.R
echo "Network analysis complete"
echo "Calculating detections per shark"
Rscript Detection_count.R
echo "Detection calculations complete"
echo "Calculating residency indicies"
Rscript Residency_Index.R
echo "Residency indicies calculated."
echo "Analysis complete"
echo "Running analysis of overall models."
Rscript model_building_all.R
echo "Running analysis of Dusky shark models."
Rscript dus_model_building.R
echo "Running analysis of Sandbar shark models."
Rscript san_model_building.R
echo "Model building complete."
