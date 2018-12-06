#!/usr/bin/env python3
"""Exemplifies use of regular expressions in python."""
__appname__ = "regexs.py"
__author__ = "Katie Bickerton <k.bickerton18@imperial.ac.uk>"
__version__ = "3.5.2"
__date__ = "15-Nov-2018"

import re

my_string = "a given string"
# \s matches a whitespace characters
match = re.search(r'\s', my_string)
print(match)
# outputs match group
match.group()
# \d searches for numerical data in the string - none present so returns 0
match = re.search(r'\d', my_string)
print(match)

MyStr = 'an example'
match = re.search(r'\w*\s', MyStr)
if match:
    print('found a match', match.group())
else:
    print('did not find a match')

# matches number 2
match = re.search(r'2', "it takes 2 to tango")
match.group()
# matches any number
match = re.search(r'\d', "it takes 2 to tango")
match.group()
# matches number and the characters that follow
match = re.search(r'\d.*', "it takes 2 to tango")
match.group()
# matches a 1-3 character alphanumeric sequence with spaces either side
match = re.search(r'\s\w{1,3}\s', 'once upon a time')
match.group()
# searches for a space followed by alpha numeric characters, then the end
# i.e. the last word in a string and the space before
match = re.search(r'\s\w*$', 'once upon a time')
match.group()

# can make this command into 1 line with .group() on end
# search for a string of alphanumeric characters, then a space, then a number
# followed by something then ending in a number.
re.search(r'\w*\s\d.*\d', "take 2 grams of H2O").group()
# takes the start of the string, followed by an alphanumeric string followed by 
# any other characters then finishes with the last space of the string
re.search(r'^\w*.*\s', 'once upon a time').group()
# to terminate this after the first word use a ?
re.search(r'^\w*.*?\s', 'once upon a time').group()
# return anything between <>
re.search(r'<.+>', 'This is a <EM>first</EM> test').group()
# if we just want the first character between <>
re.search(r'<.+?>', 'This is a <EM>first</EM> test').group() 