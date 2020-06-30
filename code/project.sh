#!/bin/bash

# Author: 	PokMan Ho
# Script: 	project.sh
# Desc: 	main script for project reproduction
# Input: 	`bash project.sh`
# Output: 	none; see respective scripts
# Arg: 		0
# Date: 	Jun 2020

cd `dirname $0` 						## set working directory to `code/`
rm -r ../result/ 2> tmp 				## clear output folder
mkdir ../result/ 						## remake `result/` directory

Rscript rateDet.R 						## temperature standardisation
Rscript modIRL.R 						## analytical parameter scan
Rscript analysis.R 						## model result analysis

bash writeREADME.sh 					## write readme for project

rm tmp
echo -e "Project reproduced"
exit

