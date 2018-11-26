#!/bin/bash
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: variables.sh
# Desc: Exemplifies setting variables within the script and from the terminal.
# Arguments: MyVar -> alphanumeric string, a,b,mysum-> numerical
# Date: 07 Oct 2018

# Shows use of variables
# Set intial value of variable
MyVar='some string'
# returns value of variable
echo 'the current value of the variable is' $MyVar
echo 'please enter a new string'
# requests user to enter a value
read MyVar
# can be used to indicate whether variable has been accepted
echo 'the current value of the variable is' $MyVar

# Reading multiple values
echo 'Enter two numbers separated by space(s)'
# asks for input of 2 values
read a b 
echo 'you entered' $a 'and' $b '. Their sum is:'
# adds the two entered numbers and sets them to the variable mysum
mysum= expr $a + $b
echo $mysum

# exits script
exit