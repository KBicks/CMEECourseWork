CMEE Course Work Week 3 Directory

This directory contains three directories:
    1. Code
    2. Data
    3. Results

The Code contains R code files as described:

    R Chapter:

    apply1.R exemplifies use of inbuilt functions in R and application to rows and
    columns.
    apply2.R defining own functions, then using apply to run.
    basic_io.R illustrates inputing and outputing csv files.
    boilerplate.R a function to output script, with option to input at base of
    the script - in terms of x and y.
    break.R if and else statements and stopping the code at a certain value
    control.R demonstrating use of control flow constructs.
    next.R demonstrating the use of next statements.
    Preallocate.R comparing the speeds of running functions based on whether the
    vector is allocated within the function or before.
    Ricker.R simulates the Ricker model and plots change in generations.
    sample.R run a simulation that involves sampling from a population, using both
    a for loop and vectorization.
    try.R taking the sample.R code and appling try
    Vectorize1.R compares for loop and vectorization speeds for the same function
    
    Data Management and Visualisation Chapter:

    DataWrang.R wrangles the data from wide to long format and adjust headers
    Girko.R creates a figure to demonstrate Girko's circular law and saves the 
    plot as a pdf file in results.
    MyBars.R demonstrates plotting and annotating in ggplot and saves output
    to a pdf in results.
    plotLin.R demonstrates running a linear regression and plotting using ggplot
    then saves output to a pdf in results.
    SQLinR.R demonstrates building a database 

    Practical codes - R Chapter:
    
    TreeHeight.R calculates tree heights from trees.csv and outputs appended csv 
    including the calculated heights in Results directory.
    get_TreeHeight.R carries out the same process as above however takes the input
    file from the command line, and outputs file into Results directory.
    run_get_TreeHeight.sh is a shell script that runs get_TreeHeight.R above.

    Vectorize2.R runs the stochastic Ricker model, using vectorization to decrease
    run time, and compares the time taken with the non-vectorized version.

    TAutoCorr.R computes the correlation coefficient across successive years of
    temperature data, and calculate the p value using 10000 random samples.
    TAutoCorr.tex is the report tex file used to create TAutoCorr.pdf, also in
    this directory.
    maps.R creates a map and uses a dataframe specified in the code to add points,
    in this script the data shows distribution of species globally.

    Practical codes - Data Management and Visualisation Chapter:

    DataWrangTidy.R uses the DataWrang.R code and demonstrates how functions from
    the dplyr and tidyr packages as opposed to reshape2.
    PP_Lattice.R makes lattice plots of density of predator mass, prey mass, and
    their ratios and saves to pdf, then outputs means and medians into a csv file
    PP_Regress.R plots the regressions of predator mass, prey mass, and their 
    ratios into a multi panel plot and saves as a pdf to results, then extracts
    the summary statistics for each group into a csv file.
    
The Data directory contains files for testing the code scripts.
The Results directory contains the outputs from code scripts.