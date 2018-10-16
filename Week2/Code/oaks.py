#!/usr/bin/env python3
"""Demonstrates how list for loops and list comprehensions can be used for
the same tasks - outputing oak species from list and changing output to upper
case."""

taxa = ["Quercus robur",
        "Fraxinus excelsior",
        "Pinus sylvestris",
        "Quercus cerris",
        "Quercus petraea",
        ]

def is_an_oak(name):
    #function defining what an oak is
    return name.lower().startswith("quercus ")

###Two methods for ouputing oak species in list:
##Using for loops
oaks_loops = set() 
for species in taxa:
    if is_an_oak(species):
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