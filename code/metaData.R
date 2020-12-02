#!/usr/bin/env Rscript

# Author 	: ph-u
# Script 	: metaData.R
# Desc 		: BioTraits metadata extraction -- modified version of rateDet.R
# Input 	: `Rscript metaData.R`
# Output 	: `data/mData.csv`
# Arg 		: 0
# Date 		: 20201030

##### pkg import #####

##### data import #####
rAw = read.csv("../data/BioTraits.csv",stringsAsFactors = F) ## dimension (n*c) = 25826*155
mDt = read.csv("../data/mData_collect.csv",stringsAsFactors = F)
mDt = mDt[,-ncol(mDt)]

##### rough filter set-up #####
tRtNm = unique(rAw$StandardisedTraitName)
hAbitat = unique(rAw$Habitat)
conPhy = unique(rAw$ConPhylum)

##### minimal coarse data filter #####
rAw = rAw[which( ## dimension (n*c) = 3160*8
  rAw$StandardisedTraitName %in% tRtNm[c(14,18)] & ## growth rates
    rAw$Habitat %in% hAbitat[c(1,3,5)] & ## aquatic
    is.na(rAw$ResKingdom) & ## not predator/herbivore
    rAw$ConPhylum %in% conPhy[c(5,6,11:14,19,25,26,28)] & ## manual-checked photocell/bacterial decompoaser phyla
    !is.na(rAw$ConSpecies) & ## known species
    rAw$Published==T & ## published data
    rAw$StandardisedTraitValue>0 ## rm data recording no growth (purpose is only to obtain a reasonable standardization constant)
),c("StandardisedTraitValue", "StandardisedTraitUnit", "ConPhylum", "ConClass", "ConOrder", "ConFamily", "ConGenus", "ConSpecies", "ConTemp", "ConTempUnit","Labfield","ResCommon","SecondStressor","SecondStressorValue","Citation","DOI")]

##### intermediate data export #####
rAw$parameter <-ifelse(rAw$ConPhylum %in% unique(rAw$ConPhylum)[6:7],"gP","gB10")
rAw$Citation = gsub(",",";",rAw$Citation)
rEs = rbind(rAw,mDt)
write.csv(rEs, "../data/mData.csv", quote = F, row.names = F)
# summary(rAw$stdConst.day[which(rAw$role=="photocell")])
# summary(rAw$stdConst.day[which(rAw$role!="photocell")])
