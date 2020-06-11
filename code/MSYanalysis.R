#!/bin/env R

# Author 	: PokMan HO
# Script 	: MSYanalysis.R
# Desc 		: plot and analysis parameter sets with maximum sustainable yields (MSY)
# Input 	: none
# Output 	: plots
# Arg 		: 0
# Date 		: May 2020

##### notes #####
## for x=0, only the coexistence solution is numerically stable using this model

##### in #####
a = read.csv("../result/anaIRL.csv", header = T)
source("func.R")
ot = "../result/"
a.b = a ## create backup in case messed up
a[a==Inf] = a[a<0] = NA ## exclude meaningless result for later filtering

##### filter for compariable data set #####
# eXc = c();for(i in 14:21){
#   eXc = unique(c(eXc, which(is.na(a[,i])))) ## scan for excludable rows
# };rm(i)
# a0 = a[-eXc,-c(10:13)];rm(eXc) ## eliminate excludable rows & columns

##### total carbon log distribution P vs PB systems #####
a$log3C = log(a$eqm3C);a$log3A = log(a$eqm3A)
a$log4C = log(a$eqm4C);a$log4A = log(a$eqm4A)

w0 = wilcox.test(a$log3A,a$log4A) ## sig
png(paste0(ot,"hist_PvsPB_A.png"))
hist(a$log3A, breaks = seq(min(a$log3A, na.rm = T),max(a$log3A, na.rm = T),by=(max(a$log3A, na.rm = T)-min(a$log3A, na.rm = T))/100),
     col = rgb(.4,.1,1,.5), lty=2, xlim = c(-10,10), ylim = c(0,6e4),
     xlab = "log total carbon",
     main = "Histogram of log total carbon density on systems\nP only (purplish red) and P+B (light orange)")
hist(a$log4A, breaks = seq(min(a$log4A, na.rm = T),max(a$log4A, na.rm = T),by=(max(a$log4A, na.rm = T)-min(a$log4A, na.rm = T))/100),
     col = rgb(1,.3,.1,.2), lty=1, add = T)
text(x=-8, y=5e4, labels = paste0("Wilcoxon test:\nW = ",signif(as.numeric(w0$statistic),3),"\np = ",w0$p.value))
text(x=-6, y=4e4, labels = paste0("P: phytoplankton\nB: bacterial decomposer"))
dev.off()

w1 = wilcox.test(a$log3C,a$log4C) ## sig
png(paste0(ot,"hist_PvsPB_C.png"))
hist(a$log3C, breaks = seq(min(a$log3C, na.rm = T),max(a$log3C, na.rm = T),by=(max(a$log3C, na.rm = T)-min(a$log3C, na.rm = T))/100),
     col = rgb(.4,.1,1,.5), lty=2, xlim = c(-15,10), ylim = c(0,3.5e5),
     xlab = "log organic carbon",
     main = "Histogram of log organic carbon density on systems\nP only (purplish red) and P+B (light orange)")
hist(a$log4C, breaks = seq(min(a$log4C, na.rm = T),max(a$log4C, na.rm = T),by=(max(a$log4C, na.rm = T)-min(a$log4C, na.rm = T))/100),
     col = rgb(1,.3,.1,.2), lty=1, add = T)
text(x=-10, y=2e5, labels = paste0("Wilcoxon test:\nW = ",signif(as.numeric(w1$statistic),3),"\np = ",w1$p.value))
text(x=-10, y=1.5e5, labels = paste0("P: phytoplankton\nB: bacterial decomposer"))
dev.off()

##### why organic carbon fraction behaved choppy #####
uC = unique(a$log4C)
t.L4C = a[which(a$log4C==uC[2]),]
t.F=c();for(i in 1:9){if(length(unique(t.L4C[,i]))==1){t.F=c(t.F,i)}};rm(i)

##### yield calculation: feasibility vs MSY plot #####
a$yield3C = a$eqm3C*a$x
a$yield4C = a$eqm4C*a$x

##### plot fraction of MSY 5% allowance #####
tHh = quantile(c(a$yield3C,a$yield4C), probs = .95, na.rm = T)
a0 = c();for(i in c(1:5,8)){
  a0 = cbind(a0, unique(a[,i]))
};rm(i)
a0 = as.data.frame(a0)
colnames(a0) = c("x", "ePR", "eP", "gP", "aP", "gB")
a1 = a2 = a0
colnames(a1) = paste0("MSY3.",colnames(a0))
colnames(a2) = paste0("MSY4.",colnames(a0))
rEf = c(1:5,8);for(i in 1:ncol(a0)){for(j in 1:nrow(a0)){
  tmp = a[which(a[,rEf[i]]==a0[j,i]),]
  a1[j,i] = sum(tmp$yield3C>tHh, na.rm = T)/nrow(tmp)
  a2[j,i] = sum(tmp$yield4C>tHh, na.rm = T)/nrow(tmp)
}};rm(i,j,tmp)

