#!/bin/bash

# Author 	: PokMan Ho
# Script 	: project.sh
# Desc 		: main script for project reproduction
# Input 	: `bash project.sh`
# Output 	: none; see respective scripts
# Arg 		: 0
# Date 		: Jul 2020

cd `dirname $0` 						## set working directory to `code/`
rm -r ../result/ 2> tmp 				## clear output folder
mkdir ../result/ 						## remake `result/` directory
for i in continuous destructive gRate scenario;do
	rm ../data/${i}.csv 				## remove intermediate data
done

Rscript rateDet.R 						## temperature standardisation
Rscript scenario.R 						## set LHS scenario samples
python3 destructiveHarvest.py 12000 & 	## numerical yield calculation
bash continuousHarvest.sh 1 20000 200 	## analytical yield calculation

bash writeREADME.sh 					## write readme for project

rm tmp
echo -e "Project reproduced"
exit

