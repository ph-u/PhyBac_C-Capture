#!/usr/bin/env Rscript

# Author 	: PokMan HO
# Script 	: yieldPlot.R
# Desc 		: the combined plot for yield flux by each parameter
# Input 	: `Rscript yieldPlot.R`
# Output 	: none
# Arg 		: 0
# Date 		: Jul 2020

##### argument #####
paper = 7 ## graph reference width

##### in #####
source("graphVariables.R")
source("yieldWrangling.R")
lib = c("gridExtra","ggplot2")
invisible(lapply(lib,library,character.only=T));rm(lib)
ot = "../result/"

##### get maximum on each harvest system setting #####
ydMx = as.data.frame(matrix(NA,nr=0,nc=ncol(yield)))
colnames(ydMx) = colnames(yield)
for(i0 in unique(yield$system)){for(i1 in unique(yield$harvest)){
  ydMx = rbind(ydMx,yield[which(yield$yieldFlux==max(yield$yieldFlux[which(yield$system==i0 & yield$harvest==i1)])),])
}};rm(i0,i1)

##### yield flux by harvest & system mode on each parameter #####
yMAX = signif(max(yield$yieldFlux),2)
pt = ggplot()+theme_bw()+ylab("yield flux (gC/(m^3 day))")+ylim(0,yMAX)+
  scale_fill_manual(name="Harvest mode:", values = c(cBp[2,3],cBp[2,4]))+
  scale_colour_manual(name="Harvest mode:", values = c(cBp[1,3],cBp[1,4]))+
  scale_linetype_manual(name="System type:", labels=c("PBX", "PoX"), values = c(1,2))+
  scale_shape_manual(name="System type:", labels=c("PBX", "PoX"), values = c(1,2))+
  theme(axis.title = element_text(size = fontSize(paper)),
        axis.text = element_text(size = fontSize(paper)),
        legend.text = element_text(size = fontSize(paper)),
        legend.title = element_text(size = fontSize(paper)),
        legend.position = "none")
axTitle = c("(1/day)", "[no unit]","[no unit]","(1/day)","(m^3/(gC day))", "[no unit]","[no unit]","(m^3/(gC day))","(1/day)")

