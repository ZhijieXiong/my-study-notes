#!/bin/bash

echo "the current process is $$"
echo "the last one daemon process is $!"
read -t 20 -p "Please enter your name:" name
read -t 20 -s -p "Please enter your password:" passwd
echo -e "\n"
echo "name: $name"
echo "passwd: $passwd"
echo "end!"