{i=6
  a3 = cbind(a0[,i],a1[,i],a2[,i])
  colnames(a3) = c(colnames(a0)[i],colnames(a1)[i],colnames(a2)[i])
  png(paste0(ot,"MSY_",colnames(a0)[i],".png"))
  matplot(a3[,1],a3[,-1], type = "l",lty = 1,lwd = 5, col = cBp[c(3,2)],
          xlab = colnames(a0)[i], ylab = "fraction of top 5% carbon yield", main=paste0("Fraction of situations with sustainable yield flux\nranked top 5% (",round(tHh,2)," gC/(m^3 day)) against ",colnames(a0)[i]))
  legend("topleft", inset=c(0,0), legend = c("P only","P+B"), pch = rep(16,2), col = cBp[c(3,2)], bty="n", cex = 1.5)
  dev.off()
}

##### plot distribution of sustainable yield (SY) #####
{i=8 ## i=c(1:5,8)
  a0 = as.data.frame(matrix(NA,nc=7, nr=length(unique(a[,i]))))
  colnames(a0) = c(colnames(a)[i], paste0(rep(paste0("SY.",c("05","50","95"),"."),2),c(rep(3,3),rep(4,3))))
  a0[,1] = unique(a[,i])
  for(i0 in 1:nrow(a0)){ ## rec 95% distribution of data at every simulated batch
    t = a[which(a[,i]==a0[i0,1]),]
    a0[i0,2:4] = quantile(t$yield3C, probs = c(.05,.5,.95), na.rm = T)
    a0[i0,5:7] = quantile(t$yield4C, probs = c(.05,.5,.95), na.rm = T)
  };rm(i0,t)
  a0[is.na(a0)] = 0
  
  yLim = c(0,ceiling(max(a0[,-1])/10)*10) ## pre-set plot limits
  png(paste0(ot,"MSY_",colnames(a0)[1],"_d.png"))
  matplot(a0[,1],a0[,-1], type = "l",lty = rep(c(3,1,2),2),lwd = 5,col = c(rep(cBp[3],3),rep(cBp[2],3)), ylim = yLim,
          xlab = colnames(a0)[1], ylab = "sustainable yield 95% distribution (gC/day)", main=paste0("Susteinable Yield 95% distribution across\nparameter range of ",colnames(a0)[1]))
  legend("topleft", inset=c(0,0), legend = c("P only","P+B"), pch = rep(16,2), col = cBp[c(3,2)], bty="n", cex = 1.5)
  dev.off()
  
  png(paste0(ot,"MSY_",colnames(a0)[1],"_dLog.png"))
  matplot(a0[,1],log(a0[,-1]), type = "l",lty = rep(c(3,1,2),2),lwd = 5,col = c(rep(cBp[3],3),rep(cBp[2],3)),
          xlab = colnames(a0)[1], ylab = "log sustainable yield 95% distribution", main=paste0("Susteinable Yield 95% distribution across\nparameter range of ",colnames(a0)[1]))
  legend("topleft", inset=c(0,0), legend = c("P only","P+B"), pch = rep(16,2), col = cBp[c(3,2)], bty="n", cex = 1.5)
  dev.off()
}

##### plot fesibility vs yield #####
sy = quantile(c(a$yield3C,a$yield4C), probs = seq(0,1,.1), na.rm = T)
a0 = as.data.frame(matrix(NA,nc=3,nr=length(sy)))
colnames(a0) = c("SustainableYield", paste0("feasibility.",c(3,4)))
a0$SustainableYield = sy
for(i in 1:nrow(a0)){
  a0[i,-1] = c(length(which(a$yield3C>=a0[i,1])),length(which(a$yield4C>=a0[i,1])))/nrow(a)
};rm(i)

##### linear x-scale feasibility vs SY #####
png(paste0(ot,"MSY_",colnames(a0)[1],"_sy.png"))
matplot(a0[,1],a0[,-1], type = "l",lty = 1:2,lwd = 4,col = cBp[c(3,2)], ylim = c(0,.15),
        xlab = "sustainable yield (gC/day)",ylab = "feasibility fraction",main="Fraction of feasibility simulated within parameter space\nagainst sustainable yield")
legend("topright", inset=c(0,0), legend = c("P only","P+B"), pch = rep(16,2), col = cBp[c(3,2)], bty="n", cex = 1.5)
dev.off()

##### log x-scale feasibility vs SY #####
png(paste0(ot,"MSY_",colnames(a0)[1],"_syLog.png"))
matplot(log(a0[,1]),a0[,-1], type = "l",lty = 1:2,lwd = 4,col = cBp[c(3,2)], ylim = c(0,1),
        xlab = "log sustainable yield",ylab = "feasibility fraction",main="Fraction of feasibility simulated within parameter space\nagainst sustainable yield")
legend("topright", inset=c(0,0), legend = c("P only","P+B"), pch = rep(16,2), col = cBp[c(3,2)], bty="n", cex = 1.5)
dev.off()