#!/usr/bin/env python3
"""Profiling in python, same as profileme.py but using list comprehensions instead
of for loops."""
__appname__ = "profileme.py" 
__author__ = "Katie Bickerton <k.bickerton18@imperial.ac.uk>"
__version__ = "3.5.2"
__date__ = "20-Nov-2018"

def my_squares(iters):
    """Returns square of values in range."""
    out = [i ** 2 for i in range(iters)]
    return out

def my_join(iters,string):
    """Joins strings."""
    out = ''
    for i in range(iters):
        out += ", " + string
    return out

def run_my_funcs(x,y):
    """Runs my_squares and my_join functions."""
    print(x,y)
    my_squares(x)
    my_join(x,y)
    return 0

run_my_funcs(10000000, "My string")