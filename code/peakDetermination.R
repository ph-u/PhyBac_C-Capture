#!/usr/bin/env Rscript

# Author 	: PokMan HO
# Script 	: peakDetermination.R
# Desc 		: determination of maximum yield flux for all systems
# Input 	: `Rscript peakDetermination.R`
# Output 	: none
# Arg 		: 0
# Date 		: Jul 2020

##### in #####
a = read.csv("../data/continuous.csv", header = T)
b = read.csv("../data/continuous1.csv", header = T)
d = read.csv("../data/destructive.csv", header = T)
ref = read.csv("../data/scenario.csv", header = T)

##### determine peak yield: PBH #####
par(mfrow=c(1,1))
ggplot()+geom_line(aes(x=a$x,y=a$x*a$c3,))
plot(a$x,a$x*a$c3,pch=16,type = "l")
a[which(a$x*a$c4==max(a$x*a$c4,na.rm = T)),]

##### determine peak yield: PoH #####
cHg = c();for(i0 in 1:nrow(ref)){
  a.0 = a
  for(i in 1:ncol(ref)){a.0 = a.0[which(a.0[,i+1]==ref[i0,i]),]}
  # par(mfrow=c(3,3))
  # for(i in 1:9){plot(a.0[,i],a.0$x*a.0$c3, type = "l",pch=16, xlab = paste0(colnames(a.0)[i],", ",i0), ylab = "yield flux gC/(m^3day)")}
  if(diff(range(a.0$x*a.0$c3))>0.001){cHg = c(cHg,i0)}
  if(i0%%500==0){cat(paste("pass scenario",i0,";",round(i0/nrow(ref)*100,2),"% done\n"))}
};rm(i,i0);if(length(cHg)==0){
  a.0 = a[which(a$x==unique(a$x)[1]),]
  rm(cHg)
}
par(mfrow=c(4,2))
for(i in 1:ncol(ref)){
  plot(a.0[,i+1],a.0$x*a.0$c3, type = "p",pch=16, xlab = colnames(a.0)[i+1], ylab = "yield flux gC/(m^3day)")
};rm(i)

##### determine peak yield: PBN, PoN #####
