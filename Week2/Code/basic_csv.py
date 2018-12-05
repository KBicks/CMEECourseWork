#!/usr/bin/env python3
"""Reads and prints a csv file, then writes specified components of the csv
to a new csv."""
__appname__ = "basic_csv.py"
__author__ = "Katie Bickerton <k.bickerton18@imperial.ac.uk>"
__version__ = "3.5.2"
__date__ = "09-Oct-2018"

# module dealing with csv files
import csv

# Read a file containing:
# 'Species','Infrairder','Family','Distribution','Body mass'
f = open('../Data/testcsv.csv','r')

# Sets csv file to be read
csvread = csv.reader(f)
# Creates a temporary list for outputs
temp = []
for row in csvread:
    # Adds each row of the input to the temp output file as a tuple, then prints
    temp.append(tuple(row))
    print(row)
    # prints string then the first entry of each row (indexed as 0)
    print("The species is", row[0])

f.close()

# write a file containing only species name and Body mass

# opens testcsv.csv as a file to be read and set to variable f
f = open('../Data/testcsv.csv','r')
# opens bodymass.csv as a file to be written and set to variable g
g = open('../Results/bodymass.csv', 'w')

# set variables to each csv
csvread = csv.reader(f)
csvwrite = csv.writer(g)
for row in csvread:
    # print each row in read csv
    print(row)
    # write the 1st and 5th entries from each row (indexing starts at 0) into the write csv
    csvwrite.writerow([row[0], row[4]])

# close both files
f.close()
g.close()