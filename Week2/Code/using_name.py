#!/usr/bin/env python3
"""Demonstration of using __name__==__"main"__ to write a program that can
run itself, and be imported by another module."""
__appname__ = "using_name.py"
__author__ = "Katie Bickerton <k.bickerton18@imperial.ac.uk>"
__version__ = "3.5.2"
__date__ = "10-Oct-2018"

if __name__ == '__main__':
    """Checks if the programe is being run by itself or imported."""
    print('This program is being run by itself')
    # if run, will output that the program runs itself
else:
    print('I am being imported from another module')
    # if imported, will state that another module is importing the program