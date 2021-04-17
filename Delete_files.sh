#!/bin/bash 

# This script will check on txt files in home directory, delete them and send mail;

path=$HOME
log-"./Desktop/log"
echo "Checking on files"
files=$(find $path -type f -name "*.txt" | wc -l)

if [ $files -gt 0 ];
then
find $path -type f -name "*.txt" -exec rm -f {} \;
echo "TXT files were deleted" >> $log
else
echo " No TXT files found" >> $log
fi

subject="Daily txt files check"
to="email address"

echo "Sending email"
mail -s "$subject" "$to" < $log
