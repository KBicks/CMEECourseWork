#!/usr/bin/env python3
import sys
import subprocess

def run_fmr(program, script, args=[], time=10):
    print("Running fmr.R")
    command_args = [program, script] + args
    p = subprocess.Popen(command_args,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE)

    try:
        stdout, stderr = p.communicate(timeout=time)
        output = ("{} ran without errors.\nOutput: \n{}".format(script,stdout.decode()))
        return output
    except subprocess.TimeoutExpired:
        print("The script {} has timed out after {} seconds.".format(script,time))
        p.kill()
        stdout, stderr = p.communicate()
        return(stdout.decode())

       
input_script = "fmr.R"
program = "Rscript"

runfmr = run_fmr(program, input_script)

# display the output
print(runfmr)