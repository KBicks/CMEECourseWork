### CMEE Research Project README  
  
*Introduction:* This directory contains the code and data files used for my masters project: INSERT TITLE. To run the project, use the run_project.sh file in the code respository. To generate the report, use the .TeX file in the code repository and associated bibTeX file for references, or see pdf version.  
   
*Contents:* There are four directories:  
1. **Code** - script files for the project, in bash, LaTeX and R.  
2. **Data** - data used for the reseach project.  
3. **Proposal** - contains source code in LaTeX and the pdf version of the project proposal for this research project.  
4. **Results** - location for output files produced by script files.  
  
*Code File Descriptions:*  
**run_project.sh** - Runs script files for CMEE research project.  
**COA.R** - Calculates centers of activity for each shark.  
**MCP_KUD.R** - Calculates minimum convex polygons and kernel utilisation distribution areas for each center of activity.  
**MCP_KUD_subsets.R** - As above for subsets of the main data frame.  
**Movement_Netoworks.R** - Calculates network and network densities for each shark and subset.  
**Detection_count.R** - Calculates number of detections per day, per individual at a range of depth bands.  
**Residency_Index.R** - Calculates residency index for each shark and subset.   
**model_building_all.R** - Runs GLMMs for all sharks of both species.  
**dus_model_building.R** - Runs GLMMs for all dusky sharks.  
**san_model_building.R** - Runs GLMMs for all sandbar sharks.  
**Bickerton_Katherine_CMEEMRes_2019.tex** - Code file for final report in LaTeX.  

*Required R Packages:*  
**tidyverse** - data wrangling and plotting  
**lubridate** - formatting dates and times  
**car** - generating q-q plots for multiple distributions  
**MASS** - statistical manipulation  
**merTools** - checking GLMM fit  
**lme4** - fitting linear mixed effects models  
**MuMIn** - calculating r-squared values for GLMMs  
**igraph** - generating spatial networks  
**rgdal** - generating network visualisations and exporting shapefiles  
**VTrack** - calculating centers of activity  
**adehabitatHR** - calculating kernel utilisation density and minimum convex polygons  
**sp** - transform spatial data between co-ordinate systems  
  
*Program Versions:*  
**R** version 3.6.1  
**QGIS** version 3.4  