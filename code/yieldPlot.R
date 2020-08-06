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
selRange = c(100,1000,10000) ## harvest rate selection
selInter = c(.5,5,50) ## harvest interval selection

##### in #####
source("graphVariables.R")
source("yieldWrangling.R")
library(reshape2)
ot = "../result/"
sYs = colnames(yield)[10:13] ## system settings

##### get maximum on each system setting #####
ydMx = as.data.frame(matrix(NA,nr=0,nc=ncol(yield)))
colnames(ydMx) = colnames(yield)
for(i in 10:ncol(yield)){ ## get maximum for each system
  ydMx = rbind(ydMx,yield[which(yield[,i]==max(yield[,i], na.rm = T)),])
};rm(i)
for(i in 10:ncol(ydMx)){ ## filter only maximum for each system
  ydMx[,i] = ifelse(ydMx[,i]==max(ydMx[,i],na.rm = T),ydMx[,i],NA)
};rm(i)

##### count unfavourable/unfeasible systems #####
# for(i in 10:ncol(yield)){
#   i01 = sum(yield[,i]<=0)
#   i02 = length(yield[,i])
#   cat(paste(colnames(yield)[i],i01,i02,i02-i01,round((1-i01/i02)*100,4),"%\n"))
# };rm(i,i01,i02)

##### plot yield by parameter #####
axTitle = c(
  bquote("Harvest rate (" ~ italic(.(colnames(yield)[1])) ~ "," ~ day^-1 ~ ")"),
  bquote(italic(e[PR]) ~ "( no unit )"),
  bquote(italic(e[P]) ~ "( no unit )"),
  bquote(italic(g[P]) ~ "(" ~ day^-1 ~ ")"),
  bquote(italic(a[P]) ~ "(" ~ m^3*gC^-1*day^-1 ~ ")"),
  bquote(italic(e[BR]) ~ "( no unit )"),
  bquote(italic(e[B]) ~ "( no unit )"),
  bquote(italic(g[B]) ~ "(" ~ m^3*gC^-1*day^-1 ~ ")"),
  bquote(italic(m[B]) ~ "(" ~ day^-1 ~ ")"),
  bquote(Harvest ~ interval ~ "(" ~ italic(T) ~ "," ~ day ~ ")" ),
  expression("yield ( gCm"^"-3"*"day"^"-1"*")")
)

## get top harvest rate data sets
yD = yield[which(yield$x %in% ydMx$x),]
for(i in 1:nrow(ydMx)){
  yD[which(yD$x==ydMx$x[i]),which(is.na(ydMx[i,]))] = NA
};rm(i)

## plot
for(p0 in 1:3){
  if(p0 == 1){ ## with / without bateria
    nAm = c("bacEff", 12,13, 1,1, 4,3, 2)
  }else if(p0 == 2){ ## destructive / continuous harvest for coexistence systems
    nAm = c("harvB", 10,12, 1,2, 3,3, 1)
  }else{ ## destructive / continuous harvest for phytoplankton-only systems
    nAm = c("harvP", 11,13, 1,2, 4,4, 1)
  }
  for(p1 in 1:as.numeric(nAm[8])){
    pdf(paste0(ot,nAm[1],ifelse(as.numeric(nAm[8])==1,"",p1),".pdf"), width = paper, height = paper*1.2*ifelse(as.numeric(nAm[8])==1,1,.5))
    par(mfrow=c(ifelse(as.numeric(nAm[8])==1,4,2),2),mar=c(5, 4, 1, 4), xpd=F, cex.lab=1.2, cex.axis=1.2)
    
    yDp = yD[,-as.numeric(nAm[2:3])]
    yDp = melt(yDp, id.vars = colnames(yDp)[1:9], measure.vars = colnames(yDp)[-c(1:9)])
    yDp$value = log(yDp$value+1)
    
    if(as.numeric(nAm[8])==1){tMp = c(2,9)}else if(p1==1){tMp = c(2,5)}else{tMp = c(6,9)}
    for(i in tMp[1]:tMp[2]){
      yMAX = round(max(yDp$value, na.rm = T))
      yMAX = ifelse(nAm[1]=="bacEff",ifelse(i>5,1.5,yMAX),ifelse(nAm[1]=="harvP",yMAX,1.5))
      boxplot(yDp$value ~ yDp$variable + yDp[,i], pch=3, cex=.3, lty=as.numeric(nAm[4:5]), xlab = "", ylab = "ln(yield+1)", xaxt="n", border=c(cBp[1,as.numeric(nAm[6])],cBp[1,as.numeric(nAm[7])]), col=c(cBp[2,as.numeric(nAm[6])],cBp[2,as.numeric(nAm[7])]), ylim=c(0,yMAX), notch=T)
      axis(side = 1, at=seq(1,length(unique(interaction(yDp$variable,yDp[,i]))),2)+.5, labels = round(unique(yDp[,2])[order(unique(yDp[,2]))],2), hadj = .79, las=2)
      mtext(axTitle[i], side = 1, padj = 2.5+ifelse(as.numeric(nAm[8])==1,0,.2), adj=.7)
      text(length(unique(interaction(yDp$variable,yDp[,i]))),yMAX*.4,LETTERS[i-1], cex = 2)
    };rm(i)
    legend("topright", ncol = 2, bg=rgb(1,1,1,.7), legend = unique(yDp$variable), lwd = 1, lty = as.numeric(nAm[4:5]), pch = 16, col = c(cBp[1,as.numeric(nAm[6])],cBp[1,as.numeric(nAm[7])]), box.col = rgb(1,1,1,1))
    invisible(dev.off())
  }};rm(p0,nAm,yDp,p1,tMp)

