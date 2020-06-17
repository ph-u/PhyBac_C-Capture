#!/bin/env R

# Author 	: PokMan HO
# Script 	: analysis.R
# Desc 		: modIRL.R result analyses
# Input 	: none
# Output 	: plots
# Arg 		: 0
# Date 		: Jun 2020

##### in #####
a = read.csv("../result/anaIRL.csv", header = T)
source("func.R")
ot = "../result/"
a[a==Inf] = a[a<0] = NA ## exclude meaningless result for later filtering
## yield calculation
a$yield3C = a$eqm3C*a$x
a$yield4C = a$eqm4C*a$x
## carbon magnitude calculation
a$log3C = log(a$eqm3C);a$log3A = log(a$eqm3A)
a$log4C = log(a$eqm4C);a$log4A = log(a$eqm4A)

##### system carbon distribution #####
## overall carbon
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

## organic carbon pool
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

##### where are the lowest final yield = lowest overall yield? #####
a.wtYield = a[which(a$x>0),]
a.woYield = a[which(a$x==0),]
a.minWtY3 = a.wtYield[which(a.wtYield$yield3C==min(a.wtYield$yield3C)),]
a.minWtY4 = a.wtYield[which(a.wtYield$yield4C==min(a.wtYield$yield4C)),]
## compare log distribution of with(out) harvest
png(paste0(ot,"a_logHist.png"), width = 700)
hist(log(a.woYield$eqm4A), breaks = seq(min(log(a.woYield$eqm4A), na.rm = T),max(log(a.woYield$eqm4A), na.rm = T), by=diff(range(log(a.woYield$eqm4A), na.rm = T))/100), freq = F, col = rgb(.4,.1,1,.2), lty=3, xlab = "Yield distribution", main = "Log final yield distributions", ylim = c(0,.8), xlim = c(-14,12))
hist(log(a.wtYield$yield3C), breaks = seq(min(log(a.wtYield$yield3C)),max(log(a.wtYield$yield3C)), by=diff(range(log(a.wtYield$yield3C)))/100), freq = F, col = rgb(1,.3,.1,.2), lty=2, add=T)
hist(log(a.wtYield$yield4C), breaks = seq(min(log(a.wtYield$yield4C)),max(log(a.wtYield$yield4C)), by=diff(range(log(a.wtYield$yield4C)))/100), freq = F, col = rgb(.7,.7,.1,.2), lty=1, add=T)
legend("topleft", inset=c(0,0), legend = c("P+B, no harvest", "P-only, with harvest", "P+B, with harvest"), pch = rep(16,3), col = c(rgb(.4,.1,1,.2), rgb(1,.3,.1,.2), rgb(.7,.7,.1,.2)), bty="n", cex = 1.5)
dev.off()