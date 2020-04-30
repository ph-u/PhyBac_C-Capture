#!/bin/env Rscript

# Author: 	PokMan HO
# Script: 	numScan2.R
# Desc: 	generate runID and parameter values
# Input: 	Rscript numScan2.R <xMin> <xMax>  <ePRMin> <ePRMax> <ePMin> <ePMax>  <gPMin> <gPMax> <aPMin> <aPMax>  <eBRMin> <eBRMax> <eBMin> <eBMax>  <gBMin> <gBMax> <mBMin> <mBMax>
# Output: 	../data/nS_para.txt
# Arg: 		18
# Date: 	Apr 2020

##### env set-up #####
args = (commandArgs(T))
aRg = as.data.frame(matrix(as.numeric(args),nr=2))
aRg[3,] = (aRg[1,]+aRg[2,])/nrow(aRg)
aRgDiff = which(aRg[1,]!=aRg[2,])
rEs = as.data.frame(matrix(NA,nc=9,nr=nrow(aRg)^length(aRgDiff))) ## dataframe with 9 parameters and rows equal to number of parameter variation

##### parameters fill-up #####
rEs[,which(aRg[1,]==aRg[2,])] = aRg[1,which(aRg[1,]==aRg[2,])] ## static variables
for(i in 1:length(aRgDiff)){
  tmp = c()
  for(i0 in 1:nrow(aRg)){tmp = c(tmp, rep(aRg[i0,rev(aRgDiff)[i]],3^(i-1)))}
  rEs[,rev(aRgDiff)[i]] = tmp
};rm(i,tmp,i0)

##### export txt #####
write.table(rEs,"../data/nSref.txt", col.names = F, sep = " ",quote = F)
