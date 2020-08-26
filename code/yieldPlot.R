#!/usr/bin/env Rscript

# Author 	: PokMan HO
# Script 	: yieldPlot.R
# Desc 		: the combined plot for yield flux by each parameter
# Input 	: `Rscript yieldPlot.R`
# Output 	: `result/` graphs
# Arg 		: 0
# Date 		: Jul 2020

##### argument #####
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
  
  expression("yield ( gCm"^"-3"*"day"^"-1"*")"),
  expression("log(yield+1) ( gCm"^"-3"*"day"^"-1"*")"),
  paste(c("Destructive","Continuous"),"Harvest")
)

##### get top harvest rate data sets #####
yD = yield[which(yield$x %in% ydMx$x),]
for(i in 1:nrow(ydMx)){
  yD[which(yD$x==ydMx$x[i]),which(is.na(ydMx[i,]))] = NA
};rm(i)
# yDwil = melt(yD, id.vars = colnames(yD)[1:9], measure.vars = colnames(yD)[-c(1:9)])
# yDwil = yDwil[which(!is.na(yDwil$value)),]
# pairwise.wilcox.test(yDwil$value, yDwil$variable, p.adjust.method = "bonferroni", paired = F)

## count unfavourable/unfeasible systems
# for(i in 10:ncol(yD)){
#   i0 = sum(!is.na(yD[,i]), na.rm = T)
#   i1 = nrow(yD)/(ncol(yD)-9)
#   cat(paste(colnames(yD)[i],": valid =",i0,"; total =",i1,";",round(i0/i1*100,4),"%; x =",yD[which(yD[,i]==max(yD[,i], na.rm = T)),1],"\n"))
#   print(summary(yD[,i]))
# };rm(i,i0,i1)

## plot yield across parameter ranges
for(p0 in 1:3){
  if(p0 == 1){ ## with / without bateria
    nAm = c("bacEff", 12,13, 1,1, 4,1, 2)
  }else if(p0 == 2){ ## destructive / continuous harvest for coexistence systems
    nAm = c("harvB", 10,12, 1,1, 1,3, 1)
  }else{ ## destructive / continuous harvest for phytoplankton-only systems
    nAm = c("harvP", 11,13, 1,1, 2,4, 1)
  }
  for(p1 in 1:as.numeric(nAm[8])){
    pdf(paste0(ot,nAm[1],ifelse(as.numeric(nAm[8])==1,"",p1),".pdf"), width = paper, height = paper*texCex*ifelse(as.numeric(nAm[8])==1,1,.5))
    par(mfrow=c(ifelse(as.numeric(nAm[8])==1,4,2),2),mar=c(5.5,4.2,.1,.1), xpd=F, cex.lab=texCex, cex.axis=texCex)
    
    yDp = yD[,-as.numeric(nAm[2:3])]
    yDp = melt(yDp, id.vars = colnames(yDp)[1:9], measure.vars = colnames(yDp)[-c(1:9)])
    yDp$value = log(yDp$value+1)
    
    if(as.numeric(nAm[8])==1){tMp = c(2,9)}else if(p1==1){tMp = c(2,5)}else{tMp = c(6,9)}
    for(i in tMp[1]:tMp[2]){
      yMAX = round(max(yDp$value, na.rm = T))
      yMAX = ifelse(nAm[1]=="bacEff" & i>5,1.5,yMAX)
      boxplot(yDp$value ~ yDp$variable + yDp[,i], pch=3, cex=.3, lty=as.numeric(nAm[4:5]), xlab = "", ylab = "", xaxt="n", border=c(cBp[1,as.numeric(nAm[6])],cBp[1,as.numeric(nAm[7])]), col=c(cBp[2,as.numeric(nAm[6])],cBp[2,as.numeric(nAm[7])]), ylim=c(0,yMAX))
      axis(side = 1, at=seq(1,length(unique(interaction(yDp$variable,yDp[,i]))),2)+.5, labels = round(unique(yDp[,2])[order(unique(yDp[,2]))],2), hadj = .79, las=2)
      
      mtext(axTitle[i], side = 1, padj = 2.7+ifelse((i-1)%%4<3 & (i-1)%%4>0,.5,-.2), adj=.7)
      mtext(axTitle[12], side = 2, padj = -1.7, adj = 1)
      text(1,yMAX*.92,LETTERS[i-1], cex = 2)
    };rm(i)
    legend("topright", ncol = 2, bg=rgb(1,1,1,.7), legend = unique(yDp$variable), lwd = 1, lty = as.numeric(nAm[4:5]), pch = 16, col = c(cBp[1,as.numeric(nAm[6])],cBp[1,as.numeric(nAm[7])]), box.col = rgb(1,1,1,1))
    invisible(dev.off())}
};rm(p0,nAm,yDp,p1,tMp)

