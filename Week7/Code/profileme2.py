#!/usr/bin/env python3
"""Profiling in python, same but not using loops, using list comprehensions."""

__author__ = "Katie Bickerton (k.bickerton18@imperial.ac.uk)"
__version__ = "3.5.2"

def my_squares(iters):
    out = [i ** 2 for i in range(iters)]
    return out

def my_join(iters,string):
    out = ''
    for i in range(iters):
        out += ", " + string
    return out

def run_my_funcs(x,y):
    print(x,y)
    my_squares(x)
    my_join(x,y)
    return 0

run_my_funcs(10000000, "My string")