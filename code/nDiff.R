#!/bin/env Rscript

# Author:   PokMan Ho
# Script:   nDiff.R
# Desc:   	scan for discrepancies between numerical and analytical model solution scan
# Input: 	Rscript nDiff.R
# Output: 	../result/discrepancy.csv
# Arg: 		none
# Date: 	Apr 2020

##### env set-up #####
source("func.R")
rAw = read.csv("../result/maxYield_all.csv", header=T)
dIff = as.data.frame(matrix(NA,nr=nrow(rAw),nc=4))

##### discrepancies scan #####
for(i in 1:nrow(rAw)){
  pA = ebcData(parameter = unname(rAw[i,1:9]))
  dIff[i,] = pA[nrow(pA),-1]-rAw[i,10:13]
};rm(i)

##### result export #####
colnames(dIff) = paste0(colnames(rAw)[10:13],":num-ana")
eXport = cbind(rAw[,1:9],dIff)
write.csv(eXport,"../result/discrepancy.csv", quote = F, row.names = F)
