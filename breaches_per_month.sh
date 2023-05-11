#!/bin/bash

#Set filename input to variable

filename=$1

#ADD ERROR CHECKING LATER

#Print the month for every single incident, sort them and compress the duplicates to get a total count for each month
awk -F '\t' 'NR>1 {print $6}' $filename | sort | uniq -c > total_and_months_temp.tsv
