#!/bin/bash

## Author 		: PokMan Ho
## Script 		: hk_luaLTX.sh
## Desc 		: use lualatex as .tex file compiler
## Input 		: ```nohup bash hk_luaLTX.sh <tex with .tex> <optional/output/path/>```
## Output 		: pdf file in designated directory
## Arguements 	: 1 or 2
## Date 		: Nov 2019

## check pid of compilation: ps aux |grep Ho_Pok_Man|grep luaLTX|grep prop|awk '{OFS="\t"}{print $2}'

if [ -z "$1" ];then

echo
echo -e "nohup <ThisScript> <tex with .tex> <optional/output/path/>"
echo
exit

fi

current=`pwd`
cd `dirname $1`

a=`basename $1|cut -d . -f 1`
if [ -z "$2" ];then
	a1=`dirname $1`
else a1=$2
fi

for i in `seq 1 4`;do
	echo -e "doing round ${i}"
	lualatex $1 # pdflatex/lualatex/xelatex $1
	if [[ i -eq 2 ]];then bibtex ${a};fi
done

## Cleanup
echo -e "cleaning"
for i in aux dvi nav out snm toc bbl bcf blg run.xml synctex.gz lof lot;do
if [ `ls|grep -c ${i}` -gt 0 ];then
rm *.${i}
fi
done

if [ `ls|grep -c "blx.bib"` -gt 0 ];then
rm *blx.bib
fi


if [ `pwd` != ${current} ];then
rm ${current}/nohup.out
fi

## move result pdf
mv ${a}.pdf ${a1}/${a}.pdf
