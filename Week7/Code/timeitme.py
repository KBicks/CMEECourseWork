#!/usr/bin/env python3
"""Comparison of time taken for a loop and list comprehension to run the same
function, outputs average times taken for function compared."""

__author__ = "Katie Bickerton (k.bickerton18@imperial.ac.uk)"
__version__ = "3.5.2"

import timeit

iters = 10000000

from profileme import my_squares as my_squares_loops
from profileme import my_squares as my_squares_lc

# gives average time taken to run loop and lc versions of my_squares function
# %timeit my_squares_loops(iters)
# %timeit my_squares_lc(iters)


mystring = "My string"

from profileme import my_join as my_join_join
from profileme import my_join as my_join

# gives average time taken to run loop and lc versions of my_string function
# %timeit(my_join_join(iters,mystring))
# %timeit(my_join(iters,mystring))

import time

start = time.time()
my_squares_loops(iters)
print("my_squares_loops takes %fs to run." % (time.time()-start))

start = time.time()
my_squares_lc(iters)
print("my_squares_lc takes %fs to run." % (time.time()-start))