#!/bin/env R

# Author 	: PokMan HO
# Script 	: analysis.R
# Desc 		: modIRL.R result analyses
# Input 	: run this script in R console; graphs can't be run via automated loops
# Output 	: plots in `result/`
# Arg 		: 0
# Date 		: Jun 2020

##### in #####
source("func.R")
ot = "../result/"
cBpA = as.data.frame(col2rgb(cBp)/255);cBpA[4,] = .3;cBpA[4,1] = .1
cBpT = rep(NA,length(cBp));for(i in 1:ncol(cBpA)){cBpT[i] = rgb(cBpA[1,i],cBpA[2,i],cBpA[3,i],cBpA[4,i])};rm(i,cBpA)

a = read.csv("../data/anaIRL.csv", header = T)
## yield calculation
a$yield3C = log(a$eqm3C*ifelse(a$x==0,1,a$x))
a$yield4C = log(a$eqm4C*ifelse(a$x==0,1,a$x))
## carbon magnitude calculation
a$log3C = log(a$eqm3C);a$log3A = log(a$eqm3A)
a$log4C = log(a$eqm4C);a$log4A = log(a$eqm4A)
## exclude meaningless result for later filtering
a[a==Inf] = a[a==-Inf] = NA

## seq(.1,1, by=.1)
xX = 1;{
##### carbon distribution #####
w.total = wilcox.test(a$log3A[which(a$x==xX)], a$log4A[which(a$x==xX)])
w.orgCb = wilcox.test(a$log3C[which(a$x==xX)], a$log4C[which(a$x==xX)])
w.yield = wilcox.test(a$yield3C[which(a$x==xX)], a$yield4C[which(a$x==xX)])

png(paste0(ot,"sys_",ifelse(xX<1,"0",""),xX*10,".png"), res = 200, width = 2000, height = 700)
par(mfrow = c(1,3))
## total carbon
hist(a$log3A[which(a$x==xX)], breaks = seq(min(a$log3A[which(a$x==xX)], na.rm = T),max(a$log3A[which(a$x==xX)], na.rm = T),by=diff(range(a$log3A[which(a$x==xX)], na.rm = T))/100),
     col = cBpT[4], lty=1, freq = F, xlim = range(c(a$log3A,a$log4A), na.rm = T), ylim = c(0,.5),
     xlab = paste0("log TOTAL carbon, removal rate = ",xX, " day^-1"), main = "")
hist(a$log4A[which(a$x==xX)], breaks = seq(min(a$log4A[which(a$x==xX)], na.rm = T),max(a$log4A[which(a$x==xX)], na.rm = T),by=diff(range(a$log4A[which(a$x==xX)], na.rm = T))/100),
          col = cBpT[2], lty=1, freq = F, add=T)
text(x=-3, y=.4, labels = paste0("Wilcoxon test:\nW = ",signif(as.numeric(w.total$statistic),3)," (3 s.f.)\np = ",round(as.numeric(w.total$p.value),4)," (4 d.p.)"))
legend("topright", inset=c(0,0), legend = c("P_only","P+B"), pch = rep(16,2), col = c(cBpT[4],cBpT[2]), bty="n", cex = 1.2)

## organic carbon
hist(a$log3C[which(a$x==xX)], breaks = seq(min(a$log3C[which(a$x==xX)], na.rm = T),max(a$log3C[which(a$x==xX)], na.rm = T),by=diff(range(a$log3C[which(a$x==xX)], na.rm = T))/100),
     col = cBpT[4], lty=1, freq = F, xlim = range(c(a$log3C,a$log4C), na.rm = T), ylim = c(0,.5),
     xlab = paste0("log ORGANIC carbon, removal rate = ",xX, " day^-1"), main = "")
hist(a$log4C[which(a$x==xX)], breaks = seq(min(a$log4C[which(a$x==xX)], na.rm = T),max(a$log4C[which(a$x==xX)], na.rm = T),by=diff(range(a$log4C[which(a$x==xX)], na.rm = T))/100),
          col = cBpT[2], lty=1, freq = F, add=T)
text(x=-8, y=.4, labels = paste0("Wilcoxon test:\nW = ",signif(as.numeric(w.orgCb$statistic),3)," (3 s.f.)\np = ",round(as.numeric(w.orgCb$p.value),4)," (4 d.p.)"))

## yield
hist(a$yield3C[which(a$x==xX)], breaks = seq(min(a$yield3C[which(a$x==xX)], na.rm = T),max(a$yield3C[which(a$x==xX)], na.rm = T),by=diff(range(a$yield3C[which(a$x==xX)], na.rm = T))/100),
     col = cBpT[4], lty=1, freq = F, xlim = range(c(a$yield3C,a$yield4C), na.rm = T), ylim = c(0,.5),
     xlab = paste0("log yield flux, removal rate = ",xX, " day^-1"), main = "")
hist(a$yield4C[which(a$x==xX)], breaks = seq(min(a$yield4C[which(a$x==xX)], na.rm = T),max(a$yield4C[which(a$x==xX)], na.rm = T),by=diff(range(a$yield4C[which(a$x==xX)], na.rm = T))/100),
          col = cBpT[2], lty=1, freq = F, add=T)
text(x=-8, y=.4, labels = paste0("Wilcoxon test:\nW = ",signif(as.numeric(w.yield$statistic),3)," (3 s.f.)\np = ",round(as.numeric(w.yield$p.value),4)," (4 d.p.)"))

dev.off()
}
