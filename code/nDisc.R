#!/bin/env Rscript

# Author 	: PokMan Ho
# Script 	: nDisc.R
# Desc 		: plot discrepancy.csv result, showing parameter-wise solution differences between analytical and numerical approaches
# Input 	: none
# Output 	: ../sandbox/graph/
# Arg 		: none
# Date 		: Apr 2020

##### import #####
library(lattice)
rAw = read.csv("../result/discrepancy.csv", header = T)
cBp <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#0072B2", "#D55E00", "#CC79A7", "#e79f00", "#9ad0f3", "#F0E442", "#999999", "#cccccc", "#6633ff", "#00FFCC", "#0066cc")
uNiqRAW = vector(mode = "list")
for(i in 1:9){uNiqRAW[[i]] = unique(rAw[,i])};rm(i)

##### functions #####
diffPlt = function(xyzAxis = c(1,5,13), defaultPara = c(1,1,1,1,1,1,1,1,1), data = rAw){
  ## a function plotting discrepancies between numerical and analytical approach solution differences
  ## xyzAxis: column index for the axes
  ## defaultPara: column indecies for parameter value used in uniqList for data trimming
  ## data: raw data for plotting
  
  ## create list of unique parameter values
  uQraw = vector(mode = "list")
  for(i in 1:length(defaultPara)){uQraw[[i]] = unique(rAw[,i])};rm(i)
  
  ## check defaultPara values valid
  for(i in 1:length(defaultPara)){if(
    i%in%xyzAxis==F & defaultPara[i] > length(uQraw[[i]])){
    defaultPara[i] = length(uQraw[[i]])
    cat(paste0("parameter ",i," index for ",colnames(data)[i]," out of boundary, switch to max value ",length(uQraw[[i]])))
  }}
  
  ## trim data
  #data[,(length(defaultPara)+1):ncol(data)] = abs(data[,(length(defaultPara)+1):ncol(data)])
  for(i in 1:length(defaultPara)){if(i%in%xyzAxis==F){data = data[which(data[,i]==uQraw[[i]][defaultPara[i]]),]}}
  
  ## plot
  vAl = rep(NA,length(defaultPara))
  for(i in 1:length(defaultPara)){vAl[i] = uQraw[[i]][defaultPara[i]]}
  tiTle = paste0("Solution discrepancy plot of ", colnames(data)[xyzAxis[3]], "\nwith ", paste0(colnames(data)[1:length(defaultPara)], "=", vAl, collapse = ", "))
  levelplot(data[,xyzAxis[3]]~data[,xyzAxis[1]]*data[,xyzAxis[2]], xlab=colnames(data)[xyzAxis[1]], ylab=colnames(data)[xyzAxis[2]], main=tiTle, col.regions = rev(gray(30:80/100)))
  #contourplot(data[,xyzAxis[3]]~data[,xyzAxis[1]]*data[,xyzAxis[2]], xlab=colnames(data)[xyzAxis[1]], ylab=colnames(data)[xyzAxis[2]], main=tiTle)
}

png("../sandbox/graph/discrepancy.png")
plot(ecdf(rAw[,10]), xlim=c(-1,1), xlab="discrepancy", ylab="cumulative density", lwd=4, col=cBp[1], main="Cumulative density plot of discrepancies between\nnumerical and analytical solutions");lines(ecdf(rAw[,11]), col=cBp[3], lwd=4);lines(ecdf(rAw[,12]), col=cBp[6], lwd=4);lines(ecdf(rAw[,13]), col=cBp[5], lwd=4)
legend("topleft", legend = paste0("eqm",c("C","P","B","A")," discrepancy"), pch=rep(16,4), col=cBp[c(1,3,6,5)], bty="n")
dev.off()

##### identify categories of discrepancy #####
idRef = as.data.frame(matrix(NA, nc=4, nr=9))
colnames(idRef) = paste0("eqm",c("C","P","B","A"))
rownames(idRef) = paste0(c(0,1,10,25,50,75,90,99,100)," percent")
for(i in 1:ncol(idRef)){
  cat(paste0("identifying for col ",i,"\n"))
  idRef[,i] = unname(quantile(rAw[,9+i], prob=c(0,.01,.1,.25,.5,.75,.9,.99,1)))
};rm(i)

##### grab situations of huge discrepancy #####
dIsc = rAw[which(rAw[,10]<idRef[3,1] | rAw[,10]>idRef[7,1] | rAw[,11]<idRef[3,2] | rAw[,11]>idRef[7,2] | rAw[,12]<idRef[3,3] | rAw[,12]>idRef[7,3] | rAw[,13]<idRef[3,4] | rAw[,13]>idRef[7,4]),]
uQdIsc = vector(mode = "list")
for(i in 1:9){uQdIsc[[i]] = unique(dIsc[,i])};rm(i)
for(i in 1:9){cat(paste0("raw-extreme ",length(uNiqRAW[[i]])-length(uQdIsc[[i]]),"\n"))};rm(i) ## result: no parameter specificity
