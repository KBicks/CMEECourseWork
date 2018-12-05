#!/usr/bin/env python3
"""Demonstrates how list for loops and list comprehensions can be used for
the same tasks - outputing oak species from list and changing output to upper
case."""
__appname__ = "oaks.py"
__author__ = "Katie Bickerton <k.bickerton18@imperial.ac.uk>"
__version__ = "3.5.2"
__date__ = "11-Oct-2018"


taxa = ["Quercus robur",
        "Fraxinus excelsior",
        "Pinus sylvestris",
        "Quercus cerris",
        "Quercus petraea",
        ]

def is_an_oak(name):
    """Searches for oak genus and returns in lower case."""
    return name.lower().startswith("quercus ")

###Two methods for ouputing oak species in list:
##Using for loops
oaks_loops = set()
# for all species in data 
for species in taxa:
    if is_an_oak(species):
            # add oaks to set
        oaks_loops.add(species)
print(oaks_loops)

##Using list comprehensions
# always uses [] as is a list
oaks_lc = set([species for species in taxa if is_an_oak(species)])
print(oaks_lc)

##Two methods for converting species names to upper case
#Get names in UPPER CASE using for loops
oaks_loops = set()
for species in taxa:
    if is_an_oak(species):
        oaks_loops.add(species.upper())
print(oaks_loops)

##Get names in UPPER CASE using list comprehensions
oaks_lc = set([species.upper() for species in taxa if is_an_oak(species)])
print(oaks_lc)