##### yield difference under different settings #####
yd = yield[which(yield$x %in% (selInter+1)),-c(12:13)]
yd = melt(yd, id.vars = colnames(yd)[1:9], measure.vars = colnames(yd)[-c(1:9)])
# pairwise.wilcox.test(yd$value,interaction(yd$variable,yd$x), p.adjust.method = "bonferroni", paired = F)
# for(i0 in unique(yd$x)){for(i1 in unique(yd$variable)){
#   cat(paste(i1,",",i0,",",length(yd$value[which(yd$x==i0 & yd$variable==i1)]),"\n"))
#   print(summary(yd$value[which(yd$x==i0 & yd$variable==i1)]))
# }};rm(i0,i1)

yd0 = yield[which(yield$x %in% (selRange+1)),-c(10:11)]
yd0 = melt(yd0, id.vars = colnames(yd0)[1:9], measure.vars = colnames(yd0)[-c(1:9)])
# pairwise.wilcox.test(yd0$value,interaction(yd0$variable,yd0$x), p.adjust.method = "bonferroni", paired = F)
# for(i0 in unique(yd0$x)){for(i1 in unique(yd0$variable)){
#   cat(paste(i1,",",i0,",",length(yd0$value[which(yd0$x==i0 & yd0$variable==i1)]),"\n"))
#   print(summary(yd0$value[which(yd0$x==i0 & yd0$variable==i1)]))
# }};rm(i0,i1)

pdf(paste0(ot,"Harvest.pdf"), width = paper*1.5, height = paper*.7)
par(mfrow=c(1,2),mar=c(5, 4, 1, .2), xpd=T)

boxplot(log(yd$value+1)~interaction(yd$variable,yd$x), pch=3, cex=.3, xlab = axTitle[10], ylab = "ln(yield+1)", xaxt="n", main = "Destructive Harvest", border=c(cBp[1,4],cBp[1,3]), col=c(cBp[2,4],cBp[2,3]), ylim=c(-1,6))
axis(side = 1, at=1:length(unique(interaction(yd$variable,yd$x))), labels = paste0(sYs[3:4],"\n",rep(selInter, each=2)), padj = .3)
text(length(unique(interaction(yd$variable,yd$x)))+.3,2,LETTERS[1], cex = 2)

boxplot(log(yd0$value+1)~interaction(yd0$variable,yd0$x), pch=3, cex=.3, xlab = axTitle[1], ylab = "ln(yield+1)", xaxt="n", main = "Continuous Harvest", border=c(cBp[1,4],cBp[1,3]), col=c(cBp[2,4],cBp[2,3]), ylim=c(-1,6))
axis(side = 1, at=1:length(unique(interaction(yd$variable,yd$x))), labels = paste0(sYs[1:2],"\n",rep(selRange, each=2)), padj = .3)
text(length(unique(interaction(yd0$variable,yd0$x)))+.3,2,LETTERS[2], cex = 2)

legend("bottomleft", inset=c(-.2,-.28), ncol = 2, bty = "n", legend = c("phytoplankton only", "coexistence"), lwd = 3, col = c(cBp[1,4],cBp[1,3]))
invisible(dev.off())

##### carbon density plot on destructive systems #####
dEst = as.data.frame(matrix(NA, nr=length(unique(rawL$x)), nc=(ncol(rawL)-10)*3+1))
dEst[,1] = unique(rawL$x)[order(unique(rawL$x))]
colnames(dEst) = c("t",paste0(rep(c("c","p"),each=3),rep(3:4,each=6),".",c("L","M","H")),paste0("b4.",c("L","M","H")))

