#!/bin/env R

# Author 	: PokMan HO
# Script 	: modIRL.R
# Desc 		: model using real-life parameter ranges
# Input 	: none
# Output 	: `../result/anaIRL.csv`
# Arg 		: 0
# Date 		: May 2020

##### pkg, data in #####
source("func.R") ## self-defined functions
gRate = read.csv("../data/gRate.csv", header = T) ## rate determined by `rateDet.R` using BioTrait database
rEspR = read.csv("../data/photoResp.csv", stringsAsFactors = F) ## phytoplankton respiration linear models collected from literature (data from Table 3 of https://doi.org/10.1111/j.1469-8137.1989.tb00321.x)

##### growth rate ranges at 23 deg-C #####
gRate$rate.23C = ArrheniusEq(gRate$stdConst.day,gRate$Ea.eV,23) ## temperature-standardized growth rate
gP = range(gRate$rate.23C[which(gRate$role=="photocell")])
gB = range(gRate$rate.23C[which(gRate$role!="photocell")])

##### phytoplankton non-respired fraction range #####
rEspR = rEspR[which(rEspR$temperature.C>=23 & rEspR$temperature.C<=25),]
## in the paper, graphs are respiration rate vs growth rate
## non-respired fraction = 1- respiration rate / (respiration rate + growth rate), assuming no leakages
## when respiration rate = mx+c & growth rate = x; non-respired fraction = 1-(mx+c)/((m+1)x+c)
ePR = c()
for(i in 1:nrow(rEspR)){
  tmp = 1 - (rEspR$slope[i]*gP + rEspR$intercept[i]) / ((rEspR$slope[i] + 1)*gP + rEspR$intercept[i]) ## non-respired fraction with logic explained above
  ePR = c(ePR,tmp)
  };rm(i,tmp)
ePR = range(ePR)

##### phytoplankton fraction of biomass-incorpporated carbon #####
eP = c(.75, .75, .82, 1.2, .75, 1.4, 1.1, .9, .5, .4, .85, 1.2, .63) ## data collected from literature (Table 5 "heterotrophic growth of microalgae" section in https://doi.org/10.1111/j.1469-8137.1989.tb00321.x)
eP = range(eP)
if(eP[2]>1){eP[2]=1} ## capped at 1 assuming phytoplanktons do not consume organic carbon in this model

##### phytoplankton intraspecific interference #####
aP = c(.36, .22, .43) ## data collected from literature (left column text middle part in p.4 from https://doi.org/10.1016/j.jbiotec.2007.01.009)
aP = range(aP)

##### parameter ranges #####
x = seq(0,1,by=.1) ## random rates, main point of investigation
ePR = seq(ePR[1],ePR[2], by=diff(ePR)/10)
eP = seq(eP[1],eP[2], by=diff(eP)/10)
gP = seq(gP[1],gP[2], by=diff(gP)/10)
aP = seq(aP[1],aP[2], by=diff(aP)/10)
eBR = 1-100*10^-3/28/(1-0.8) ## calculation logic explained in Appendix, the only available data was collected from literature (Fig.1b in https://doi.org/10.1016/0038-0717(88)90006-5)
eB = .55 ## the only available data was collected from literature (the third line in p.4 right column text from https://doi.org/10.1016/0038-0717(88)90006-5)
gB = seq(gB[1],gB[2], by=diff(gB)/10)
mB = -log(.5)/5 ## "This biomass was estimated to have a half-life of 5 days..." text collected from the second line in p.4 right column text from https://doi.org/10.1016/0038-0717(88)90006-5

##### analytical equlibria scan #####
rEsult = as.data.frame(matrix(NA, nc=(9+4*3), nr=length(x)*length(ePR)*length(eP)*length(gP)*length(aP)*length(eBR)*length(eB)*length(gB)*length(mB)))

tmp=c()
for(i in paste0("eqm",2:4)){
  tmp = c(tmp,paste0(i,c("C","P","B","A")))
};rm(i)
colnames(rEsult) = c("x", "ePR","eP","gP","aP", "eBR","eB","gB","mB", tmp)
rm(tmp)

iDx = rep(1,10) ## index vector for looping (x, ePR,eP,gP,aP, eBR,eB,gB,mB, rEsult)
cat("env set-up finished, start scan\n")
repeat{
  if(iDx[10]%%5e4==0){cat(paste0(round(iDx[10]/nrow(rEsult)*100,2),"% finished; current > row ",iDx[10],"\n"))}
  pArameter = c(x[iDx[1]], ePR[iDx[2]],eP[iDx[3]],gP[iDx[4]],aP[iDx[5]], eBR[iDx[6]],eB[iDx[7]],gB[iDx[8]],mB[iDx[9]])
  rEsult[iDx[10],] = c(pArameter, ebcAlt(pArameter,2)[-c(1:4)])
  iDx[10] = iDx[10]+1
  iDx[9] = iDx[9]+1
  if(iDx[9]>length(mB)){iDx[9]=1; iDx[8]=iDx[8]+1}
  if(iDx[8]>length(gB)){iDx[8]=1; iDx[7]=iDx[7]+1}
  if(iDx[7]>length(eB)){iDx[7]=1; iDx[6]=iDx[6]+1}
  if(iDx[6]>length(eBR)){iDx[6]=1; iDx[5]=iDx[5]+1}
  if(iDx[5]>length(aP)){iDx[5]=1; iDx[4]=iDx[4]+1}
  if(iDx[4]>length(gP)){iDx[4]=1; iDx[3]=iDx[3]+1}
  if(iDx[3]>length(eP)){iDx[3]=1; iDx[2]=iDx[2]+1}
  if(iDx[2]>length(ePR)){iDx[2]=1; iDx[1]=iDx[1]+1}
  if(iDx[10]>nrow(rEsult)){break}
}

##### export #####
cat("scan finished, exporting\n")
write.csv(rEsult, "../result/anaIRL.csv", quote = F, row.names = F)
