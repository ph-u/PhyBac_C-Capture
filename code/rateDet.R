#!/bin/env R

# Author 	: PokMan HO
# Script 	: rateDet.R
# Desc 		: BioTraits data handling
# Input 	: none
# Output 	: `../data/gRate.csv`, `../result/stdCst.png`
# Arg 		: 0
# Date 		: Apr 2020

##### pkg import #####
source("../code/func.R")

##### data import #####
rAw = read.csv("../data/BioTraits.csv",stringsAsFactors = F) ## dimension (n*c) = 25826*155

##### rough filter set-up #####
tRtNm = unique(rAw$StandardisedTraitName)
hAbitat = unique(rAw$Habitat)
conPhy = unique(rAw$ConPhylum)

##### minimal coarse data filter #####
oRi = rAw[which(
  rAw$StandardisedTraitName %in% tRtNm[c(14,18)] & ## growth rates
    rAw$Habitat %in% hAbitat[c(1,3,5)] & ## aquatic
    is.na(rAw$ResKingdom) & ## not predator/herbivore
    rAw$ConPhylum %in% conPhy[c(5,6,11:14,19,25,26,28)] & ## manual-checked photocell/bacterial decompoaser phyla
    !is.na(rAw$ConSpecies) & ## known species
    rAw$Published==T ## published data
),] ## dimension (n*c) = 3232*155

colExist=c();for(i in 1:ncol(oRi)){ ## detect empty columns
  if(!is.na(unique(oRi[,i]))){colExist=c(colExist,colnames(oRi)[i])}
};rm(i)

rAw = oRi[,which(colnames(rAw) %in% colExist)] ## prepare for fine filter
rAw = rAw[,c(2,8,9,17,21:24)] ## extract relevant growth rate columns
rAw = rAw[which(rAw$StandardisedTraitValue>0),] ## rm data recording no growth (purpose is only to obtain a reasonable standardization constant)

##### standardization constant (std-cst) calculation #####
rAw$Ea.eV <-ifelse(rAw$ConPhylum %in% unique(rAw$ConPhylum)[6:7],.32,.66) ## activation energy of photosynthetic (0.32eV) and heterotrophic (0.65eV) lifestyle
rAw$role <-ifelse(rAw$ConPhylum %in% unique(rAw$ConPhylum)[6:7],"phytoplankton","bacterial decomposer")
rAw$stdConst.day <- normArrheniusEq(rAw$StandardisedTraitValue, rAw$Ea.eV, rAw$ConTemp)*60^2*24

##### boxplot std-cst #####
png("../result/stdCst.png", width = 700)
par(mfrow=c(1,2))
boxplot(rAw$stdConst.day~rAw$role, xlab = "role", ylab = "Standardisation constant (1/day)")
boxplot(rAw$stdConst.day~rAw$role, ylim=c(0,9e5), xlab = "role", ylab = "Standardisation constant (1/day)")
text(1,4e5,"values out of bound",srt=90)
dev.off()

##### intermediate data export #####
write.csv(rAw, "../data/gRate.csv", quote = F, row.names = F)
# summary(rAw$stdConst.day[which(rAw$role=="photocell")])
# summary(rAw$stdConst.day[which(rAw$role!="photocell")])
