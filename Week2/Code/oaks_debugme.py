#!/usr/bin/env python3
"""Finds oak species in a csv file and outputs into a new csv file of oak
species only."""

__author__ = 'Katie Bickerton (k.bickerton18@imperial.ac.uk'
__version__ = '3.5.2'

import csv
import sys
import doctest

#Define function
def is_an_oak(name):
    """ Returns True if name is starts with 'quercus', the genus for oaks
    
    >>> is_an_oak("Quercus test")
    True
    >>> is_an_oak("Fagus sylvatica")
    False
    >>> is_an_oak("Quercuss test) 
    False
    """
    
    return name.lower().split(" ")[0] == "quercus"

def main(argv):
    """Searches for oak species with input csv file, outputs oak species into
    a new csv. Prints output showing oak species found.""" 
    f = open('../Data/TestOaksData.csv','r')
    g = open('../Results/JustOaksData.csv','w')
    taxa = csv.reader(f)
    csvwrite = csv.writer(g)
    oaks = set()
    for row in taxa:
        print(row)
        print ("The genus is: ") 
        print(row[0] + '\n')
        if is_an_oak(row[0]):
            print('FOUND AN OAK!\n')
            csvwrite.writerow([row[0], row[1]])    

    doctest.testmod()

    return 0
    
if (__name__ == "__main__"):
    status = main(sys.argv)