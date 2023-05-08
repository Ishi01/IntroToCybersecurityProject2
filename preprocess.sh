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

#Add months column to file

#Print all date info from column
#remove everthing after the first slash, since the month is
#awk -F '\t' 'BEGIN{NR==1 {print }}'NR>1 { print $4 }' $filename | cut -f1 -d'/' | sed 's/^0*//' > tmp 

#Remove location and summary columns from data
awk -F '\t' '{print $1"\t"$2"\t"$3"\t"$4"\t"$5}' $filename > temp.tsv

#Extract the date information that we want from the columns

#Extracting month info
#Print the column with dates, cut off everything after the first /, remove leading zeroes and save to temporary file
awk -F '\t' 'BEGIN{print "Month"} NR>1 { print $4 }' $filename | cut -f1 -d'/' | sed 's/^0*//' > temp2.tsv

#Extract year info

#append month data file with the overall data file using paste
paste temp.tsv temp2.tsv > temp3.tsv