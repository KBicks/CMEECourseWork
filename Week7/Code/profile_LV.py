#!/usr/bin/env python3
"""Timing the models from two different models."""

__author__ = "Katie Bickerton (k.bickerton18@imperial.ac.uk)"
__version__ = "3.5.2"


import timeit
import time

from LV1 import dCR_dt as r_model
from LV2 import dCR_dt as k_model

%run -p LV1.py
%run -p LV2.py 1 0.5 1.5 0.75 
