#!/bin/bash

## Author 		: PokMan Ho (pok.ho19@imperial.ac.uk)
## Script 		: hk_gen_readme.sh
## Desc 		: readme.md generator
## Input 		: ```bash hk_gen_readme.sh```
## Output 		: `readme.md` file
## Arguements 	: 0
## Date 		: Nov 2019

## self-orientation
p0=`dirname $0`
cd ${p0}

## head of real readme file
cp ../readme_head.md ../readme.md
echo -e "" >> ../readme.md ## force insert of an empty line at the bottom of target file

## insert each scripts as a section
for i in `ls | grep "\."`;do
    echo >> ../readme.md
    echo -e "### ${i}" >> ../readme.md
    echo >> ../readme.md
    echo -e "#### Features" >> ../readme.md
    echo >> ../readme.md
    grep "Desc " ${i}|cut -f 2 -d ":"|sed -e "s/ //1"|head -n 1 >> ../readme.md
    echo >> ../readme.md
    echo -e "#### Suggested input" >> ../readme.md
    echo >> ../readme.md
    grep "Input" ${i}|cut -f 2 -d ":"|sed -e "s/ //1"|head -n 1 >> ../readme.md
    echo >> ../readme.md
    echo -e "#### Expected Output" >> ../readme.md
    echo >> ../readme.md
    grep "Output" ${i}|cut -f 2 -d ":"|sed -e "s/ //1"|head -n 1 >> ../readme.md
    echo >> ../readme.md
    echo "*****" >> ../readme.md
done
exit
