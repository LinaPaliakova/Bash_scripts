#!/bin/bash

# Script updates data of csv file with employee data  in accordance with requirements: 1) name field: format first letter of name/surname uppercase and all other letters lowercase.
# 2) email field: first letter from name and full surname,lowercase and @abc.com


file=$1

 cat "$file" |  awk  'BEGIN {OFS=FS=","}; NR>1, NF>=2 {  $7= tolower($5) ;
split($7, arr, " ");
 
$7 = substr(arr[1], 1, 1) arr[2]  "@abc.com";

 

} (1)' > account1.csv
cat account1.csv |  awk  'BEGIN {OFS=FS=","};NR>1{ $5 = tolower($5);split ($5, arr, " ");

 for (i in arr)
 sub(arr[i], toupper(substr(arr[i], 1 ,1))substr(arr[i], 2), $5)


}1'  > account1_new.csv
