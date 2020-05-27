#!/bin/bash

# Author 	: PokMan HO
# Script 	: numScan0.sh <xMin> <xMax>  <ePRMin> <ePRMax> <ePMin> <ePMax>  <gPMin> <gPMax> <aPMin> <aPMax>  <eBRMin> <eBRMax> <eBMin> <eBMax>  <gBMin> <gBMax> <mBMin> <mBMax>
# Desc 		: master script for numerical scan of model
# Input 	: bash numScan0.sh
# Output 	: none
# Arg 		: 18
# Date 		: Apr 2020

echo -e "start identify parameter scan space"
Rscript numScan2.R $1 $2 $3 $4 $5 $6 $7 $8 $9 ${10} ${11} ${12} ${13} ${14} ${15} ${16} ${17} ${18}

echo -e "done space scan, start model scan"
date

toT=`wc -l ../data/nSref.txt | cut -f 1 -d ' '`
echo -e "x,ePR,eP,gP,aP,eBR,eB,gB,mB,eqmC,eqmP,eqmB,eqmA" > ../result/nScan.csv

for i in `seq 1 ${toT}`;do
	julia numScan1.jl `head -n ${i} ../data/nSref.txt | tail -n 1` &
	while [ `ps aux|grep numScan1|grep julia|wc -l` -gt 2 ];do
		sleep 10
	done
done

while [ `ps aux|grep numScan1|grep julia|wc -l` -gt 0 ];do
	echo -e "`ps aux|grep numScan1|grep julia|wc -l` processes yet"
	sleep 10
done

echo -e "done model scan, start result collect"
date
for i in `seq 1 ${toT}`;do
	tail -n +2 ../data/nS_${i}.csv >> ../result/nScan.csv
done
rm ../data/nS_*

echo -e "done result collect"
date
exit
