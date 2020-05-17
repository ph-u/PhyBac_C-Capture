#!/bin/env Rscript

# Author:   PokMan Ho
# Script:   analytical_accuracy.R
# Desc:   	get accuracy trend from initial population effect
# Input: 	none
# Output: 	none
# Arg: 		0
# Date: 	Apr 2020

##### import #####
source("../code/func.R")
aNa = read.csv("../result/maxYield_all.csv", header = T)
aNA = read.csv("../result/maxYield_ALL.csv", header = T)
nD1e0 = read.csv("../result/discrepancy_1.csv", header = T)
nD1e2 = read.csv("../result/discrepancy_1e-2.csv", header = T)
nD1e3 = read.csv("../result/discrepancy_1e-3.csv", header = T)
nD1e4 = read.csv("../result/discrepancy_1e-4.csv", header = T)
nD1e5 = read.csv("../result/discrepancy_1e-5.csv", header = T)
nD1e11 = read.csv("../result/discrepancy_1e-11.csv", header = T)
nD1e12 = read.csv("../result/discrepancy_1e-12.csv", header = T)

##### plot extreme portion #####
tHres = .1
nPos = as.data.frame(matrix(NA,nr=7,nc=4))
colnames(nPos) = paste("extreme",c("C","P","B","A"))
for(i in 1:ncol(nPos)){nPos[,i]=c(length(which(nD1e0[,i+9]>=tHres | nD1e0[,i+9]<=-tHres)),
                                  length(which(nD1e2[,i+9]>=tHres | nD1e2[,i+9]<=-tHres)),
                                  length(which(nD1e3[,i+9]>=tHres | nD1e3[,i+9]<=-tHres)),
                                  length(which(nD1e4[,i+9]>=tHres | nD1e4[,i+9]<=-tHres)),
                                  length(which(nD1e5[,i+9]>=tHres | nD1e5[,i+9]<=-tHres)),
                                  length(which(nD1e11[,i+9]>=tHres | nD1e11[,i+9]<=-tHres)),
                                  length(which(nD1e12[,i+9]>=tHres | nD1e12[,i+9]<=-tHres)))};rm(i)
nPos$iniPop=c(1,1e-2,1e-3,1e-4,1e-5,1e-11,1e-12)

{png(paste0("../result/discrepancy",tHres,"ByIniPop.png"), height=600, width=600)
matplot(log10(nPos[,5]),nPos[,-5],type = "l", col = cBp[-c(3,5)], lty=1, lwd=5, xlab="log10 initial popoulation", ylab="number of extreme simulations with high discrepancy", main=paste("Extreme discrepancy threshold=",tHres))
legend("topright", inset=c(.1,0), bty="n", legend = colnames(nPos)[-5], pch = rep(16,4), col = cBp[-c(3,5)])
abline(v=-3, col="green", lwd=3, lty=2)
dev.off()}

##### identify eqm position #####
nUm = aNa[,10:13]+nD1e12[,10:13]
iDeqm = function(df=nUm,ref=aNA){
  a0 = as.data.frame(matrix(0,nr=nrow(df),nc=5))
  colnames(a0)=1:ncol(a0)
  a1 = abs(df-ref[,10:13]); a0[,1]=a1[,1]+a1[,2]+a1[,3]
  a2 = abs(df-ref[,14:17]); a0[,2]=a2[,1]+a2[,2]+a2[,3]
  a3 = abs(df-ref[,18:21]); a0[,3]=a3[,1]+a3[,2]+a3[,3]
  a4 = abs(df-ref[,22:25]); a0[,4]=a4[,1]+a4[,2]+a4[,3]
  
  for(i in 1:nrow(a0)){if(any(a0[i,1:4]<10)){
    a0[i,5] = as.numeric(colnames(a0)[which(a0[i,1:4]==min(a0[i,1:4]))])
    if(i%%1e4==0){cat(paste0("i=",i/1e3,"K;",round(i/nrow(df)*100,2),"%\n"))}
  }};rm(i)
  return(table(a0[,5]))
}
aa="1e-12"
png(paste0("tmp/",aa,".png"))
pie(a,main = paste0("Solution distribution for initial population=",aa))
dev.off()

write.table(as.data.frame(a),paste0("tmp/",aa,".csv"), sep=",", col.names = F,row.names = F)

##### check changes of eqm position #####
r00 = read.csv("p_tmp/1e-0.csv", header = F)
r02 = read.csv("p_tmp/1e-2.csv", header = F)
r03 = read.csv("p_tmp/1e-3.csv", header = F)
r04 = read.csv("p_tmp/1e-4.csv", header = F)
r05 = read.csv("p_tmp/1e-5.csv", header = F)
r11 = read.csv("p_tmp/1e-11.csv", header = F)
r12 = read.csv("p_tmp/1e-12.csv", header = F)
aNA = read.csv("../result/maxYield_ALL.csv", header = T)

rEs = cbind(r00[,5],r02[,5],r03[,5],r04[,5],r05[,5],r11[,5],r12[,5],aNA[,1:9])
colnames(rEs) = c(paste0("p",c("00","02","03","04","05","11","12")),colnames(aNA)[1:9])
rEs$eqmid=paste0(rEs[,1],rEs[,2],rEs[,3],rEs[,4],rEs[,5],rEs[,6],rEs[,7])
write.csv(rEs,"p_tmp/eqmSummary.csv",quote = F,row.names = F)

uQrEs = unique(rEs[,1:7])

pLt=table(rEs$eqmid)
png("graph/eqmPoSum.png")
pie(pLt,labels=as.data.frame(pLt)[,1], main="eqm position for 11 categories with different starting densities\n1e00, 1e-2, 1e-3, 1e-4, 1e-5, 1e-11, 1e-12 (gC/m^3)", cex=.7)
legend("topleft", bty="n", legend = paste0(as.data.frame(pLt)[,1],": ",as.data.frame(pLt)[,2],"(",round(prop.table(pLt)*100),"%)"))
dev.off()
