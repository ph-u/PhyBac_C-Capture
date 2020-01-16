#!/bin/bash

## Author 		: PokMan Ho (pok.ho19@imperial.ac.uk)
## Script 		: d_trimSolar.sh
## Desc 		: organize 1947-2019 "global" solar data into csv files according to station location
## Input 		: ```bash d_trimSolar.sh <num_CPU_parallel>```
## Output 		: initiate all csv files for `d_trimSolCh.sh` child scripts
## Arguements 	: 1
## Date 		: Jan 2020

cd ../data

## 	add selected headers
p=`cat ../data/RO_Column_Headers.csv | tr -d " " | awk -F "," '{OFS=","}{print $3,$9}' | tr -s ","` # get header as text string | rm all " " | rm irrelevant cols | min rep sep

## 	add information columns
echo -e "Trim & Organize insolation data"

tail -n +2 solar1.csv | awk -F "," '{print $5}' | sort | uniq > uniqLoc.txt # get unique location from all times
locLine=`wc -l uniqLoc.txt | cut -f 1 -d " "` # count unique location

for i in `seq 1 ${locLine}`;do # add leading colname to every location
	uLoc=`head -n ${i} uniqLoc.txt | tail -n 1` # get location indicator
	echo -e "date,${p}" > solarGeoCleaned/solar_${uLoc}.csv # initiate csv record files with header line
done

msg0=1
for i in `ls yearly_files/midas*.txt`;do
	if [ $((${msg0} % 10)) -eq 0 ];then # show scan progress
		i0=`echo ${i} | cut -f 1 -d "." | cut -f 4 -d "_"`
		echo -e "Scan passed: ${i0}"
		date # show checkpoint time
	fi

	for j in `seq 1 ${locLine}`;do
		while [ `ps aux | grep mSolCh | grep -v grep | wc -l` -gt $1 ];do # cpu overflow protection, just in case
			sleep 5
		done

		uLoc=`head -n ${j} uniqLoc.txt | tail -n 1` # get location indicator
		grep ${uLoc} solar1.csv | awk -F "," '{print $1}' > incStat_${j}_${uLoc}.txt # get station id within Location
		../code/d_trimSolCh.sh ${i} ${j} ${uLoc} # organize solar data
	done

	msg0=`echo $((${msg0}+1))`
done

while [ `ps aux | grep mSolCh | grep -v grep | wc -l` -gt 0 ];do # wait for sorting to finish
	sleep 1
done

## clean
rm uniqLoc.txt
rm incStat_*

exit
