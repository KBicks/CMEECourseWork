#!/usr/bin/env python3
"""Functions exemplifying the use of control statements."""
__appname__ = "test_control_flow.py"
__author__ = "Katie Bickerton <k.bickerton18@imperial.ac.uk>"
__version__ = "3.5.2"
__date__ = "12-Oct-2018"

import sys
#module for testing functions
import doctest

def even_or_odd(x=0): #if not specified x will = 0
    """Find whether a number x is even or odd.
      
    >>> even_or_odd(10)
    '10 is Even!'
    
    >>> even_or_odd(5)
    '5 is Odd!'
    
    whenever a float is provided, then the closest integer is used:    
    >>> even_or_odd(3.2)
    '3 is Odd!'
    
    in case of negative numbers, the positive is taken:    
    >>> even_or_odd(-2)
    '-2 is Even!'
    
    """
    #Define function to be tested
    if x % 2 == 0: # % is remainder function
        return "%d is Even!" % x # % here returns value as x - place holder %d better than just x as returns a string
    return "%d is Odd!" % x

###### Suppressed Block ######
# 
#  def largest_divisor_five(x=120):
#     """Find which is the largest divisor of x among 2,3,4,5."""
#     largest = 0
#     if x % 5 == 0:
#         largest = 5
#     elif x % 4 == 0:
#         largest = 4
#     elif x % 3 == 0: #shorterning of else if
#         largest = 3
#     elif x % 2 == 0:
#         largest = 2
#     else:
#         return "No divisor found for %d!" % x
#     return "The largest divisor of %d is %d" % (x,largest)

# def is_prime(x=70):
#     """Find whether an integer is prime."""
#     for i in range(2,x):
#         if x % i == 0:
#             print("%d is not a prime: %d is a divisor" % (x,i))

#             return False
#     print("%d is a prime" % x) # % x is the modular operator 
#     return True

# def find_all_primes(x=22):
#     """Find all the primes up to x"""
#     allprimes = []
#     for i in range(2, x+1):
#         if is_prime(i):
#             allprimes.append(i)
#     print("There are %d primes between 2 and %d" % (len(allprimes), x))
#     return allprimes

# def main(argv):
#     print(even_or_odd(22))
#     print(even_or_odd(33))
#     print(largest_divisor_five(120))
#     print(largest_divisor_five(121))
#     print(is_prime(60))
#     print(is_prime(59))
#     print(find_all_primes(100))
#     return 0

# if (__name__ == "__main__"):
#     status = main(sys.argv)
#     sys.exit(status)
###########################################

#runs embedded tests
doctest.testmod() # To run embedded tests