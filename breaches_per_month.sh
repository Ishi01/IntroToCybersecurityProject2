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
#Check to make sure number of entries in array is even, then calculate median
if [ $(($total_array_length%2)) -eq 0 ];
then
    #find the entry in the middle of the array if amount is even
    middle_entry=$(($total_array_length / 2))
    median=${total_array[middle_entry]}
else
    #find middle value if array is odd
    middle_entry=$((($total_array_length + 1) / 2))
    median=${total_array[middle_entry]}
fi

#Calculate median absolute deviation
#iterate over total array, calcuting absolute deviation for each value
for i in "${!total_array[@]}"
do
    operating_val=${total_array[i]}
    #calc absolute deviation for the value
    abs_dev_val=$(($operating_val-$median))
    #get absolute value of $abs_dev_val using parameter substitution to remove the - sign
    echo ${abs_dev_val#-}
done > abs_val_temp.tsv

sorted_abs_val_array=($(awk -F '\t' '{print $1}' abs_val_temp.tsv | sort -n))
rm abs_val_temp.tsv

echo "${sorted_abs_val_array[@]}"

#Find middle value, and make sure it can regardless of odd or even number of val
abs_array_length=${#sorted_abs_val_array[*]}
echo $abs_array_length
if [ $(($abs_array_length%2)) -eq 0 ];
then
    #find the entry in the middle of the array if amount is even
    middle_abs_entry=$(($abs_array_length / 2))
    median_abs_deviation=${sorted_abs_val_array[middle_abs_entry]}
else
    #find middle value if array is odd
    middle_abs_entry=$((($abs_array_length + 1) / 2))
    median_abs_deviation=${sorted_abs_val_array[middle_abs_entry]}
fi

echo $median_abs_deviation