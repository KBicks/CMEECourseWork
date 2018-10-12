#!/usr/bin/env python3
"""Boilerplate script to demonstrate how a python code runs."""

__author__ = 'Katie Bickerton (k.bickerton18@imperial.ac.uk'
__version__ = '3.5.2'


## imports ##
import sys # module to interface program with operating system

## constants ##

## functions ##
def main(argv):
    """Main entry point of the program """
    print('This is a boilerplate')
    return 0 #success failure codes - 0 means it has worked

if __name__ == "__main__": #allows file to be run as script and imported 
    #- programme runs itself instead of requiring another module
    """Makes sure the "main" function is called from the command line"""
    status = main(sys.argv) #if above statement is true, outputs definition
    sys.exit(status) #gives the status upon exit - 0 if successful