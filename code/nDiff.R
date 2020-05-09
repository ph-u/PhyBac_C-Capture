#!/bin/env Rscript

# Author:   PokMan Ho
# Script:   nDiff.R
# Desc:   	scan for discrepancies between numerical and analytical model solution scan
# Input: 	Rscript nDiff.R <iniPop>
# Output: 	../result/discrepancy_${i}.csv
# Arg: 		1
# Date: 	Apr 2020

##### env set-up #####
args = (commandArgs(T))
source("func.R")
rAw = read.csv("../result/maxYield_all.csv", header=T)
dIff = as.data.frame(matrix(NA,nr=nrow(rAw),nc=4))

##### discrepancies scan #####
for(i in 1:nrow(rAw)){
  pA = ebcData(iniPop=as.numeric(args[1]), parameter = unname(rAw[i,1:9]))
  dIff[i,] = pA[nrow(pA),-1]-rAw[i,10:13]
  if(i%%5e3==0){cat(paste0(round(i/nrow(rAw)*100),"% finished\n"))}
};rm(i)

##### result export #####
colnames(dIff) = paste0(colnames(rAw)[10:13],":num-ana")
eXport = cbind(rAw[,1:9],dIff)
cat("exporting result\n")
write.csv(eXport,paste0("../result/discrepancy_",args[1],".csv"), quote = F, row.names = F)
cat("done\n")
