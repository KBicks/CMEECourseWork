#!/usr/bin/env python3
"""Demonstrates inputing text files into python: 
File Input prints first every line in a file, then every line apart from blank lines,
File Output generates a list of a specified range, then saves it with each element on a new line,
Storing Files using the pickle module"""

__author__ = "Katie Bickerton (k.bickerton18@imperial.ac.uk)"
__version__ = "3.5.2"


##############
# FILE INPUT
##############
# Open a file for reading 
f = open('../Sandbox/test.txt','r') #r is to read txt
# use "implicit" for loop
# if the object is a file, python will cycle over lines
# prints each line of input file
for line in f:
    print(line)

#close the file
f.close()


# Same example, skip blank lines
f = open('../Sandbox/test.txt','r')
for line in f:
    # removes blank lines by looking for lines (after stripping trailing spaces) which have lengths > 0
    # only lines that fulfil this condition are printed
    if len(line.strip()) > 0:
        print(line)

f.close()

###############
# FILE OUTPUT
###############
# Save the elements of a list to a file
list_to_save = range(100)

f = open('../Sandbox/testout.txt','w')
# for each element of the list, print in file specified above and add a new line per element
for i in list_to_save:
    f.write(str(i) + '\n') ## Add a new line at the end

f.close()

################
# STORING OBJECTS
################
# To save an object (even complex) for later use
# Create a dictionary 
my_dictionary = {"a key": 10, "another key": 11}

import pickle
#module that allows saving from RAM to hard disk

f = open('../Sandbox/testp.p','wb') ## note the b: accept binary files
# stores dictionary
pickle.dump(my_dictionary, f) 
f.close()

##Load the data again
f = open('../Sandbox/testp.p','rb')
#loads stored dictionary 
another_dictionary = pickle.load(f) 
f.close()

print(another_dictionary)