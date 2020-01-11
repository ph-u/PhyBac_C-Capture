#!/bin/bash

## Author 		: PokMan Ho (pok.ho19@imperial.ac.uk)
## Script 		: d_tearSolCh.sh
## Desc 		: child script for tear solar data blob by location
## Input 		: ```bash d_tearSolCh.sh <name>```
## Output 		: `data/solarGeoClearned/` subdirectory - one csv file from single location
## Arguements 	: 0
## Date 		: Jan 2020

grep $1 ../data/solarG.csv | # grep data with same location
awk -F "," '{OFS=","}{print $1,$2,$3}' > ../data/solarGeoCleaned/solar_$1.csv # print col: date, time, irradiation
