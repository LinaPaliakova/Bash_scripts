#!/bin/bash 

# This script will check on txt files in provided directory and delete them;

path=$1
files=$(find $path -type f -name "*.txt" )

for i in ${files[@]}; do
echo "Deleting $i files"
rm i
done





