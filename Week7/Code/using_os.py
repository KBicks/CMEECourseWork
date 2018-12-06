#!/usr/bin/env python3
"""Searches home directory for files and directories starting with c, both 
upper and lower case."""
__appname__ = "using_os.py"
__author__ = "Katie Bickerton <k.bickerton18@imperial.ac.uk>"
__version__ = "3.5.2"
__date__ = "16-Nov-2018"

# Use the subprocess.os module to get a list of files and  directories 
# in your ubuntu home directory 

# Hint: look in subprocess.os and/or subprocess.os.path and/or 
# subprocess.os.walk for helpful functions

import subprocess
import re

#################################
#~Get a list of files and 
#~directories in your home/ that start with an uppercase 'C'

# Type your code here:

# Get the user's home directory.
home = subprocess.os.path.expanduser("~")

# Create a list to store the results.
FilesDirsStartingWithC = []

# Use a for loop to walk through the home directory.
for (dir, subdir, files) in subprocess.os.walk(home):
    # for every subdirectory
    for i in subdir:
        # search for files and directories starting with uppercase C
        x = re.match(r"^C\w*", i)
        if x != None:
            # when found, add to list
            FilesDirsStartingWithC.append(i)
    for y in files:
        # search for files starting with uppercase C
        y = re.match(r"^C\w*", i)
        if y != None:
            # append list when found
            FilesDirsStartingWithC.append(i)

# find number of files and directories with uppercase C
CapC = len(FilesDirsStartingWithC)
# print(FilesDirsStartingWithC)
# print(CapC)

#################################
# Get files and directories in your home/ that start with either an 
# upper or lower case 'C'

# Type your code here:

# intialise list
FilesDirsStartingWithCorc = []

# for every directory, subdirectory and file in home directory
for (dir, subdir, files) in subprocess.os.walk(home):
    # search the subdirectories for names startind with upper or lower case c
    for i in subdir:
        x = re.match(r"^[Cc]\w*", i)
        if x != None:
            # append list when found
            FilesDirsStartingWithCorc.append(i)
    # same as above but just for files
    for y in files:
        y = re.match(r"^[Cc]\w*", i)
        if y != None:
            FilesDirsStartingWithCorc.append(i)

# number of files and directories starting with c
Corc = len(FilesDirsStartingWithCorc)

#################################
# Get only directories in your home/ that start with either an upper or 
#~lower case 'C' 

# Type your code here:

# initialise list
DirsStartingWithCorc = []

# within the home directory
for (dir, subdir, files) in subprocess.os.walk(home):
    # for every subdirectory
    for i in subdir:
        # search for subdirectories starting with c
        x = re.match(r"^[Cc]\w*", i)
        # if matches, append list
        if x != None:
            
            DirsStartingWithCorc.append(i)

# number of directories only starting with c
DirCorc = len(DirsStartingWithCorc)

## Script ouputs:

print("This home directory contains:")
print("{} files and directories starting with uppercase c.".format(CapC))
print("{} files and directories starting with upper or lowercase c.".format(Corc))
print("{} directories starting with upper or lowercase c.".format(DirCorc))