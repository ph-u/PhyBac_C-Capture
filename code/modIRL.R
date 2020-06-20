#!/bin/env R

# Author 	: PokMan HO
# Script 	: modIRL.R
# Desc 		: analytical scan using real-life parameter ranges
# Input 	: none
# Output 	: `../result/anaIRL.csv`
# Arg 		: 0
# Date 		: May 2020

##### pkg, data in #####
source("func.R") ## self-defined functions
gRate = read.csv("../data/gRate.csv", header = T) ## rate determined by `rateDet.R` using BioTrait database
rEspR = read.csv("../data/photoResp.csv", stringsAsFactors = F) ## phytoplankton respiration linear models collected from literature (data from Table 3 of https://doi.org/10.1111/j.1469-8137.1989.tb00321.x)

##### unit category for biological parameters #####
## dimensionless: ePR, eP, eBR, eB
## day^-1: gP, mB
## m^3/(gC day): gB, aP
## units for gP group & gB group are similar, so percentage ranges are compariable & considered exchangeable under the lack of experimental data

##### rate ranges data at 23 deg-C #####
gRate$rate.23C = ArrheniusEq(gRate$stdConst.day,gRate$Ea.eV,23) ## temperature-standardized growth rate
gP = gRate$rate.23C[which(gRate$role=="photocell")]
gB = gRate$rate.23C[which(gRate$role!="photocell" & gRate$rate.23C>1)]*.1
## gB = rMax*constant
## gB is clearance rate; "constant" is an arbitrary inverted density
## rMax is BioTrait data
## arbitrary filter of BioTrait growth rate >1 applied; initial growth rate minimum at 10e-5 magnitude

aP = c(.36, .22, .43) ## data collected from literature (left column text middle part in p.4 from https://doi.org/10.1016/j.jbiotec.2007.01.009)
mB = -log(.5)/5 ## "This biomass was estimated to have a half-life of 5 days..." text collected from the second line in p.4 right column text from https://doi.org/10.1016/0038-0717(88)90006-5

##### fraction ranges data at 23-25 deg-C #####
rEspR = rEspR[which(rEspR$temperature.C>=23 & rEspR$temperature.C<=25),]
ePR = c()
for(i in 1:nrow(rEspR)){
  tmp = 1 - (rEspR$slope[i]*gP + rEspR$intercept[i]) / ((rEspR$slope[i] + 1)*gP + rEspR$intercept[i]) ## non-respired fraction with logic explained below
  ePR = c(ePR,tmp)
};rm(i,tmp)
## in the paper, graphs are respiration rate vs growth rate
## non-respired fraction = 1- respiration rate / (respiration rate + growth rate), assuming no leakages
## when respiration rate = mx+c & growth rate = x; non-respired fraction = 1-(mx+c)/((m+1)x+c)

eP = c(.75, .75, .82, 1.2, .75, 1.4, 1.1, .9, .5, .4, .85, 1.2, .63) ## data collected from literature (Table 5 "heterotrophic growth of microalgae" section in https://doi.org/10.1111/j.1469-8137.1989.tb00321.x)
eP[eP>1]=1 ## capped at 1 assuming phytoplanktons do not consume organic carbon in this model

eBR = 1-100*10^-3/28/(1-0.8) ## calculation logic explained in Appendix, the only available data was collected from literature (Fig.1b in https://doi.org/10.1016/0038-0717(88)90006-5)
eB = .55 ## the only available data was collected from literature (the third line in p.4 right column text from https://doi.org/10.1016/0038-0717(88)90006-5)

##### get largest range for each category #####
## ref for others within category without sufficient data
gP.per = range(gP)/mean(gP)-1
gB.per = range(gB)/mean(gB)-1
if(diff(gP.per)>diff(gB.per)){rAg1 = gP.per}else{rAg1 = gB.per}
ePR.per = range(ePR)/mean(ePR)-1
eP.per = range(eP)/mean(eP)-1
if(diff(ePR.per)>diff(eP.per)){rAg2 = ePR.per}else{rAg2 = eP.per}

##### parameter ranges #####
ePR = mean(ePR)*(1+ePR.per);if(ePR[2]>1){ePR[2]=1} ## restrict fraction max to 1 if necessary
eP = mean(eP)*(1+eP.per);if(eP[2]>1){eP[2]=1}
gP = mean(gP)*(1+gP.per)
aP = mean(aP)*(1+rAg1)
eBR = mean(eBR)*(1+rAg2);if(eBR[2]>1){eBR[2]=1}
eB = mean(eB)*(1+rAg2);if(eB[2]>1){eB[2]=1}
gB = mean(gB)*(1+gB.per)
mB = mean(mB)*(1+rAg1)

##### parameter sequences under uniform prior #####
paRef = as.data.frame(matrix(NA, nc=9, nr=11))
colnames(paRef) = c("x", "ePR","eP","gP","aP", "eBR","eB","gB","mB")
paRef[,1] = seq(0,1,by=.1) ## random rates, main point of investigation
paRef[,2] = seq(ePR[1],ePR[2], by=diff(ePR)/10)
paRef[,3] = seq(eP[1],eP[2], by=diff(eP)/10)
paRef[,4] = seq(gP[1],gP[2], by=diff(gP)/10)
paRef[,5] = seq(aP[1],aP[2], by=diff(aP)/10)
paRef[,6] = seq(eBR[1],eBR[2], by=diff(eBR)/10)
paRef[,7] = seq(eB[1],eB[2], by=diff(eB)/10)
paRef[,8] = seq(gB[1],gB[2], by=diff(gB)/10)
paRef[,9] = seq(mB[1],mB[2], by=diff(mB)/10)

##### result dataframe preparation #####
rEsult = as.data.frame(matrix(NA, nc=(9+4*3), nr=nrow(paRef)*1000))

tmp=c()
for(i in paste0("eqm",2:4)){
  tmp = c(tmp,paste0(i,c("C","P","B","A")))
};rm(i)
colnames(rEsult) = c("x", "ePR","eP","gP","aP", "eBR","eB","gB","mB", tmp)
rm(tmp)

repeat{
  for(i in 1:ncol(paRef)){while(length(unique(rEsult[,i]))<nrow(paRef)){
    rEsult[,i] = sample(paRef[,i], nrow(rEsult), replace = T)
  }};rm(i)
  if(any(duplicated(rEsult))==F){break}
}

##### analytical equlibria scan #####
cat("env set-up finished, start scan\n")
for(i in 1:nrow(rEsult)){
  rEsult[i,-c(1:9)] = ebcAlt(as.numeric(rEsult[i,c(1:9)]),2)[-c(1:4)]
  if(i%%(nrow(rEsult)/100)==0){cat(paste0(round(i/nrow(rEsult)*100,2),"% finished; current > row ",i,"\n"))}
};rm(i)

##### export #####
cat("scan finished, exporting\n")
write.csv(rEsult, "../result/anaIRL.csv", quote = F, row.names = F)
