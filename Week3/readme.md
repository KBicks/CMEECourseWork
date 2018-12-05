### CMEE Coursework Week 3 README

*Introduction:* This directory contains coursework files from week 1 of the CMEE course. This week included an introduction to R and data management, exploration and visualisation using R. Some scripts used to run R scripts are written in bash and written analysis has been carried out in LaTeX.

*Contents:* There are three directories:
1. **Code** - script files in R, bash and LaTeX.
2. **Data** - data used to test code scripts.
3. **Results** - location for output files produced by script files.

*Code File Descriptions:*

Biological Computing in R:
**sample.R** - Exemplifies generating a vector of 100 random values using a function and the command 'sample()', then how to run function using vectorization or a for loop. 
**basic_io.R** - Demonstrating input and output of csv files, including appending.
**boilerplate.R** - A boilerplate script exemplifying printing arguments and their type in R.
**control.R** - Demonstrating use of control flows, using if, else and while statements, and for loops.
**break.R** - Exemplifying use of 'break' in while, if and else statements.
**next.R** - Exemplifying use of 'next' in a for loop, with an if statement.
**Vectorize1.R** - Exemplifies time taken to use a for loop method and vectorization method for the same process.
**Preallocate.R** - Comparing the effect if preallocation of variables on run time.
**apply1.R** - Exemplifies use of 'apply' function in R and application to rows and columns.
**apply2.R** - Exemplifying use of 'apply' to run functions.
**try.R** - Compares vectorization and for loops to run simulation using 'try', with specified error message.
**browse.R** - Exemplifying browser() function to debug R code.

Biological Computing in R Practicals:
**TreeHeight.R** - Calculates tree height from the angle to top and distance from base, and saves calculated values in csv with original data.
**get_TreeHeight.R** - Calculates tree height from the angle to top and distance from base, and saves calculated values in csv with original data, takes data file from command line, and outputs to results.
**run_get_TreeHeight.sh** - Runs get_TreeHeight.sh, using trees.csv as the input file.
**Vectorize2.R** - Runs a stochastic version of the Ricker model, comparing methods using for loops and vectorization.
**TAutoCorr.R** - iterates a function for correlation between temperatures over successive years.
**TAutoCorr.tex** - Answer to practical question from corresponding script.
**TAutoCorr.pdf** - Compiled version of .tex file above.
**maps.R** - Plots a world map with data points from the specified data set.

Data Management, Exploration and Visualisation:
**DataWrang.R** - Exemplifies methods to explore data, and transfers from wide to long format.
**Girko.R** - Plots a simulation of Girko's law and saves to pdf in Results directory.
**plotLin.R** - Exemplifies using ggplot to annotate and manipulate plots.

Data Management, Exploration and Visualisation Practicals:
**DataWrangTidy.R** - Exemplifies data exploration and switching from wide to long format using the packages 'tidyr' and 'dplyr'.
**PP_Lattice.R** - Produces lattice plots for the predator prey data provided and outputs as pdfs, and calculates and saves summary statistics to a csv file.
**PP_Regress.R** - Calculating multiple regressions, saving results into a csv, and plotting regressions.