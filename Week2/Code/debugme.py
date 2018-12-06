#!/usr/bin/env python3
"""Code with error to practise debugging."""
__appname__ = "debugme.py"
__author__ = "Katie Bickerton <k.bickerton18@imperial.ac.uk>"
__version__ = "3.5.2"
__date__ = "13-Oct-2018"


def createabug(x):
    """Simple division - with bug, to test debugging."""
    y = x**4
    z = 0
    y = y/z
    return y

# run function
createabug(25)