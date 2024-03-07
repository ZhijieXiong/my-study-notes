#!/bin/bash

echo -e "the command is $0\n"
echo -e "the first parameter is $1\n"
echo -e "the second parameter is $2\n"
for i in "$*"
	do
		echo -e "the all parameter are $i\n"
	done
for j in "$@"
	do
		echo -e "the all parameter are $j\n"
	done
echo "the total number of parameters is $#"
