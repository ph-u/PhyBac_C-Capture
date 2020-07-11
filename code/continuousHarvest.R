#!/usr/bin/env Rscript

# Author 	: PokMan HO
# Script 	: continuousHarvest.R
# Desc 		: continuous harvest scenarios model run (analytical calculation)
# Input 	: `Rscript analytical.R [min x] [max x] [system number]`
# Output 	: `data/continuous_N.csv`
# Arg 		: 3
# Date 		: Jul 2020

##### in #####
aRg = as.numeric(commandArgs(T))
source("func.R")
x = seq(aRg[1], aRg[2], signif(diff(aRg)/10,1)) ## random rates, main point of investigation
a = read.csv("../data/scenario.csv", header = T)

##### data collection preparation #####
rEs = as.data.frame(matrix(NA, nc=6, nr=length(x)*nrow(a)))
colnames(rEs) = paste0(c("c","p","b"),rep(3:4,each=3))

##### scan #####
x0=a0=r0=1 ## index for x, a, rEs
cat(paste("start analytical scan: x =",aRg[1],"-",aRg[2],"; total number of samples =",nrow(rEs),"\n"))
repeat{
  rEs[r0,] = ebcAlt(c(x[x0],as.numeric(a[a0,])),1)
  if(r0==nrow(rEs)){break}else{r0 = r0+1; a0 = a0+1}
  if(a0>nrow(a)){a0 = 1; x0 = x0+1
  cat(paste0(round(x0/length(x)*100,2),"% out of ",length(x)," done\n"))
  }
};rm(x0,a0,r0)

##### construct result data #####
oUt = cbind(x=rep(x,each=nrow(a)),a,rEs)
write.csv(oUt,paste0("../data/continuous_",aRg[3],".csv"), row.names = F, quote = F)