p_1 = pt+xlab(paste(colnames(yield)[1],axTitle[1]))+geom_smooth(aes(x=yield[,1], y=yield$yieldFlux, fill=yield$harvest, col=yield$harvest, linetype=yield$system), method = "gam", formula = y ~ s(x, bs = "cs"))+geom_text(aes(x=max(yield[,1]),y=yMAX/2,label=LETTERS[1]), size=fontSize(paper))+geom_point(aes(x=ydMx[,1], y=ydMx$yieldFlux, col=ydMx$harvest, shape=ydMx$system))
p_2 = pt+xlab(paste(colnames(yield)[2],axTitle[2]))+geom_smooth(aes(x=jitter(yield[,2]), y=yield$yieldFlux, fill=yield$harvest, col=yield$harvest, linetype=yield$system), method = "gam", formula = y ~ s(x, bs = "cs"))+geom_text(aes(x=max(yield[,2]),y=yMAX/2,label=LETTERS[2]), size=fontSize(paper))+geom_point(aes(x=ydMx[,2], y=ydMx$yieldFlux, col=ydMx$harvest, shape=ydMx$system)) ## without jitter ggplot won't plot; jitter smoothens the plot shape
p_3 = pt+xlab(paste(colnames(yield)[3],axTitle[3]))+geom_smooth(aes(x=yield[,3], y=yield$yieldFlux, fill=yield$harvest, col=yield$harvest, linetype=yield$system), method = "gam", formula = y ~ s(x, bs = "cs"))+geom_text(aes(x=max(yield[,3]),y=yMAX/2,label=LETTERS[3]), size=fontSize(paper))+geom_point(aes(x=ydMx[,3], y=ydMx$yieldFlux, col=ydMx$harvest, shape=ydMx$system))
p_4 = pt+xlab(paste(colnames(yield)[4],axTitle[4]))+geom_smooth(aes(x=jitter(yield[,4]), y=yield$yieldFlux, fill=yield$harvest, col=yield$harvest, linetype=yield$system), method = "gam", formula = y ~ s(x, bs = "cs"))+geom_text(aes(x=max(yield[,4]),y=yMAX/2,label=LETTERS[4]), size=fontSize(paper))+geom_point(aes(x=ydMx[,4], y=ydMx$yieldFlux, col=ydMx$harvest, shape=ydMx$system)) ## without jitter ggplot won't plot; jitter smoothens the plot shape
p_5 = pt+xlab(paste(colnames(yield)[5],axTitle[5]))+geom_smooth(aes(x=jitter(yield[,5]), y=yield$yieldFlux, fill=yield$harvest, col=yield$harvest, linetype=yield$system), method = "gam", formula = y ~ s(x, bs = "cs"))+geom_text(aes(x=max(yield[,5]),y=yMAX/2,label=LETTERS[5]), size=fontSize(paper))+geom_point(aes(x=ydMx[,5], y=ydMx$yieldFlux, col=ydMx$harvest, shape=ydMx$system)) ## without jitter ggplot won't plot; jitter smoothens the plot shape
p_6 = pt+xlab(paste(colnames(yield)[6],axTitle[6]))+geom_smooth(aes(x=yield[,6], y=yield$yieldFlux, fill=yield$harvest, col=yield$harvest, linetype=yield$system), method = "gam", formula = y ~ s(x, bs = "cs"))+geom_text(aes(x=max(yield[,6]),y=yMAX/2,label=LETTERS[6]), size=fontSize(paper))+geom_point(aes(x=ydMx[,6], y=ydMx$yieldFlux, col=ydMx$harvest, shape=ydMx$system))
p_7 = pt+xlab(paste(colnames(yield)[7],axTitle[7]))+geom_smooth(aes(x=yield[,7], y=yield$yieldFlux, fill=yield$harvest, col=yield$harvest, linetype=yield$system), method = "gam", formula = y ~ s(x, bs = "cs"))+geom_text(aes(x=max(yield[,7]),y=yMAX/2,label=LETTERS[7]), size=fontSize(paper))+geom_point(aes(x=ydMx[,7], y=ydMx$yieldFlux, col=ydMx$harvest, shape=ydMx$system))
p_8 = pt+xlab(paste(colnames(yield)[8],axTitle[8]))+geom_smooth(aes(x=yield[,8], y=yield$yieldFlux, fill=yield$harvest, col=yield$harvest, linetype=yield$system), method = "gam", formula = y ~ s(x, bs = "cs"))+geom_text(aes(x=max(yield[,8]),y=yMAX/2,label=LETTERS[8]), size=fontSize(paper))+geom_point(aes(x=ydMx[,8], y=ydMx$yieldFlux, col=ydMx$harvest, shape=ydMx$system))
p_9 = pt+xlab(paste(colnames(yield)[9],axTitle[9]))+geom_smooth(aes(x=yield[,9], y=yield$yieldFlux, fill=yield$harvest, col=yield$harvest, linetype=yield$system), method = "gam", formula = y ~ s(x, bs = "cs"))+geom_text(aes(x=max(yield[,9]),y=yMAX/2,label=LETTERS[9]), size=fontSize(paper))+geom_point(aes(x=ydMx[,9], y=ydMx$yieldFlux, col=ydMx$harvest, shape=ydMx$system))
p_L = ggplot()+theme_bw()+ylab("yield flux (gC/(m^3 day))")+ylim(0,yMAX+20)+
  scale_fill_manual(name="Harvest mode:", values = c(cBp[2,3],cBp[2,4]))+
  scale_colour_manual(name="Harvest mode:", values = c(cBp[1,3],cBp[1,4]))+
  scale_linetype_manual(name="System type:", labels=c("PBX", "PoX"), values = c(1,2))+
  scale_shape_manual(name="System type:", labels=c("PBX", "PoX"), values = c(1,2))+
  theme(axis.title = element_text(size = fontSize(paper)),
        axis.text = element_text(size = fontSize(paper)),
        legend.text = element_text(size = fontSize(paper)),
        legend.title = element_text(size = fontSize(paper)),
        legend.position = "bottom")+xlab(paste(colnames(yield)[9],axTitle[9]))+geom_smooth(aes(x=yield[,9], y=yield$yieldFlux, fill=yield$harvest, col=yield$harvest, linetype=yield$system), method = "gam", formula = y ~ s(x, bs = "cs"))+geom_text(aes(x=max(yield[,9]),y=yMAX/2,label=LETTERS[9]), size=fontSize(paper))+geom_point(aes(x=ydMx[,9], y=ydMx$yieldFlux, col=ydMx$harvest, shape=ydMx$system))
cat("yield by each parameter finished saving as variables, now plotting\n")

pdf(paste0(ot,"yieldFlux.pdf"), width = paper, height = paper*1.5)
suppressWarnings(grid.arrange(arrangeGrob(p_1, p_2, p_3, p_4, p_5, p_6, p_7, p_8, p_9, ncol=2), extract_legend(p_L), nrow=2, heights=c(10,1)))
invisible(dev.off())
rm(list=ls(pattern = "p_"));rm(axTitle,pt,yMAX)
cat("Carbon distribution plots finished\n")
