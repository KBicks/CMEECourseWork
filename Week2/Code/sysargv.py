#!/usr/bin/env python3
"""Using module sys, gives name, number of arguments and lists arguments 
of a script."""
__appname__ = "sysargv.py"
__author__ = "Katie Bickerton <k.bickerton18@imperial.ac.uk>"
__version__ = "3.5.2"
__date__ = "10-Oct-2018"

# import module sys
import sys

# prints file name of the script
print("This is the name of the script: ", sys.argv[0])
# gives length of arguments used (i.e. number of arguments in script)
print("Number of arguments: ", len(sys.argv))
# lists arguments in script, including any input during running
print("The arguments are: " , str(sys.argv))