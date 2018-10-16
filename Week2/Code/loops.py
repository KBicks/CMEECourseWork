#!/usr/bin/env python3
"""Demonstration of for loops and while loops."""

#FOR loops in Python
# Prints values of i up to range specified 
for i in range(5): 
    print(i)

# Prints each element of list
my_list = [0, 2, "geronimo!", 3.0, True, False]
for k in my_list:
    print(k)

# prints addition of running totals to a list - recursively 
total = 0
summands = [0, 1, 11, 111, 1111]
for s in summands:
    total = total + s
    print(total)

#WHILE loops in Python
# Prints z values, increasing until specified value 
z = 0
while z < 100:
    z = z + 1
    print(z)

# Infinite loop that prints until b is FALSE
b = True
while b:
    print("GERONIMO! Infinite loop! ctrl+c to stop!")
    