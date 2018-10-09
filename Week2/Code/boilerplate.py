#!/usr/bin/env python3

"""Description of this program or application
Which can cover multiple lines"""

__appname__ = '[boilerplate.py]'
__author__ = 'Katie Bickerton (k.bickerton18@imperial.ac.uk'
__version__ = ''
__license__ = "License for this code/program"

## imports ##
import sys # module to interface program with operating system

## constants ##

## functions ##
def main(argv):
    """Main entry point of the program """
    print('This is a boilerplate')
    return 0 #success failure codes - 0 means it has worked

if __name__ == "__main__":
    """Makes sure the "main" function is called from the command line"""
    status = main(sys.argv)
    sys.exit(status)
