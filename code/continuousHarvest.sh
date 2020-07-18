#!/bin/bash

## Author 		: PokMan Ho
## Script 		: continuousHarvest.sh
## Desc 		: continuous harvest scenarios model run (analytical calculation)
## Input 		: ```bash continuousHarvest.sh [min x] [max x] [samples]```
## Output 		: `data/continuous.csv`
## Arguements 	: 2
## Date 		: Jul 2020

##### self-orientation #####
p0=`dirname $0`
cd ${p0}

##### in #####
minX=`echo $1` ## minimum harvest rate
maxX=`echo $2` ## maximum harvest rate
samX=`echo $(($3-1))` ## number of regular-interval samples within the harvest rate range

##### analytical scan preparation #####
gcc stablePositions.c -o p_sP ## set up calculator
echo -e "x,`head -n 1 ../data/scenario.csv`,c3,p3,b3,c4,p4,b4" > ../data/continuous.csv ## initialise record file
intX=`echo "(${maxX}-${minX})/${samX}"|bc` ## get harvest rate interval size
numScenario=`wc -l ../data/scenario.csv|cut -f 1 -d " "` ## get number of sampled scenarios

##### looping calculation #####
counterX=1
for i0 in `eval echo {${minX}..${maxX}..${intX}}`;do ## loop over sequence of harvest rate
    if [ $((${counterX}%10)) -eq 1 ];then
        calPass=`wc -l ../data/continuous.csv|cut -f 1 -d " "`
        curX=`echo "${counterX}/(${samX}+1)*100"|bc -l|cut -f 1 -d "."`
        echo -e "continuous: harvest rate = ${i0}, ${curX}% done; `date`"
    fi
    for i1 in `eval echo {2..${numScenario}}`;do ## loop over sampled scenarios
        ./p_sP ${i0} `head -n ${i1} ../data/scenario.csv|tail -n 1|sed -e 's/,/ /g'` 1>> ../data/continuous.csv ## scenario calculation
    done
    counterX=`echo $((${counterX}+1))`
done

rm p_sP
exit
