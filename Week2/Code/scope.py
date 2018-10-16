#!/usr/bin/env python3
"""Demonstrates that global variables appear outside the function, whereas
variables set inside the function do not alter variables outside the function."""

# Part 1
# set value of variables
_a_global = 10

# Define a function
def a_function():
    # set values of variables
    _a_global = 5
    _a_local = 4
    # outputs values of variables
    print("Inside the function, the value is ", _a_global)
    print("Inside the function, the value is ", _a_local)
    return None

a_function()

# gives value of variable outside the function
print("Outside the function, the value is ", _a_global)

#Part 2
_a_global = 10

def a_function():
    # use of function global means variable is then used and outside the function
    global _a_global 
    _a_global = 5
    _a_local = 4
    print("Inside the function, the value is ", _a_global)
    print("Inside the function, the value is ", _a_local)
    return None

a_function()
# global variables are able to overwrite variables outside the function
print("Outside the function, the value is", _a_global)

#avoid assigning global variables because it can cause name conflicts across multiple scripts