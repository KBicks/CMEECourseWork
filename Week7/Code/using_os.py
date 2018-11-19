""" This is blah blah"""

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
    for i in subdir:
        x = re.match(r"^C\w*", i)
        if x != None:
            FilesDirsStartingWithC.append(i)
    for y in files:
        y = re.match(r"^C\w*", i)
        if y != None:
            FilesDirsStartingWithC.append(i)

CapC = len(FilesDirsStartingWithC)
# print(FilesDirsStartingWithC)
# print(CapC)

#################################
# Get files and directories in your home/ that start with either an 
# upper or lower case 'C'

# Type your code here:

FilesDirsStartingWithCorc = []

for (dir, subdir, files) in subprocess.os.walk(home):
    for i in subdir:
        x = re.match(r"^[Cc]\w*", i)
        if x != None:
            FilesDirsStartingWithCorc.append(i)
    for y in files:
        y = re.match(r"^[Cc]\w*", i)
        if y != None:
            FilesDirsStartingWithCorc.append(i)

Corc = len(FilesDirsStartingWithCorc)

#################################
# Get only directories in your home/ that start with either an upper or 
#~lower case 'C' 

# Type your code here:

DirsStartingWithCorc = []

for (dir, subdir, files) in subprocess.os.walk(home):
    for i in subdir:
        x = re.match(r"^[Cc]\w*", i)
        if x != None:
            DirsStartingWithCorc.append(i)

DirCorc = len(DirsStartingWithCorc)

## Script ouputs:

print("This home directory contains:")
print("{} files and directories starting with uppercase c.".format(CapC))
print("{} files and directories starting with upper or lowercase c.".format(Corc))
print("{} directories starting with upper or lowercase c.".format(DirCorc))