## parameter range significance
# for(j in 10:ncol(yD)){
#   pp = yD[which(!is.na(yD[,j])),]
#   cat(paste0(colnames(pp)[j],"\n"))
#   for(i in 2:9){
#     cat(paste0(colnames(pp)[i],"\n"))
#     p0 = range(pp[,i])
#     print(wilcox.test(pp[which(pp[,i]==p0[1]),j],pp[which(pp[,i]==p0[2]),j]))
#   };cat("\n")};rm(i,j,pp,p0)

##### yield difference under different settings #####
yd = yield[which(yield$x %in% (selInter+1)),-c(12:13)]
yd = melt(yd, id.vars = colnames(yd)[1:9], measure.vars = colnames(yd)[-c(1:9)])
# pairwise.wilcox.test(yd$value,interaction(yd$variable,yd$x), p.adjust.method = "bonferroni", paired = F)
# for(i0 in unique(yd$x)){for(i1 in unique(yd$variable)){
#   cat(paste(i1,",",i0,",",sum(!is.na(yd$value[which(yd$x==i0 & yd$variable==i1)])),",",length(yd$value[which(yd$x==i0 & yd$variable==i1)]),"\n"))
#   print(summary(yd$value[which(yd$x==i0 & yd$variable==i1)]))
# }};rm(i0,i1)

yd0 = yield[which(yield$x %in% (selRange+1)),-c(10:11)]
yd0 = melt(yd0, id.vars = colnames(yd0)[1:9], measure.vars = colnames(yd0)[-c(1:9)])
# pairwise.wilcox.test(yd0$value,interaction(yd0$variable,yd0$x), p.adjust.method = "bonferroni", paired = F)
# for(i0 in unique(yd0$x)){for(i1 in unique(yd0$variable)){
#   cat(paste(i1,",",i0,",",sum(!is.na(yd0$value[which(yd0$x==i0 & yd0$variable==i1)])),",",length(yd0$value[which(yd0$x==i0 & yd0$variable==i1)]),"\n"))
#   print(summary(yd0$value[which(yd0$x==i0 & yd0$variable==i1)]))
# }};rm(i0,i1)

pdf(paste0(ot,"Harvest.pdf"), width = paper*1.5, height = paper*.7)
par(mfrow=c(1,2),mar=marRef, xpd=T, cex.lab=texCex, cex.axis=1.1)

for(i in 1:2){
  if(i==1){
    t = yd; aSs = c(2,1,1,2,10,13,1,2); t1 = selInter
  }else{
    t = yd0; aSs = c(4,3,3,4,1,14,3,4); t1 = selRange
  }
  boxplot(log(t$value+1)~interaction(t$variable,t$x), pch=3, cex=.3, xlab = axTitle[aSs[5]], ylab = "", xaxt="n", main = axTitle[aSs[6]], border=c(cBp[1,aSs[1]],cBp[1,aSs[2]]), col=c(cBp[2,aSs[1]],cBp[2,aSs[2]]), ylim=c(-1,6))
  axis(side = 1, at=1:length(unique(interaction(t$variable,t$x))), labels = paste0(sYs[aSs[3]:aSs[4]],"\n",rep(t1, each=2)), padj = .3)
  mtext(axTitle[12], side = 2, padj = -1.4, adj = .5, cex = texCex)
  text(.7,6,LETTERS[i], cex = 2)
  legend("bottomright", inset=c(0,0), ncol = 2, bty = "n", legend = c(sYs[aSs[7]],sYs[aSs[8]]), lwd = 3, col = c(cBp[1,aSs[1]],cBp[1,aSs[2]]))
};rm(i,t,aSs,t1)

invisible(dev.off())

##### carbon density plot on destructive systems #####
dEst = as.data.frame(matrix(NA, nr=length(unique(rawL$x)), nc=(ncol(rawL)-10)*3+1))
dEst[,1] = unique(rawL$x)[order(unique(rawL$x))]
colnames(dEst) = c("t",paste0(rep(c("c","p"),each=3),rep(3:4,each=6),".",c("L","M","H")),paste0("b4.",c("L","M","H")))

