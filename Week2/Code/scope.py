#!/usr/bin/env python3


#Part 1
_a_global = 10

def a_function():
    _a_global = 5
    _a_local = 4
    print("Inside the function, the value is ", _a_global)
    print("Inside the function, the value is ", _a_local)
    return None

a_function()
print("Outside the function, the value is ", _a_global)

#Part 2
_a_global = 10

def a_function():
    global _a_global #use of function global means variable is then used and changed outside the function
    _a_global = 5
    _a_local = 4
    print("Inside the function, the value is ", _a_global)
    print("Inside the function, the value is ", _a_local)
    return None

a_function()
print("Outside the function, the value is", _a_global)

#avoid assigning global variables because it can cause name conflicts across multiple scripts