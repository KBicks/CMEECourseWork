#!/usr/bin/env python3
"""Code to practise debugging."""

__author__ = 'Katie Bickerton (k.bickerton18@imperial.ac.uk'
__version__ = '3.5.2'

def createabug(x):
    y = x**4
    z = 0
    y = y/z
    return y

createabug(25)