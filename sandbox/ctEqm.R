#!/bin/env Rscript

# Author:   PokMan Ho
# Script:   ctEqm.R
# Desc:   	count eqm position from numerical estimations
# Input: 	none
# Output: 	result csv
# Arg: 		0
# Date: 	Apr 2020

##### import #####
args = (commandArgs(T))
aNa = read.csv("../result/maxYield_all.csv", header = T)
aNA = read.csv("../result/maxYield_ALL.csv", header = T)
dAt = read.csv(paste0("../result/discrepancy_",args[1],".csv"), header = T)

nUm = aNa[,10:13]+dAt[,10:13]
##### function #####
iDeqm = function(df=nUm,ref=aNA){
  a0 = as.data.frame(matrix(0,nr=nrow(df),nc=5))
  colnames(a0)=1:ncol(a0)
  a1 = abs(df-ref[,10:13]); a0[,1]=a1[,1]+a1[,2]+a1[,3]
  a2 = abs(df-ref[,14:17]); a0[,2]=a2[,1]+a2[,2]+a2[,3]
  a3 = abs(df-ref[,18:21]); a0[,3]=a3[,1]+a3[,2]+a3[,3]
  a4 = abs(df-ref[,22:25]); a0[,4]=a4[,1]+a4[,2]+a4[,3]
  
  for(i in 1:nrow(a0)){if(any(a0[i,1:4]<10)){
    a0[i,5] = as.numeric(colnames(a0)[which(a0[i,1:4]==min(a0[i,1:4]))])
    if(i%%1e4==0){cat(paste0("i=",i/1e3,"K;",round(i/nrow(df)*100,2),"%\n"))}
  }};rm(i)
  return(a0)
}

##### scan #####
a=iDeqm()

cat("scan finished\n")

png(paste0("p_tmp/",args[1],".png"))
pie(table(a[,5]),main = paste0("Solution distribution for initial population=",args[1]))
dev.off()

write.table(a,paste0("p_tmp/",args[1],".csv"), sep=",", col.names = F,row.names = F)

