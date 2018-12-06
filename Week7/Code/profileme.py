#!/usr/bin/env python3
"""Exemplifies profiling in python."""
__appname__ = "profileme.py"
__author__ = "Katie Bickerton <k.bickerton18@imperial.ac.uk>"
__version__ = "3.5.2"
__date__ = "20-Nov-2018"

def my_squares(iters):
    """Returns list of squares for values within iters."""
    out = [] #list structure
    for i in range(iters):
        out.append(i**2)
    return out

def my_join(iters, string):
    """Joins strings."""
    out = ''
    for i in range(iters):
        out += string.join(", ")
    return out

def run_my_funcs(x,y):
    """Runs two previous functions."""
    print(x,y)
    my_squares(x)
    my_join(x,y)
    return 0

run_my_funcs(10000000, "My string")