#!/bin/bash

## Author 		: PokMan Ho (pok.ho19@imperial.ac.uk)
## Script 		: d_dataComb.sh
## Desc 		: combine global 1947-2019 solar data into single file
## Input 		: ```bash d_dataComb.sh```
## Output 		: csv file in `data/` directory
## Arguements 	: 0
## Date 		: Dec 2019

## set working directory
cd ../data

## initialize solar reference data
rm solarRef.csv 2> nohup.out
touch solarRef.csv

## combine solar reference data
i0=0
for i in `ls yearly_files/*.txt`;do
	
	## show progress if necessary
	i0=`echo $((${i0}+1))`
	if [ $((${i0} % 10)) -eq 0 ];then
		i1=`ls yearly_files/*.txt|wc -l`
		i1=`echo ${i0} / ${i1} *100|bc -l|cut -f 1 -d "."`
		echo -e "combine solar data ${i1}%"
	fi

	cat ${i} >> solarRef.csv ## data combination
done
echo -e "combine solar data 100%"

rm nohup.out ## cleanup (comented when inside workflow)

exit
