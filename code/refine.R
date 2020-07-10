#!/usr/bin/env Rscript

# Author 	: PokMan HO
# Script 	: refine.R
# Desc 		: analytical scan using real-life parameter ranges
# Input 	: `Rscript refine.R`
# Output 	: `data/refine.txt`
# Arg 		: 0
# Date 		: Jul 2020

##### in #####
a = read.csv("../data/harvest.csv", header = T)

##### determine peak yield #####
plot(a$x,a$x*a$c3,pch=16)
a[which(log(a$x*a$c4)==max(log(a$x*a$c4),na.rm = T)),]
