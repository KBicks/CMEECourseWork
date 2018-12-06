#!/usr/bin/env python3
"""Searches and extracts Kingdom, Phylum and Species from a text file into a string."""
__appname__ = "blackbirds.py"
__author__ = "Katie Bickerton <k.bickerton18@imperial.ac.uk>"
__version__ = "3.5.2"
__date__ = "15-Nov-2018"

import re

# Read the file (using a different, more python 3 way, just for fun!)
with open('../Data/blackbirds.txt', 'r') as f:
    text = f.read()

# replace \t's and \n's with a spaces:
text = text.replace('\t',' ')
text = text.replace('\n',' ')
# You may want to make other changes to the text. 

# In particular, note that there are "strange characters" (these are accents and
# non-ascii symbols) because we don't care for them, first transform to ASCII:
text = text.encode('ascii', 'ignore') # first encode into ascii bytes
text = text.decode('ascii', 'ignore') # Now decode back to string

# Now extend this script so that it captures the Kingdom, Phylum and Species
# name for each species and prints it out to screen neatly.

# captures Kingdom, Phylum and Species
King_Phy_Sp = r"Kingdom\s(\w+).+?Phylum\s(\w+).+?Species\s(\w+\s\w+)"
# searches dataframe for matches to the expression above
search = re.findall(King_Phy_Sp,text)

# sets header new for data frame
header = "Kingdom, Phylum, Species\n"
# make a string of the header and the search results
string = header + "\n".join([", ".join(x) for x in search])
# prints results
print(string)

# Hint: you may want to use re.findall(my_reg, text)... Keep in mind that there
# are multiple ways to skin this cat! Your solution could involve multiple
# regular expression calls (easier!), or a single one (harder!)