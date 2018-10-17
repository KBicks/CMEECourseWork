#!/usr/bin/env python3
"""Print each tuple on a separate line."""

__author__ = 'Katie Bickerton (k.bickerton18@imperial.ac.uk'
__version__ = '3.5.2'

import sys
import csv

with open('../Data/seqs.csv','r') as f:
    csvread = csv.reader(f)
    sourcedata = [x[0] for x in csvread]

seq1 = sourcedata[0]
seq2 = sourcedata[1]
# # Two example sequences to match

#seq2 = "ATCGCCGGATTACGGG"
#seq1 = "CAATTCGGAT"

# Assign the longer sequence s1, and the shorter to s2
# l1 is length of the longest, l2 that of the shortest

# calculates length of both sequences

l1 = len(seq1)
l2 = len(seq2)
# finds the longer sequence and assigns to s1
if l1 >= l2:
    s1 = seq1
    s2 = seq2
else:
    s1 = seq2
    s2 = seq1
    l1, l2 = l2, l1 # swap the two lengths

# A function that computes a score by returning the number of matches starting
# from arbitrary startpoint (chosen by user)
def calculate_score(s1, s2, l1, l2, startpoint):
    matched = "" # to hold string displaying alignements
    score = 0
    for i in range(l2):
        #moves shorter sequence along longer, counting number of matches in
        #each position
        if (i + startpoint) < l1:
            if s1[i + startpoint] == s2[i]: # if the bases match
                matched = matched + "*"
                score = score + 1
            else:
                matched = matched + "-"

    # gives an output for each startpoint showing the number of matches where
    # * is a match and - is no match, position of the two sequences relative to
    # each other, and the number of matches for that startpoint.
    print("." * startpoint + matched)           
    print("." * startpoint + s2)
    print(s1)
    print(score) 
    print(" ")

    return score

# Test the function with some example starting points:
# calculate_score(s1, s2, l1, l2, 0)
# calculate_score(s1, s2, l1, l2, 1)
# calculate_score(s1, s2, l1, l2, 5)

# now try to find the best match (highest score) for the two sequences
my_best_align = None
my_best_score = -1

for i in range(l1): # Note that you just take the last alignment with the highest score
    z = calculate_score(s1, s2, l1, l2, i)
    if z > my_best_score:
        # best align is position of starting point of s2 relative to s1, with the most matches
        my_best_align = "." * i + s2
        my_best_score = z 
print(my_best_align)
print(s1)
print("Best score:", my_best_score)
outstr = "{}\n{}\nBest score: {}".format(my_best_align, s1, my_best_score)
with open("../Results/best_score.txt", "w") as f:
    f.write(outstr)