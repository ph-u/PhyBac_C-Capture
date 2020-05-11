#!/bin/env Rscript

# Author:   PokMan Ho
# Script:   analytical_accuracy.R
# Desc:   	get accuracy trend from initial population effect
# Input: 	none
# Output: 	none
# Arg: 		0
# Date: 	Apr 2020

##### import #####
source("func.R")
aNa = read.csv("../result/maxYield_all.csv", header = T)
nD1e0 = read.csv("../result/discrepancy_1.csv", header = T)
nD1e2 = read.csv("../result/discrepancy_1e-2.csv", header = T)
nD1e3 = read.csv("../result/discrepancy_1e-3.csv", header = T)
nD1e4 = read.csv("../result/discrepancy_1e-4.csv", header = T)
nD1e5 = read.csv("../result/discrepancy_1e-5.csv", header = T)
nD1e11 = read.csv("../result/discrepancy_1e-11.csv", header = T)
nD1e12 = read.csv("../result/discrepancy_1e-12.csv", header = T)

##### plot extreme portion #####
tHres = .1
nPos = as.data.frame(matrix(NA,nr=7,nc=4))
colnames(nPos) = paste("extreme",c("C","P","B","A"))
for(i in 1:ncol(nPos)){nPos[,i]=c(length(which(nD1e0[,i+9]>=tHres | nD1e0[,i+9]<=-tHres)),
                                  length(which(nD1e2[,i+9]>=tHres | nD1e2[,i+9]<=-tHres)),
                                  length(which(nD1e3[,i+9]>=tHres | nD1e3[,i+9]<=-tHres)),
                                  length(which(nD1e4[,i+9]>=tHres | nD1e4[,i+9]<=-tHres)),
                                  length(which(nD1e5[,i+9]>=tHres | nD1e5[,i+9]<=-tHres)),
                                  length(which(nD1e11[,i+9]>=tHres | nD1e11[,i+9]<=-tHres)),
                                  length(which(nD1e12[,i+9]>=tHres | nD1e12[,i+9]<=-tHres)))};rm(i)
nPos$iniPop=c(1,1e-2,1e-3,1e-4,1e-5,1e-11,1e-12)

{png("../result/discrepancyByIniPop.png", height=600, width=600)
matplot(log10(nPos[,5]),nPos[,-5],type = "l", col = cBp[-c(3,5)], lty=1, lwd=5, xlab="log10 initial popoulation", ylab="number of extreme simulations with high discrepancy", main=paste("Extreme discrepancy threshold=",tHres))
legend("topright", inset=c(.1,0), bty="n", legend = colnames(nPos)[-5], pch = rep(16,4), col = cBp[-c(3,5)])
abline(v=-3, col="green", lwd=3, lty=2)
dev.off()}
