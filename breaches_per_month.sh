#!/bin/bash

#Set filename input to variable

filename=$1

#ADD ERROR CHECKING LATER

#Create month name and count arrays
awk -F '\t' 'NR>1 {print $6}' $filename > monthsTemp.tsv
awk -F '\t' 'NR>1 {print $3}' $filename > countTemp.tsv

#read those values into arrays to be iterated over
readarray -t months_array < monthsTemp.tsv
readarray -t count_array < countTemp.tsv