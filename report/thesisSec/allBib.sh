#!/bin/bash

## Author: 	PokMan Ho
## Script: 	allBib.sh
## Desc: 	scavange all bib contacted prior writing up
## Input: 	bash allBib.sh
## Output: 	bib bin
## Arg: 	0
## Date: 	Apr 2020

a0=`pwd` ## prep for full path for bibWrite.sh
ls ../../reference/bib/ > thesis.txt
bibWrite.sh ${a0}/thesis.txt ../../reference/bib/
rm ${a0}/thesis.txt
exit
