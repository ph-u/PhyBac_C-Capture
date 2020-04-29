#!/bin/env Rscript

# Author: 	PokMan HO (hpokman@connect.hku.hk)
# Script: 	nSplt.R
# Desc: 	plot contourplots for parameter scan result
# Input: 	none
# Output: 	graph/ctr_${i}.png
# Arg: 		0
# Date: 	Apr 2020

##### pkg in #####
library(lattice)

##### data in #####
rAw = read.csv("../result/nScan.csv",header = T)
rAw[rAw<=0] =NA
uNiqRAW = vector(mode = "list");for(i in 1:9){uNiqRAW[[i]] = unique(rAw[,i])};rm(i)

lvpLt = function(pLt, rAw, uNiqRAW){
  ##### dataframe filter #####
  #pLt = c(0,1,1,1,0,1,1,1,1,13) ## parameter selection
  for(i in 1:length(uNiqRAW)){ ## check request within scanned boundary
    if(length(uNiqRAW[[i]])<pLt[i]){
      cat(paste0("col ",i," request out of bounds, return to max value ",length(uNiqRAW[[i]]),"\n"))
      pLt[i] = length(uNiqRAW[[i]])
    }
  };rm(i)
  aXis = which(pLt<1)
  oRi = rAw
  for(i in 1:(length(pLt)-1)){if(pLt[i]!=0){
    oRi = oRi[which(oRi[,i]==uNiqRAW[[i]][pLt[i]]),]
  }};rm(i)
  
  ##### levelplot #####
  tiTle = paste0("Density of ",colnames(oRi)[pLt[length(pLt)]])
  for(i in 1:length(uNiqRAW)){if(pLt[i]!=0){
    tiTle = paste0(tiTle,", ",colnames(oRi)[i],"=",uNiqRAW[[i]][pLt[i]])
    if(i==6){tiTle = paste0(tiTle,"\n")}
  }};rm(i)
  levelplot(oRi[,pLt[length(pLt)]]~oRi[,aXis[1]]*oRi[,aXis[2]], xlab=colnames(oRi)[aXis[1]], ylab=colnames(oRi)[aXis[2]], main=tiTle, col.regions = rev(gray(30:70/100)))
}

lvpLt(c(0,1,1,2,0,1,1,3,1,13), rAw, uNiqRAW)
