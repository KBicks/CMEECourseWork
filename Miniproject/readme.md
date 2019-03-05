### CMEE Miniproject README  
  
*Introduction:* This directory contains files for my CMEE Miniproject.MOREINFO.    
  
*Contents:* There are three directories:
1. **Code** - script files for the miniproject, in bash, LaTeX, R and Python.
2. **Data** - data used for the miniproject.
3. **Results** - location for output files produced by script files.
  
*Code File Descriptions:*  
**run_Miniproject.sh** - Runs coding files for CMEE Miniproject and compiles report.  
**data_wrangling.py** - Manipulates pred_prey dataset (see report for source) to extract variables needed for model building and fitting in R.  
**model_fitting.R** - Builds models for pred_prey dataset, fits models using appropriate methods for each model, plots models and compares models using the Akaike information criterion.  
**compile_report.sh** - Compiles LaTeX file and references into pdf report.  
**miniproject.tex** - LaTeX report file.  
**miniproject.bib** - References for report.

*Required packages:*  
  
*Program Versions:*  

  
*Miniproject Running Instructions:*  
To run this miniproject, source run_Miniproject.sh in the command line, then sit back and wait for the magic to happen. The script will run the python data_wrangling.py script, outputting the wrangled data into a csv format, then carry out model building, fitting, selection and plotting in R using the model_fitting.R script, then compile the modelling outputs, LaTeX report (miniproject.tex), and references (miniproject.bib) into a pdf report into the Code repository. The code may take several minutes to run so please be patient and I hope it's worth the wait!