#!/usr/bin/env Rscript

# Author 	: PokMan HO
# Script 	: peakDetermination.R
# Desc 		: determination of maximum yield flux for all systems
# Input 	: `Rscript peakDetermination.R`
# Output 	: none
# Arg 		: 0
# Date 		: Jul 2020

##### argument #####
pErcent = 10
paper = 7

##### in #####
source("graphVariables.R")
lib = c("gridExtra","ggplot2","reshape2")
invisible(lapply(lib,library,character.only=T));rm(lib)
ot = "../result/"
a = read.csv("../data/continuous.csv", header = T)
d = read.csv("../data/destructive.csv", header = T)

##### remove unfeasible scenarios in systems with bacteria (PBH, PBN) #####
for(i in 13:ncol(a)){
  a[,i] = ifelse(a$b4>0 & is.finite(a$b4),a[,i],NA)
  d[,i] = ifelse(d$b4>0 & is.finite(d$b4),d[,i],NA)
};rm(i)

##### raw daily harvest yield flux distributions #####
plot(a$x,a$x*a$c3,pch=16, cex=.2) ## max yield >330
plot(a$x,a$x*a$c4,pch=16, cex=.2) ## max yield >250
plot(d$t+1,(d$c3+d$p3+d$b3)/(d$t+1),pch=16, cex=.2) ## max yield >330
plot(d$t+1,(d$c4+d$p4+d$b4)/(d$t+1),pch=16, cex=.2) ## max yield >230

##### extract top p% yield portion (p was determined above) #####
a$continuous3 = a$x*a$c3 ## yield in PoH systems
a$continuous4 = a$x*a$c4 ## yield in PBH systems
d$destruct3 = (d$c3+d$p3+d$b3)/(d$t+1) ## yield in PoN systems
d$destruct4 = (d$c4+d$p4+d$b4)/(d$t+1) ## yield in PBN systems
s.PBH = a[which(a$continuous4>=quantile(a$continuous4, probs = 1-pErcent/100, na.rm = T)),c("x","ePR","eP","gP","aP","eBR","eB","gB","mB","continuous4")]
s.PoH = a[which(a$continuous3>=quantile(a$continuous3, probs = 1-pErcent/100, na.rm = T)),c("x","ePR","eP","gP","aP","eBR","eB","gB","mB","continuous3")]
s.PBN = d[which(d$destruct4>=quantile(d$destruct4, probs = 1-pErcent/100, na.rm = T)),c("t","ePR","eP","gP","aP","eBR","eB","gB","mB","destruct4")]
s.PoN = d[which(d$destruct3>=quantile(d$destruct3, probs = 1-pErcent/100, na.rm = T)),c("t","ePR","eP","gP","aP","eBR","eB","gB","mB","destruct3")]

## restructure dataframes & merge ##
s.PBN$t = s.PBN$t+1
s.PoN$t = s.PoN$t+1
colnames(s.PBN)[1] = colnames(s.PoN)[1] = "x"
s.PBH$harvest = s.PoH$harvest = "continuous"
s.PBN$harvest = s.PoN$harvest = "destructive"
s.PBH$system = s.PBN$system = "PB"
s.PoH$system = s.PoN$system = "Po"
colnames(s.PBH)[10] = colnames(s.PoH)[10] = colnames(s.PBN)[10] = colnames(s.PoN)[10] = "yieldFlux"
yield = rbind(s.PBH,s.PoH,s.PBN,s.PoN)
rm(list = ls(pattern = "s."));rm(a,d,ref)

##### plot yield by harvest & system mode #####
pdf(paste0(ot,"yieldFlux.pdf"), width = paper, height = paper*.5)
ggplot()+theme_bw()+xlab("Harvest rate (1/day)")+ylab("yield flux (gC/(m^3 day))")+
                                          scale_fill_manual(name="Harvest mode:", values = c(cBp[2,3],cBp[2,4]))+
                                          scale_colour_manual(name="Harvest mode:", values = c(cBp[1,3],cBp[1,4]))+
                                          scale_linetype_manual(name="System type:", labels=c("phytoplankton + bacteria", "phytoplankton only"), values = c(1,3))+
                                          geom_smooth(aes(x=yield$x, y=yield$yieldFlux, fill=yield$harvest, col=yield$harvest, linetype=yield$system), method = "gam", formula = y ~ s(x, bs = "cs"))+
                                    theme(axis.title = element_text(size = fontSize(paper)),
                                          axis.text = element_text(size = fontSize(paper)),
                                          legend.text = element_text(size = fontSize(paper)),
                                          legend.title = element_text(size = fontSize(paper)),
                                          legend.position = "bottom")
invisible(dev.off())
cat("Carbon distribution comparison boxplot finished\n")

##### yield flux by biological parameter #####
par(mfrow=c(4,2))
for(i in 1:ncol(ref)){
  plot(a.0[,i+1],a.0$x*a.0$c3, type = "p",pch=16, xlab = colnames(a.0)[i+1], ylab = "yield flux gC/(m^3day)")
};rm(i)
