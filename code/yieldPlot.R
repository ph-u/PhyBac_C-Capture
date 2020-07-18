#!/usr/bin/env Rscript

# Author 	: PokMan HO
# Script 	: yieldPlot.R
# Desc 		: the combined plot for yield flux by each parameter
# Input 	: `Rscript yieldPlot.R`
# Output 	: `result/yieldFlux.pdf`
# Arg 		: 0
# Date 		: Jul 2020

##### argument #####
paper = 7 ## graph reference width
pbs=.2 ## top percentage boundary
sYs = c("PoH","PBH","PoN","PBN") ## system settings
selRange = c(101,1001,10001) ## harvest rate/interval selection

##### in #####
source("graphVariables.R")
source("yieldWrangling.R")
library(reshape2)
ot = "../result/"

##### get maximum on each system setting #####
ydMx = as.data.frame(matrix(NA,nr=0,nc=ncol(yield)))
colnames(ydMx) = colnames(yield)
for(i in 10:ncol(yield)){ ## get maximum for each system
  ydMx = rbind(ydMx,yield[which(yield[,i]==max(yield[,i], na.rm = T)),])
};rm(i)
for(i in 10:ncol(ydMx)){ ## filter only maximum for each system
  ydMx[,i] = ifelse(ydMx[,i]==max(ydMx[,i],na.rm = T),ydMx[,i],NA)
};rm(i)

##### plot yield by parameter #####
axTitle = c("harvest rate", "non-respirable\ncarbon fraction for P","carbon fraction allocated\ninto biomass for P","P growth rate","P intraspecific interference", "non-respirable\ncarbon fraction for B","carbon fraction allocated\ninto biomass for B","B resource clearance rate","B death rate")

pdf(paste0(ot,"yieldFlux.pdf"), width = paper, height = paper*1.2)
par(mfrow=c(4,2),mar=c(5, 4, 1, .2), xpd=T)
for(i in 2:9){
  t = as.data.frame(matrix(NA,nr = length(unique(yield[,i])), nc=5))
  t[,1] = unique(yield[,i])[order(unique(yield[,i]))]
  for(i0 in 1:nrow(t)){
    t0 = yield[which(yield[,i]==t[i0,1]),]
    t1 = rep(NA,4)
    for(i1 in 1:length(t1)){
      t1[i1] = quantile(t0[,9+i1], probs = (100-pbs)/100)
    }
    t[i0,-1] = t1
  }
  colnames(t) = colnames(yield)[c(i,10:13)]
  matplot(t[,1],t[,-1], xlab = paste(axTitle[i],"(",colnames(t)[1],")"), ylab = paste0("top ",pbs,"% yield"),type = "l", lwd = 1, lty = rep(1:2,each=2), col = rep(c(cBp[1,4],cBp[1,3]),2), ylim = c(0,max(ydMx[,-c(1:9)], na.rm = T)))
  matplot(ydMx[,i],ydMx[,10:13], pch=rep(3:4,each=2), col = rep(c(cBp[1,4],cBp[1,3]),2), add=T)
  text(max(t[,1]),max(ydMx[,10:13],na.rm = T)*.4,LETTERS[i-1], cex = 2)
};rm(i,i0,i1,t0)
legend("bottomleft", inset=c(-.2,-.55), ncol = 4, bty = "n", legend = sYs,pch = rep(3:4,each=2), lty = rep(1:2,each=2), col = rep(c(cBp[1,4],cBp[1,3]),2))
invisible(dev.off())

##### yield difference under different settings #####
yd = yield[which(yield$x %in% selRange),-c(10:11)]
yd = melt(yd, id.vars = colnames(yd)[1:9], measure.vars = colnames(yd)[-c(1:9)])
# pairwise.wilcox.test(yd$value,interaction(yd$variable,yd$x), p.adjust.method = "bonferroni", paired = F)

yd0 = yield[which(yield$x %in% selRange),-c(12:13)]
yd0 = melt(yd0, id.vars = colnames(yd0)[1:9], measure.vars = colnames(yd0)[-c(1:9)])
# pairwise.wilcox.test(yd0$value,interaction(yd0$variable,yd0$x), p.adjust.method = "bonferroni", paired = F)

pdf(paste0(ot,"Harvest.pdf"), width = paper*1.5, height = paper*.7)
par(mfrow=c(1,2),mar=c(5, 4, 1, .2), xpd=T)

boxplot(log(yd$value+1)~interaction(yd$variable,yd$x), pch=3, cex=.3, xlab = "System\nHarvest interval (1/day)", ylab = "ln(yield+1)", xaxt="n")
axis(side = 1, at=1:length(unique(interaction(yd$variable,yd$x))), labels = paste0(sYs[3:4],"\n",rep(selRange, each=2)), padj = .3)
text(length(unique(interaction(yd$variable,yd$x)))+.3,max(log(yd$value+1),na.rm = T)*.4,LETTERS[1], cex = 2)

boxplot(log(yd0$value+1)~interaction(yd0$variable,yd0$x), pch=3, cex=.3, xlab = "System\nHarvest rate (1/day)", ylab = "ln(yield+1)", xaxt="n")
axis(side = 1, at=1:length(unique(interaction(yd$variable,yd$x))), labels = paste0(sYs[1:2],"\n",rep(selRange, each=2)), padj = .3)
text(length(unique(interaction(yd0$variable,yd0$x)))+.3,max(log(yd0$value+1),na.rm = T)*.4,LETTERS[2], cex = 2)

invisible(dev.off())

cat("Carbon distribution plots finished\n")
