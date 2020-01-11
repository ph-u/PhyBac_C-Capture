#!/bin/bash

## Author 		: PokMan Ho (pok.ho19@imperial.ac.uk)
## Script 		: d_rfcvSolar.sh
## Desc 		: organize solar reference curve data
## Input 		: ```bash d_rfcvSolar.sh```
## Output 		: `data/` subdirectory - solarREF.csv
## Arguements 	: 0
## Date 		: Jan 2020

cd ../data

echo -e "Organizing solar reference curve"

unzip astmg173.zip

endLine=`grep -n 2500.0, ASTMG173.csv |cut -f 1 -d ":"` # get line number for cleaned file ending in solar ref curve

head -n ${endLine} ASTMG173.csv | # get line before wavelength = 2500nm (near IR)
tail -n +2 | # trim descriptive title
awk -F "," '{OFS=","}{print $1,$4}' > solarCurve.csv # col: wavelength, solar power output

rm ASTMG173.csv
exit
