#!/usr/bin/env python3
"""Finds oak species from a csv file and output these into a new csv file of oak
species only."""

__author__ = 'Katie Bickerton (k.bickerton18@imperial.ac.uk'
__version__ = '3.5.2'

import csv
import sys
import doctest

#Define function searching for oak species
def is_an_oak(name):
    # doctest to check expected results are output
    """ Returns True if name is starts with 'quercus', the genus for oaks
    
    >>> is_an_oak("Quercus test")
    True
    >>> is_an_oak("Fagus sylvatica")
    False
    >>> is_an_oak("Quercuss test") 
    False
    """

    # sets name to lower case, splits each word into a separate section, 
    # extracts first element of each 
    name = name.lower().split()[0]
    # checks length of name, if not 7 (the length of quercus), rejects
    if len(name) != 7:
        return False
    return name == "quercus"
    

def main(argv):
    """Searches for oak species with input csv file, outputs oak species into
    a new csv. Prints output showing oak species found.""" 
    # set f as input file and g as output file
    f = open('../Data/TestOaksData.csv','r')
    g = open('../Results/JustOaksData.csv','w')
    taxa = csv.reader(f)
    csvwrite = csv.writer(g)
    # create an empty set for oaks to populate
    oaks = set()
    #for each row in input, print the genus, then if it is an oak
    for row in taxa:
        print(row)
        print ("The genus is: ") 
        print(row[0] + '\n')
        if is_an_oak(row[0]):
            print('FOUND AN OAK!\n')
            #if is an oak, writes it to csv
            csvwrite.writerow([row[0], row[1]])    

    #runs doctests and checks against outputs from function
    doctest.testmod()

    return 0
    
if (__name__ == "__main__"):
    status = main(sys.argv)