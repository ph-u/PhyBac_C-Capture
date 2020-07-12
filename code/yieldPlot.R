#!/usr/bin/env Rscript

# Author 	: PokMan HO
# Script 	: yieldPlot.R
# Desc 		: determination of maximum yield flux for all systems
# Input 	: `Rscript yieldPlot.R`
# Output 	: none
# Arg 		: 0
# Date 		: Jul 2020

##### argument #####
paper = 7 ## graph reference width
yMAX = 180 ## plot y-axis maximum limit

##### in #####
source("graphVariables.R")
source("yieldWrangling.R")
lib = c("gridExtra","ggplot2")
invisible(lapply(lib,library,character.only=T));rm(lib)
ot = "../result/"

##### yield flux by harvest & system mode on each parameter #####
pt = ggplot()+theme_bw()+ylab("yield flux (gC/(m^3 day))")+
  scale_fill_manual(name="Harvest mode:", values = c(cBp[2,3],cBp[2,4]))+
  scale_colour_manual(name="Harvest mode:", values = c(cBp[1,3],cBp[1,4]))+
  scale_linetype_manual(name="System type:", labels=c("phytoplankton + bacteria", "phytoplankton only"), values = c(1,2))+
  theme(axis.title = element_text(size = fontSize(paper)),
        axis.text = element_text(size = fontSize(paper)),
        legend.text = element_text(size = fontSize(paper)),
        legend.title = element_text(size = fontSize(paper)),
        legend.position = "bottom")
axTitle = c("(1/day)", "[no unit]","[no unit]","(1/day)","(m^3/(gC day))", "[no unit]","[no unit]","(m^3/(gC day))","(1/day)")

p_1 = pt+xlab(paste(colnames(yield)[1],axTitle[1]))+geom_smooth(aes(x=yield[,1], y=yield$yieldFlux, fill=yield$harvest, col=yield$harvest, linetype=yield$system), method = "gam", formula = y ~ s(x, bs = "cs"))+geom_text(aes(x=min(yield[,1]),y=yMAX,label=LETTERS[1]), size=fontSize(paper))
p_2 = pt+xlab(paste(colnames(yield)[2],axTitle[2]))+geom_smooth(aes(x=jitter(yield[,2]), y=yield$yieldFlux, fill=yield$harvest, col=yield$harvest, linetype=yield$system), method = "gam", formula = y ~ s(x, bs = "cs"))+geom_text(aes(x=min(yield[,2]),y=yMAX,label=LETTERS[2]), size=fontSize(paper)) ## without jitter ggplot won't plot; jitter smoothens the plot shape
p_3 = pt+xlab(paste(colnames(yield)[3],axTitle[3]))+geom_smooth(aes(x=yield[,3], y=yield$yieldFlux, fill=yield$harvest, col=yield$harvest, linetype=yield$system), method = "gam", formula = y ~ s(x, bs = "cs"))+geom_text(aes(x=min(yield[,3]),y=yMAX,label=LETTERS[3]), size=fontSize(paper))
p_4 = pt+xlab(paste(colnames(yield)[4],axTitle[4]))+geom_smooth(aes(x=jitter(yield[,4]), y=yield$yieldFlux, fill=yield$harvest, col=yield$harvest, linetype=yield$system), method = "gam", formula = y ~ s(x, bs = "cs"))+geom_text(aes(x=min(yield[,4]),y=yMAX,label=LETTERS[4]), size=fontSize(paper)) ## without jitter ggplot won't plot; jitter smoothens the plot shape
p_5 = pt+xlab(paste(colnames(yield)[5],axTitle[5]))+geom_smooth(aes(x=jitter(yield[,5]), y=yield$yieldFlux, fill=yield$harvest, col=yield$harvest, linetype=yield$system), method = "gam", formula = y ~ s(x, bs = "cs"))+geom_text(aes(x=min(yield[,5]),y=yMAX,label=LETTERS[5]), size=fontSize(paper)) ## without jitter ggplot won't plot; jitter smoothens the plot shape
cat("yield by each parameter half-finished saving as variables\n")
p_6 = pt+xlab(paste(colnames(yield)[6],axTitle[6]))+geom_smooth(aes(x=yield[,6], y=yield$yieldFlux, fill=yield$harvest, col=yield$harvest, linetype=yield$system), method = "gam", formula = y ~ s(x, bs = "cs"))+geom_text(aes(x=min(yield[,6]),y=yMAX,label=LETTERS[6]), size=fontSize(paper))
p_7 = pt+xlab(paste(colnames(yield)[7],axTitle[7]))+geom_smooth(aes(x=yield[,7], y=yield$yieldFlux, fill=yield$harvest, col=yield$harvest, linetype=yield$system), method = "gam", formula = y ~ s(x, bs = "cs"))+geom_text(aes(x=min(yield[,7]),y=yMAX,label=LETTERS[7]), size=fontSize(paper))
p_8 = pt+xlab(paste(colnames(yield)[8],axTitle[8]))+geom_smooth(aes(x=yield[,8], y=yield$yieldFlux, fill=yield$harvest, col=yield$harvest, linetype=yield$system), method = "gam", formula = y ~ s(x, bs = "cs"))+geom_text(aes(x=min(yield[,8]),y=yMAX,label=LETTERS[8]), size=fontSize(paper))
p_9 = pt+xlab(paste(colnames(yield)[9],axTitle[9]))+geom_smooth(aes(x=yield[,9], y=yield$yieldFlux, fill=yield$harvest, col=yield$harvest, linetype=yield$system), method = "gam", formula = y ~ s(x, bs = "cs"))+geom_text(aes(x=min(yield[,9]),y=yMAX,label=LETTERS[9]), size=fontSize(paper))
cat("yield by each parameter finished saving as variables, now plotting\n")

pdf(paste0(ot,"yieldFlux.pdf"), width = paper, height = paper*2)
grid.arrange(p_1, p_2, p_3, p_4, p_5, p_6, p_7, p_8, p_9, ncol=2)
invisible(dev.off())
rm(list=ls(pattern = "p_"));rm(axTitle,pt,yMAX)
cat("Carbon distribution plots finished\n")
