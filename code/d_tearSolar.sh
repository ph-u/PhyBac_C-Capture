#!/bin/bash

## Author 		: PokMan Ho (pok.ho19@imperial.ac.uk)
## Script 		: d_tearSolar.sh
## Desc 		: parallel CPU tear solar data blob by location
## Input 		: ```bash d_tearSolar.sh <num_Intended_parallel_CPU>```
## Output 		: none - parallel call `d_tearSolCh.sh`, see child script
## Arguements 	: 1
## Date 		: Jan 2020

if [ -z $1 ];then
	num=2
else
	num=$1
fi

numLoc=`wc -l ../data/solarG.txt` # number of parallel models
echo -e "tear solar data blob by location, num of location = ${numLoc}, ${num} parallel extractions"

for i in `seq 1 ${nunLoc}`;do
	while [ `ps aux|grep tearS | grep lCh.sh | wc -l` -gt ${num} ];do # prevent resource overflow
		sleep 10
	done
	p=`head -n ${i} ../data/solarG.txt | tail -n 1`
	./d_tearSolCh.sh ${p} & # parallel extraction
done

while [ `ps aux|grep tearS | grep lCh.sh | wc -l` -gt 0 ];do # wait for last extraction finish
	sleep 1
done

exit
