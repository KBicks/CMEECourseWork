#!/bin/bash
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: MyExampleScript.sh
# Desc: prints two part message saying hello to user
# Arguments: msg1,msg2 -> alphanumeric string
# Date: 07 Oct 2018

msg1='Hello'
msg2=$USER
echo "$msg1 $msg2"
echo "Hello $USER"
echo

exit