#!/bin/bash
# # Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: variables.sh
# Desc: demonstrating the use of single and multiple variables
# Arguments: MyVar -> string, a,b,mysum-> numerical values
# Date: 07 Oct 2018

#Shows the use of variables
MyVar='some string'
echo 'the current value of the variable is' $MyVar
echo 'please enter a new string'
read MyVar
echo 'the current value of the variable is' $MyVar

## Reading multiple values
echo 'Enter two numbers separated by space(s)'
read a b 
echo 'you entered' $a 'and' $b '. Their sum is:'
mysum= expr $a + $b
echo $mysum

exit