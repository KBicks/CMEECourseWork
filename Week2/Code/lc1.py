#!/usr/bin/env python3
"""Demonstrates definition of functions using if statements and for loops, for
bird data in script."""

__author__ = 'Katie Bickerton (k.bickerton18@imperial.ac.uk'
__version__ = '3.5.2'

birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
         )

### Questions:
#(1) Write three separate list comprehensions that create three different
# lists containing the latin names, common names and mean body masses for
# each species in birds, respectively. 

# (2) Now do the same using conventional loops (you can choose to do this 
# before 1 !). 


### Answers:

## (1) List comprehensions

# List of latin names of bird species
latinname_lc = set([species[0] for species in birds])
print(latinname_lc)

# List of common names of bird species
commonname_lc = set([species[1] for species in birds])
print(commonname_lc)

# List of mean body masses of bird species
meanbodymass_lc = set([species[2] for species in birds])
print(meanbodymass_lc)



## (2) Conventional loop method

# List of latin names of bird species
latinname_loop = set()
for species in birds:
        latinname_loop.add(species[0])
print(latinname_loop)

# List of common names of bird species
commonname_loop = set()
for species in birds:
        commonname_loop.add(species[1])
print(commonname_loop)

# List of mean body masses of bird species
meanbodymass_loop = set()
for species in birds:
        meanbodymass_loop.add(species[2])
print(meanbodymass_loop)