## extract 95% interval across all forward-timed simulations
for(i in 1:nrow(dEst)){ ## loop over all simulated log-spaced time
  t = c()
  for(i0 in 10:15){if(i0!=12){ ## loop over all carbon pool except PoN bacteria because unrelated
    t = c(t,quantile(rawL[which(rawL$x==dEst$t[i]),i0], probs = c(.05,.5,.95), na.rm = T)) ## get 95% confidence interval for each carbon pool
  }}
  dEst[i,-1] = t
};rm(i,i0,t)
lIm = 20 ## set x axis limit
dEst = dEst[which(dEst$t<=lIm),]

pdf(paste0(ot,"Sample.pdf"), width = paper*1.5, height = paper*.7)
par(mfrow = c(1,3),mar=c(4,5,1.5,.1), xpd=T, cex.lab=texCex, cex.axis=texCex, cex.main=texCex)
aX = c( ## set the y-axis label for each subplot
  bquote(italic(C) ~ "density (" ~ gC*m^-3 ~ ")"),
  bquote(italic(P) ~ "density (" ~ gC*m^-3 ~ ")"),
  bquote(italic(B) ~ "density (" ~ gC*m^-3 ~ ")"),
  "Organic Carbon", "Phytoplankton Biomass","Bacterial Biomass"
)

## plot
for(i in 1:3){
  if(i<3){
    matplot(dEst$t,cbind(dEst[,3*i],dEst[,3*i+3]), type = "l", xlab = "number of days", main=aX[3+i], lty = 1, ylab = aX[i], cex = .5, col = c(cBp[1,2],cBp[1,1]), xlim = c(0,lIm), lwd = 2, cex.axis=1.5, cex.lab=1.5)
    
    text(max(dEst$t)*.1,min(c(dEst[,3*i],dEst[,3*i+3]), na.rm = T)+diff(range(c(dEst[,3*i],dEst[,3*i+3])*.97, na.rm = T)),LETTERS[i], cex = 2)
  }else{
    plot(dEst$t,dEst$b4.M, type = "l", xlab = "number of days", main=aX[3+i], lty = 1, ylab = aX[i], cex = .5, col = cBp[1,1], xlim = c(0,lIm), lwd = 2, cex.axis=1.5, cex.lab=1.5)
    text(max(dEst$t)*.1,min(dEst$b4.M, na.rm = T)+diff(range(dEst$b4.M, na.rm = T))*.97,LETTERS[i], cex = 2)
  }
  if(i==3){
    legend("bottom", inset=c(0,0), ncol = 2, bty = "n", legend = sYs[1:2], lwd = 3, col = c(cBp[1,2],cBp[1,1]), cex = texCex)
  }
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

## plot
aX0 = c(
  bquote("ln Harvest interval" ~ "(" ~ italic(T) ~ "," ~ day ~ ")" ),
  bquote("ln Harvest rate (" ~ italic(.(colnames(yield)[1])) ~ "," ~ day^-1 ~ ")")
)

pdf(paste0(ot,"DailyYield.pdf"), width = paper*1.5, height = paper*.7)
par(mfrow=c(1,2),mar=marRef, xpd=T, cex.lab=texCex, cex.axis=texCex)

dA = cbind(log(dAily$x+1),dAily[,2],dAily[,3])
dA = dA[which(!is.na(dA[,3])),]
matplot(dA[,1],dA[,-1], type = "l", xlab = aX0[1], lty = 1, ylab = "", cex = .5, col = c(cBp[1,2],cBp[1,1]), lwd = 2, main=axTitle[13], xlim = c(0,max(log(dAily$x+1))))
mtext(axTitle[11],side=2,line=2, padj = -.1, cex = texCex)
text(0,max(dA[,-1],na.rm = T)*.9,LETTERS[1], cex = 2)
legend("right", inset=c(0,0), ncol = 2, bty = "n", legend = sYs[1:2], lwd = 3, col = c(cBp[1,2],cBp[1,1]))

dA = cbind(log(dAily$x+1),dAily[,4],dAily[,5])
dA = dA[which(!is.na(dA[,3])),]
matplot(dA[,1],log(dA[,-1]+1), type = "l", xlab = aX0[2], lty = 1, ylab = "", cex = .5, col = c(cBp[1,4],cBp[1,3]), lwd = 2, main=axTitle[14], xlim = c(0,max(log(dAily$x+1))))
mtext(axTitle[12],side=2,line=2, padj = -.1, cex = texCex)
text(0,max(log(dA[,-1]+1),na.rm = T)*.9,LETTERS[2], cex = 2)
legend("top", inset=c(0,0), ncol = 2, bty = "n", legend = sYs[3:4], lwd = 3, col = c(cBp[1,4],cBp[1,3]))

invisible(dev.off())

cat("Carbon distribution plots finished\n")
