#!/usr/bin/env python3
"""Exemplifies running an R script using python."""
__appname__ = "run_fmr_R.py"
__author__ = "Katie Bickerton <k.bickerton18@imperial.ac.uk>"
__version__ = "3.5.2"
__date__ = "17-Nov-2018"


import sys
import subprocess


def run_fmr(program, script, args=[], time=10):
    """Runs an R script file, and prints outputs and any errors."""
    print("Running fmr.R")
    # sets arguments to be a program and script
    command_args = [program, script] + args
    # opens a subprocess, with specified arguments, and variables for outputs and errors
    p = subprocess.Popen(command_args,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE)
    
    # if within time, will give output and no errors
    try:
        stdout, stderr = p.communicate(timeout=time)
        output = ("{} ran without errors.\nOutput: \n{}".format(script,stdout.decode()))
        return output
    # if outside of time limit, will give the below error code and kill the subprocess
    except subprocess.TimeoutExpired:
        print("The script {} has timed out after {} seconds.".format(script,time))
        p.kill()
        stdout, stderr = p.communicate()
        # decodes output
        return(stdout.decode())

# inputs for running fmr.R       
input_script = "fmr.R"
program = "Rscript"

# run the function with specified inputs
runfmr = run_fmr(program, input_script)

# display the output
print(runfmr)