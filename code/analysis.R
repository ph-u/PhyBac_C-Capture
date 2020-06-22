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
library(gridExtra)
library(ggplot2)
ot = "../result/"
a = read.csv("../data/anaIRL.csv", header = T)
## yield calculation
a$yield3C = log(a$eqm3C*ifelse(a$x==0,1,a$x))
a$yield4C = log(a$eqm4C*ifelse(a$x==0,1,a$x))
## carbon magnitude calculation
a$log3C = log(a$eqm3C);a$log3A = log(a$eqm3A)
a$log4C = log(a$eqm4C);a$log4A = log(a$eqm4A)
## exclude meaningless result for later filtering
a[a==Inf] = a[a==-Inf] = NA

##### overview plot based on harvest rate #####
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

##### distribution across biological parameters #####
## restructure dataframe
{a.bx = rbind(a,a)
a.bx$log4C[1:nrow(a)]=a$log3C
a.bx$log4A[1:nrow(a)]=a$log3A
a.bx$yield4C[1:nrow(a)]=a$yield3C
a.bx$yield3C = a.bx$log3C = a.bx$log3A = NULL
a.bx$eqm = c(rep("P_only",nrow(a)),rep("P+B",nrow(a)))
colnames(a.bx)[22:24] = c("yield","logC","logA")
a.pt = rbind(a.bx,a.bx,a.bx)
a.pt$logA[1:nrow(a.bx)] = a.bx$yield
a.pt$logA[1:nrow(a.bx)+nrow(a.bx)] = a.bx$logC
a.pt$Source = c(rep(colnames(a.bx)[22],nrow(a.bx)),rep(colnames(a.bx)[23],nrow(a.bx)),rep(colnames(a.bx)[24],nrow(a.bx)))
colnames(a.pt)[24] = "value"
a.pt$yield = a.pt$logC = NULL
}

## line plots with 95% confidence interval
xX=.9;{a.Ln = a.pt[which(a.pt$x==xX),]
p_tmp = ggplot()+theme_bw()+ylim(c(-9,5)) + ylab(paste0("natural log eqm values, harvest = ",xX," day^-1")) + scale_fill_manual(name="system", values = cBpT[c(4,2)])+scale_colour_manual(name="system", values = cBp[c(4,2)])+scale_linetype_manual(name="type", labels=c("total carbon", "C pool", "yield"), values = c(1,2,4))

p_2 = p_tmp + xlab(colnames(a.Ln)[2]) + geom_smooth(aes(x=a.Ln[,2], y=a.Ln$value, fill=a.Ln$eqm, col=a.Ln$eqm, linetype=a.Ln$Source))
p_3 = p_tmp + xlab(colnames(a.Ln)[3]) + geom_smooth(aes(x=a.Ln[,3], y=a.Ln$value, fill=a.Ln$eqm, col=a.Ln$eqm, linetype=a.Ln$Source))
p_4 = p_tmp + xlab(colnames(a.Ln)[4]) + geom_smooth(aes(x=a.Ln[,4], y=a.Ln$value, fill=a.Ln$eqm, col=a.Ln$eqm, linetype=a.Ln$Source))
p_5 = p_tmp + xlab(colnames(a.Ln)[5]) + geom_smooth(aes(x=a.Ln[,5], y=a.Ln$value, fill=a.Ln$eqm, col=a.Ln$eqm, linetype=a.Ln$Source))
p_6 = p_tmp + xlab(colnames(a.Ln)[6]) + geom_smooth(aes(x=a.Ln[,6], y=a.Ln$value, fill=a.Ln$eqm, col=a.Ln$eqm, linetype=a.Ln$Source))
p_7 = p_tmp + xlab(colnames(a.Ln)[7]) + geom_smooth(aes(x=a.Ln[,7], y=a.Ln$value, fill=a.Ln$eqm, col=a.Ln$eqm, linetype=a.Ln$Source))
p_8 = p_tmp + xlab(colnames(a.Ln)[8]) + geom_smooth(aes(x=a.Ln[,8], y=a.Ln$value, fill=a.Ln$eqm, col=a.Ln$eqm, linetype=a.Ln$Source))
p_9 = p_tmp + xlab(colnames(a.Ln)[9]) + geom_smooth(aes(x=a.Ln[,9], y=a.Ln$value, fill=a.Ln$eqm, col=a.Ln$eqm, linetype=a.Ln$Source))

};{
        png(paste0(ot,"var_",ifelse(xX<1,"0",""),xX*10,".png"), res = 100, width = 2000, height = 700)
        grid.arrange(p_2, p_3, p_4, p_5, p_6, p_7, p_8, p_9, nrow=2)
        dev.off()
};rm(list=ls(pattern = "p_"));rm(xX, a.Ln)
