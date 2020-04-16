#!/bin/env R

# Author: 	PokMan HO (hpokman@connect.hku.hk)
# Script: 	rateDet.R
# Desc: 	BioTraits data handling
# Input: 	none
# Output: 	none
# Arg: 		0
# Date: 	Apr 2020

##### pkg import #####
source("func.R")

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
rAw = rAw[,c(2,8,9,21:24)] ## extract relevant growth rate columns

##### data allocation #####
rAw$SpNm <- paste(rAw$ConGenus,rAw$ConSpecies) ## assemble binomial nomenclature
write.table(data.frame("name"=unique(rAw$SpNm), "role"=NA, "aerobic"=NA), "../data/int_role.txt", quote = F, sep = ",", col.names = T, row.names = F)

##### fine filter set-up #####

##### minimal fine data filter #####

##### drafts #####
colnames(rAw)
