#!/bin/bash

## Author 		: PokMan Ho (pok.ho19@imperial.ac.uk)
## Script 		: d_trimSolCh.sh
## Desc 		: child script to `d_trimSolar.sh`
## Input 		: ```bash d_trimSolCh.sh <infile> <LocLine> <Location>```
## Output 		: `data/solarGeoCleaned/` subdirectory one csv file
## Arguements 	: 3
## Date 		: Jan 2020

cd ../data

## ensure only one child writing in one file each time
while [ `ps aux | grep olCh.sh | grep mSolC | grep $3` -gt 0 ];do
	sleep 1
done

locLin=`wc -l incStat_$2_$3.txt | cut -f 1 -d " "` # sep by " "
for k in `seq 1 ${locLin}`;do
	txtrp=`head -n ${k} incStat_$2_$3.txt | tail -n 1` # get grep pattern

	## organizing data
	awk -F "," -vq=" 1" -vx=${txtrp} '{OFS=","} $5==q && $7==x {print $3,$9}' $1 | # filter: MetQC==1, specific station; export: DateTime, irradiation
	sed -e "s/ /,/g" | tr -s "," | sed -e "s/^,//" >> solarGeoCleaned/solar_$3.csv
done

exit
