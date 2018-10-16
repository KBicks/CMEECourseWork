#!/usr/bin/env python3
"""Demonstration of different control functions."""

for i in range(3, 17): #prints hello for every i in range
    print("hello")

for j in range(12): #prints hello for every j in range which is divisible by 3
    if j % 3 == 0:
        print("hello")

for j in range(15): #prints hello for every j in range that is divisible by either 5 or 4 and gives a remainder of 3
    if j % 5 == 3:
        print("hello")
    elif j % 4 == 3:
        print("hello")

z = 0
while z != 15: #for values of z not equal to 15, print hello
    print("hello")
    z = z + 3

z = 12
while z < 100: #print hello for values that fulfil parameters of z and k 
    if z == 31:
        for k in range(7):
            print("hello")
    elif z == 18: #else if, print hello if these parameters are met
        print("hello")
    z = z + 1 #run through values of z from starting value to constraints of function