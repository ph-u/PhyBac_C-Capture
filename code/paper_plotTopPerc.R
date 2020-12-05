#!/bin/env Rscript

# author: ph-u
# script: paper_plotTopPerc.R
# desc: plot top percentage yield from P[oB][CD] systems
# in: Rscript paper_plotTopPerc.R
# out: none
# arg: 0
# date: 20201204

##### in #####
a = read.csv("../p_paperGraphics/totalPlot.csv", header=T)
cBp = data.frame(PBC=c("#E69F00","#E69F004D"), PBD=c("#000000","#0000001A"), PoC=c("#009E73","#009E734D"), PoD=c("#D55E00","#D55E004D"))

##### axis labels #####
axTitle = c(
  bquote(italic(x) ~ "(" ~ day^-1 ~ ")"),
  bquote(italic(e[PR]) ~ "( no unit )"),
  bquote(italic(e[P]) ~ "( no unit )"),
  bquote(italic(g[P]) ~ "(" ~ day^-1 ~ ")"),
  bquote(italic(a[P]) ~ "(" ~ m^3*gC^-1*day^-1 ~ ")"),
  bquote(italic(e[BR]) ~ "( no unit )"),
  bquote(italic(e[B]) ~ "( no unit )"),
  bquote(italic(g[B]) ~ "(" ~ m^3*gC^-1*day^-1 ~ ")"),
  bquote(italic(m[B]) ~ "(" ~ day^-1 ~ ")"),  
  expression("yield ( gCm"^"-3"*"day"^"-1"*")"),
  expression("log(yield+1) ( gCm"^"-3"*"day"^"-1"*")")
)

##### boxplot #####
for(i in 1:9){
  if(i==1){ ## by extraction rate
    pdf("../p_paperGraphics/00topxPlt.pdf", width=49, height=18)
    par(mar=c(5.5,5,.5,1), cex.lab=1.5, cex.axis=1.5)
  }else if(i==2){ ## by biological parameter
    pdf("../p_paperGraphics/00topPlot.pdf", width=14, height=18)
    par(mfrow=c(4,2), mar=c(5.5,5,.5,1), cex.lab=1.5, cex.axis=1.5)
  }
  boxplot(log(a$yield+1)~a$Src+a[,i], xaxt="n",xlab="",ylab="", pch=4,border=as.character(cBp[1,]),col=as.character(cBp[2,]))
  axis(side=1, at=seq(1,length(unique(a[,i]))*length(unique(a$Src)),length(unique(a$Src)))+1.5, labels=round(unique(a[,i])[order(as.numeric(unique(a[,i])))],2), las=2)
  mtext(axTitle[i], side=1, cex=1.5, adj=.49, padj=2+ifelse(i%in%c(1,2,3,6,7),ifelse(i==1,-3,1),0))
  mtext(axTitle[11], side=2, cex=1.5, adj=.7, padj=-.9)
  if(i<3){
      legend('topleft', ncol=ncol(cBp), bg=rgb(1,1,1,.9), legend=colnames(cBp), pch=16, col=as.character(cBp[1,]), box.col=rgb(1,1,1,1), cex=2)
  }
  if(i==1 || i==9){invisible(dev.off())}
};rm(i)