## extract 95% interval across all forward-timed simulations
for(i in 1:nrow(dEst)){ ## loop over all simulated log-spaced time
  t = c()
  for(i0 in 10:15){if(i0!=12){ ## loop over all carbon pool except PoN bacteria because unrelated
    t = c(t,quantile(rawL[which(rawL$x==dEst$t[i]),i0], probs = c(.05,.5,.95))) ## get 95% confidence interval for each carbon pool
  }}
  dEst[i,-1] = t
};rm(i,i0,t)
lIm = 20 ## set x axis limit
dEst = dEst[which(dEst$t<=lIm[1]),]

pdf(paste0(ot,"Sample.pdf"), width = paper*1.5, height = paper*.7)
par(mfrow = c(1,3),mar=c(7, 5, 1, 1), xpd=T)
aX = c( ## set the y-axis label for each subplot
  bquote(italic(C) ~ "density (" ~ gC*m^-3 ~ ")"),
  bquote(italic(P) ~ "density (" ~ gC*m^-3 ~ ")"),
  bquote(italic(B) ~ "density (" ~ gC*m^-3 ~ ")")
)

## plot
for(i in 1:3){
  if(i<3){
    matplot(dEst$t,cbind(dEst[,3*i],dEst[,3*i+3]), type = "l", xlab = "number of days", lty = 1, ylab = aX[i], cex = .5, col = c(cBp[1,4],cBp[1,3]), xlim = c(0,lIm), lwd = 2, cex.axis=1.5, cex.lab=1.5)
    if(i==2){
      legend("bottom", inset=c(0,-.2), ncol = 2, bty = "n", legend = sYs[1:2], lwd = 3, col = c(cBp[1,4],cBp[1,3]), cex = 1.2)
    }
  }else{
    plot(dEst$t,dEst$b4.M, type = "l", xlab = "number of days", lty = 1, ylab = aX[3], cex = .5, col = cBp[1,3], xlim = c(0,lIm), lwd = 2, cex.axis=1.5, cex.lab=1.5)
  }
  text(lIm,max(c(dEst[,3*i],dEst[,3*i+3]), na.rm = T)*.4,LETTERS[i], cex = 2)
};rm(i)

invisible(dev.off())

##### daily yield against harvest interval/rate #####
dAily = as.data.frame(matrix(NA,nr=length(unique(yield$x)),nc=5))
colnames(dAily) = colnames(yield)[-c(2:9)]
dAily[,1] = unique(yield$x)[order(unique(yield$x))]-1
for(i in 1:nrow(dAily)){ ## get daily yield medians
  t = yield[which(yield$x==(dAily$x[i]+1)),10:13]
  for(i0 in 1:ncol(t)){
    dAily[i,i0+1] = quantile(t[,i0], probs = .5, na.rm = T)
  }
};rm(i,t,i0)
yMAX = round(max(dAily[,-1], na.rm = T),1)

## plot
pdf(paste0(ot,"DailyYield.pdf"), width = paper*1.5, height = paper*.7)
par(mfrow=c(1,2),mar=c(5, 4, 1, .2), xpd=T)
for(i in c(2,4)){
  if(i==2){
    xX = bquote("ln Harvest interval" ~ "(" ~ italic(T) ~ "," ~ day ~ ")" )
    mAin = "Destructive"
  }else{
    xX = bquote("ln Harvest rate (" ~ italic(.(colnames(yield)[1])) ~ "," ~ day^-1 ~ ")")
    mAin = "Continuous"
  }
  dA = cbind(log(dAily$x+1),dAily[,i],dAily[,i+1])
  dA = dA[which(!is.na(dA[,3])),]
  matplot(dA[,1],dA[,-1], yaxt="n", type = "l", xlab = xX, lty = 1, ylab = "", cex = .5, col = c(cBp[1,4],cBp[1,3]), lwd = 2, main=paste(mAin,"Harvest"), ylim = c(0,yMAX))
  axis(side = 2, at=seq(0,yMAX,yMAX/8), labels = seq(0,yMAX,yMAX/8))
  mtext(axTitle[11],side=2,line=2, padj = -.1, cex = 1)
  text(max(log(dAily$x+1)),yMAX*.4,LETTERS[i/2], cex = 2)
};rm(i,xX,mAin,dA)
legend("bottomleft", inset=c(-.2,-.28), ncol = 2, bty = "n", legend = c("phytoplankton only", "coexistence"), lwd = 3, col = c(cBp[1,4],cBp[1,3]))
invisible(dev.off())

cat("Carbon distribution plots finished\n")
