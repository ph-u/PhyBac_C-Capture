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
d = read.csv("../data/destructive_Lin.csv", header = T)
L = read.csv("../data/destructive_Log.csv", header = T)
cat("data input finished\n")

## graphics show difference in data handling
a0 = a
d0 = d
L0 = L

##### NA unfeasible PBX system results #####
for(i in 13:ncol(a)){
  a[,i] = ifelse(a$b4>=0 & is.finite(a$b4),a[,i],NA)
  d[,i] = ifelse(d$b4>=0 & is.finite(d$b4),d[,i],NA)
  L[,i] = ifelse(L$b4>=0 & is.finite(L$b4),L[,i],NA)
  a0[,i] = ifelse(a0$b4>=0 & is.finite(a0$b4),a0[,i],0)
  d0[,i] = ifelse(d0$b4>=0 & is.finite(d0$b4),d0[,i],0)
  L0[,i] = ifelse(L0$b4>=0 & is.finite(L0$b4),L0[,i],0)
};rm(i)
rawL = L
rawL$x = rawL$x-1

##### daily yield #####
a$PoC = a$x*a$c3 ## yield in PoH systems
a$PBC = a$x*a$c4 ## yield in PBH systems
d$PoD = (d$c3+d$p3+d$b3-(d$c3[1]+d$p3[1]+d$b3[1]))/d$x ## yield in PoN systems
d$PBD = (d$c4+d$p4+d$b4-(d$c4[1]+d$p4[1]+d$b4[1]))/d$x ## yield in PBN systems
L$PoD = (L$c3+L$p3+L$b3-(L$c3[1]+L$p3[1]+L$b3[1]))/L$x ## yield in PoN systems in log time space
L$PBD = (L$c4+L$p4+L$b4-(L$c4[1]+L$p4[1]+L$b4[1]))/L$x ## yield in PBN systems in log time space
a0$PoC = a0$x*a0$c3 ## yield in PoH systems
a0$PBC = a0$x*a0$c4 ## yield in PBH systems
d0$PoD = (d0$c3+d0$p3+d0$b3-(d0$c3[1]+d0$p3[1]+d0$b3[1]))/d0$x ## yield in PoN systems
d0$PBD = (d0$c4+d0$p4+d0$b4-(d0$c4[1]+d0$p4[1]+d0$b4[1]))/d0$x ## yield in PBN systems
L0$PoD = (L0$c3+L0$p3+L0$b3-(L0$c3[1]+L0$p3[1]+L0$b3[1]))/L0$x ## yield in PoN systems in log time space
L0$PBD = (L0$c4+L0$p4+L0$b4-(L0$c4[1]+L0$p4[1]+L0$b4[1]))/L0$x ## yield in PBN systems in log time space

a[,c(10:15)] = d[,c(10:15)] = L[,c(10:15)] = a0[,c(10:15)] = d0[,c(10:15)] = L0[,c(10:15)] = NULL
for(i in 2:9){ ## bit-wise number handling in python and C cause record slight differences
  a[,i] = round(a[,i],4)
  d[,i] = round(d[,i],4)
  L[,i] = round(L[,i],4)
  a0[,i] = round(a0[,i],4)
  d0[,i] = round(d0[,i],4)
  L0[,i] = round(L0[,i],4)
};rm(i)
yield = merge(a,d,by=intersect(names(a),names(d)), all = T)
yield = merge(yield,L,by=intersect(names(yield),names(L)), all = T)
yield0 = merge(a0,d0,by=intersect(names(a0),names(d0)), all = T)
yield0 = merge(yield0,L0,by=intersect(names(yield0),names(L0)), all = T)
rm(a,d,L,a0,d0,L0)
cat("data is ready\n")
