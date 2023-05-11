#!/bin/bash

#Set filename input to variable

filename=$1

#ADD ERROR CHECKING LATER

#Print the month for every single incident, sort them and compress the duplicates to get a total count for each month, then save to file
awk -F '\t' 'NR>1 {print $6}' $filename | sort | uniq -c | awk '{print $2"\t"$1}' > months_total_temp.tsv

#Sort the file by total number of incidents
sort -t$'\t' -k2 -n months_total_temp.tsv > months_total_temp2.tsv
#Remove extra temp file
rm months_total_temp.tsv
#read out totals into variable
total_array=($(awk '{print $2}' months_total_temp2.tsv))

#Find length of total_array
total_array_length=${#total_array[*]}
#echo "$total_array_length"
#Check to make sure number of entries in array is even, then calculate median
if [ $(($total_array_length%2)) -eq 0 ];
then
    #find the entry in the middle of the array
    middle_entry=$(($total_array_length / 2))
    median=${total_array[middle_entry]}
else
    middle_entry=$((($total_array_length + 1) / 2))
    median=${total_array[middle_entry]}
fi

echo $median
