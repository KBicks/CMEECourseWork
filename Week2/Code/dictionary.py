#!/usr/bin/env python3
"""Populated a dictionary with order as the key, and each species sorted
into order."""

__author__ = 'Katie Bickerton (k.bickerton18@imperial.ac.uk'
__version__ = '3.5.2'

taxa = [ ('Myotis lucifugus','Chiroptera'),
         ('Gerbillus henleyi','Rodentia',),
         ('Peromyscus crinitus', 'Rodentia'),
         ('Mus domesticus', 'Rodentia'),
         ('Cleithrionomys rutilus', 'Rodentia'),
         ('Microgale dobsoni', 'Afrosoricida'),
         ('Microgale talazaci', 'Afrosoricida'),
         ('Lyacon pictus', 'Carnivora'),
         ('Arctocephalus gazella', 'Carnivora'),
         ('Canis lupus', 'Carnivora'),
        ]

### Question
# Write a short python script to populate a dictionary called taxa_dic 
# derived from  taxa so that it maps order names to sets of taxa. 
# E.g. 'Chiroptera' : set(['Myotis lucifugus']) etc. 

### Answer

# create dictionary with key set as the order - with an empty set being created 
# for each order
taxadict = {order[1] : set() for order in taxa}
# for each row, add species to each order
for order in taxa:
        taxadict[order[1]].add(order[0])
print(taxadict)