#!/usr/bin/env python3
"""Profiling in python """

__author__ = "Katie Bickerton (k.bickerton18@imperial.ac.uk)"
__version__ = "3.5.2"

def my_squares(iters):
    out = [] #list structure
    for i in range(iters):
        out.append(i**2)
    return out

def my_join(iters, string):
    out = ''
    for i in range(iters):
        out += string.join(", ")
    return out

def run_my_funcs(x,y):
    print(x,y)
    my_squares(x)
    my_join(x,y)
    return 0

run_my_funcs(10000000, "My string")