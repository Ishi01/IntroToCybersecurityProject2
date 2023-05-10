#!/bin/bash

#set $1 to filename for clarity
filename=$1

#ADD MORE SANITY CHECKS

#Check to make sure file is not empty
if [ ! -s "$filename" ];
then
	echo "File must exist and not be empty"!
	exit 1
fi

#Check if file is in correct .tsv format
if [[ $filename != *".tsv"* ]];
then
	echo "File must be in the .tsv format"
	exit 1
fi

#Make sure file has correct number of columns
numFields=$(awk -F '\t' 'NR<2{print NF}' $filename)

if [ $numFields != 7 ];
then
	echo "File must have correct number of columns (7)"
	exit 1
fi




#Remove location and summary columns from data (and temporarily remove type of breach so it can be edited and re-added)
awk -F '\t' '{print $1"\t"$2"\t"$3"\t"$4}' $filename > temp.tsv


#Extract the date information that we want from the columns

#Extracting month info
#Print the column with dates, cut off everything after the first /, remove leading zeroes and save to temporary file
awk -F '\t' 'BEGIN{print "Month"} NR>1 { print $4 }' $filename | cut -f1 -d'/' | sed 's/^0*//' > monthsTemp.tsv

#Extract year info
awk -F '\t' 'BEGIN{print "Year"} NR>1 { print $4 }' $filename | cut -f1 -d'-' | sed 's/.*\///' > yearsTemp1.tsv

#Extract Type_of_Breach info, remove everything after the first / or , and save it to temp file
awk -F '\t' 'BEGIN{print "Type_of_Breach"} NR>1 { print $5 }' $filename | cut -f1 -d'/' | cut -f1 -d',' > typeOfBreachTemp.tsv

#read contents of yearsTemp into array to be iterated over
readarray -t year_array < yearsTemp1.tsv

#Iterate over each item
for i in "${!year_array[@]}";
do
	#declare value as num in current index
	value=${year_array[$i]}
	#Remove extra spaces from the values
	year_array[i]="${value// /}"
	
	#Check if value is 2 characters long
	iLength="${#value}"
	if [ "$iLength" -eq 2 ]
	then
		#Check if value is from before or after 2000, if it's before, add 19 to front, else add 20
		#Use 10# to force bash to read them as decimal even through the leading zeroes
		if (("10#$value" >= 25 && "10#$value" <=99));
		then
			year_array[i]="19$value"
		else
			year_array[i]="20$value"
		fi
	fi
done

#Read edited year_array array back into the temp file
printf "%s\n" "${year_array[@]}" > yearsTemp2.tsv


#append month data file with the overall data file using paste
paste temp.tsv typeOfBreachTemp.tsv monthsTemp.tsv yearsTemp2.tsv > Cyber_Security_Breaches_clean.tsv

#remove all of the temp files
rm temp.tsv
rm typeOfBreachTemp.tsv
rm monthsTemp.tsv
rm yearsTemp1.tsv
rm yearsTemp2.tsv