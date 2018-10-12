#!/usr/bin/env python3
"""Demonstration of using __name__==__"main"__ to write a program that can
run itself, and be imported by another module."""

__author__="Katie Bickerton (k.bickerton18@imperial.ac.uk)"
__version__="3.5.2"


if __name__ == '__main__':
    print('This program is being run by itself')
    # if run, will output that the program runs itself
else:
    print('I am being imported from another module')
    # if imported, will state that another module is importing the program