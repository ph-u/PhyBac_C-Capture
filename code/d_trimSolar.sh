#!/bin/bash

## Author 		: PokMan Ho (pok.ho19@imperial.ac.uk)
## Script 		: d_trimSolar.sh
## Desc 		: combine global 1947-2019 solar data into single file
## Input 		: ```bash d_trimSolar.sh```
## Output 		: `data/` subdirectory - `solarT.csv`
## Arguements 	: 0
## Date 		: Jan 2020

cd ../data

## 	trim data, add header
rm solarT.csv 2> nohup.out
touch solarT.csv

## 	add selected headers
p=`cat ../data/RO_Column_Headers.csv | tr -d " " | awk -F "," '{OFS=","}{$1=$2=$4=$5=$6=$8=""; print $0}' | tr -s ","` # get header as text string | rm all " " | rm irrelevant cols | min rep sep
echo -e "date${p}" > solarT.csv # add leading colname

## 	add information columns
echo -e "Trim insolation data"
#awk -F "," '{OFS=","}{$1=$2=$4=$5=$6=$8=""; print $0}' test.csv | sed -e "s/ /,/g" | tr -s "," | sed -e "s/,//" >> solarT.csv
msg0=1
for i in `ls yearly_files/midas*.txt`;do
	if [ $((${msg0} % 10)) -eq 0 ];then # show scan progress
		i0=`echo ${i} | cut -f 1 -d "." | cut -f 4 -d "_"`
		echo -e "current progress: ${i0}"
	fi
	awk -F "," '{OFS=","}{$1=$2=$4=$5=$6=$8=""; print $0}' ${i} | sed -e "s/ /,/g" | tr -s "," | sed -e "s/,//" >> solarT.csv # rm irrelevant cols | all space to "," | min repeated " " | trim leading ","
	msg0=`echo $((${msg0}+1))`
done

## 	clean
rm nohup.out

exit
