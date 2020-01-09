#!/bin/bash

## Author 		: PokMan Ho (pok.ho19@imperial.ac.uk)
## Script 		: d_extStation.sh
## Desc 		: extract all station info from yearly data files
## Input 		: ```bash d_extStation.sh```
## Output 		: `data/` directory - `solarRef.txt`
## Arguements 	: 0
## Date 		: Jan 2020

cd ../data
rm solarR.txt 2> ../code/nohup.out
touch solarR.txt

echo -e "extract station id data"

for i in `ls yearly_files/mi*.txt`;do
	awk -F "," '{print $7}' ${i} | sort | uniq >> solarR.txt
	# extract station data per year
done

exit
