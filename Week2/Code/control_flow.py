#!/usr/bin/env python3
"""Demonstrating the use of control statements."""

__author__ = 'Katie Bickerton (k.bickerton18@imperial.ac.uk'
__version__ = '3.5.2'


import sys

def even_or_odd(x=0): #if not specified x will = 0
    """Find whether a number x is even or odd."""
    if x % 2 == 0: # % is remainder function
        # % here returns value as x - place holder %d better than just x as returns a string
        return "%d is Even!" % x #if true will return even
    return "%d is Odd!" % x #if not true, will return odd

def largest_divisor_five(x=120):
    """Find which is the largest divisor of x among 2,3,4,5."""
    # if else statements to find largest divisor between 2-5 of a variable
    largest = 0
    if x % 5 == 0:
        largest = 5
    #tests variable starting with base case scenario, if not true, uses else if statments (elif)
    elif x % 4 == 0:
        largest = 4
    elif x % 3 == 0:
        largest = 3
    elif x % 2 == 0:
        largest = 2
    else: #final option - just else, no other alternatives 
        return "No divisor found for %d!" % x
    return "The largest divisor of %d is %d" % (x,largest)

def is_prime(x=70):
    """Find whether an integer is prime."""
    for i in range(2,x): # within range determine whether prime
        if x % i == 0:
            # if divisor is found, state not prime and divisor
            print("%d is not a prime: %d is a divisor" % (x,i))

            return False
    print("%d is a prime" % x) # % x is the modular operator 
    return True

def find_all_primes(x=22):
    """Find all the primes up to x"""
    #empty list to insert outputs
    allprimes = []
    for i in range(2, x+1):
        if is_prime(i):
            #if prime, add to allprimes list
            allprimes.append(i)
    print("There are %d primes between 2 and %d" % (len(allprimes), x))
    return allprimes

def main(argv):
    """tests the statements below to check script gives desired output"""
    print(even_or_odd(22))
    print(even_or_odd(33))
    print(largest_divisor_five(120))
    print(largest_divisor_five(121))
    print(is_prime(60))
    print(is_prime(59))
    print(find_all_primes(100))
    return 0

if (__name__ == "__main__"):
    # exit once status reaches main argument
    status = main(sys.argv)
    sys.exit(status)