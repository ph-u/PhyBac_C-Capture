#!/usr/bin/env Rscript

# Author 	: PokMan HO
# Script 	: yieldWrangling.R
# Desc 		: collect and wrangle all scenario simulation data
# Input 	: `source("../code/yieldWrangling.R")` in R scripts
# Output 	: none
# Arg 		: 0
# Date 		: Jul 2020

##### in #####
a = read.csv("../data/continuous.csv", header = T)
d = read.csv("../data/destructive.csv", header = T)
cat("data input finished\n")

##### NA unfeasible PBX system results #####
for(i in 13:ncol(a)){
  a[,i] = ifelse(a$b4>0 & is.finite(a$b4),a[,i],0)
  d[,i] = ifelse(d$b4>0 & is.finite(d$b4),d[,i],0)
};rm(i)

##### rearrange overall dataframe #####
a$PoH = a$x*a$c3 ## yield in PoH systems
a$PBH = a$x*a$c4 ## yield in PBH systems
d$PoN = (d$c3+d$p3+d$b3-(d$c3[1]+d$p3[1]+d$b3[1]))/d$x ## yield in PoN systems
d$PBN = (d$c4+d$p4+d$b4-(d$c4[1]+d$p4[1]+d$b4[1]))/d$x ## yield in PBN systems
a[,c(10:15)] = d[,c(10:15)] = NULL
for(i in 2:9){ ## bit-wise number handling in python and C cause record slight differences
  a[,i] = round(a[,i],4)
  d[,i] = round(d[,i],4)
};rm(i)
yield = merge(a,d,by=intersect(names(a),names(d)), all = T)
rm(a,d)
cat("data is ready\n")
