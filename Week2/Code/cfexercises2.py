#!/usr/bin/env python3
"""Demonstrates definition of functions using if statements and for loops."""

__author__ = 'Katie Bickerton (k.bickerton18@imperial.ac.uk'
__version__ = '3.5.2'

# module interfacing this program with the operating system
import sys

def foo1(x):
    """foo1 square roots variable x.""" 
    return x ** 0.5

def foo2(x, y):
    """foo2 compares and outputs the larger two variables"""
    if x > y:
        return x
    return y

def foo3(x, y, z):
    """foo3 compares three input variables, alters positions based upon relative values, 
    and returns new arangement of variables"""
    if x > y:
        tmp = y
        y = x
        x = tmp
    if y > z:
        tmp = z
        z = y
        y = tmp
    return [x, y, z]

def foo4(x):
    """foo4 gives factorial of x."""
    result = 1
    for i in range(1, x + 1):
        result = result * i
    return result

def foo5(x): #where x = 10, the function will give 10!
    """foo5 returns factorial of input value using a recursive function"""
    if x == 1:
        return 1
    return x * foo5(x - 1)

def foo6(x):
    """foo6 also returns factorial of variable, using a non-recursive function."""
    facto = 1
    while x>=1:
        facto = facto * x
        x = x - 1
    return facto

def main(argv):
    """Tests functions."""
    print(foo1(16))
    print(foo2(5,6))
    print(foo3(3,5,1))
    print(foo4(4))
    print(foo5(4))
    print(foo6(4))
    return 0

if (__name__ == "__main__"):
    # exit once status reaches main argument
    status = main(sys.argv)
    sys.exit(status)