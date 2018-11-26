#!/bin/bash
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: MyExampleScript.sh
# Desc: Exemplifies setting variables and returning within a string.
# Arguments: msg1,msg2 -> alphanumeric string
# Date: 07 Oct 2018

# set values of variables
msg1='Hello'
# $USER prints signifies name of user running script
msg2=$USER
# print variables, showing how same results can be produced by settingg
# variables and inputting directly into a string.
echo "$msg1 $msg2"
echo "Hello $USER"
# just command echo adds a blank line
echo

exit