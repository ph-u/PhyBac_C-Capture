#!/usr/bin/env Rscript

# Author 	: PokMan HO
# Script 	: metaData.R
# Desc 		: BioTraits metadata extraction -- modified version of rateDet.R
# Input 	: `Rscript metaData.R`
# Output 	: `data/mData.csv`
# Arg 		: 0
# Date 		: 20201030

##### pkg import #####

##### data import #####
rAw = read.csv("../data/BioTraits.csv",stringsAsFactors = F) ## dimension (n*c) = 25826*155

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
),c("StandardisedTraitValue", "StandardisedTraitUnit", "ConPhylum", "ConGenus", "ConSpecies", "ConTemp", "ConTempUnit","Habitat","Labfield","SecondStressor","SecondStressorDef","SecondStressorValue","SecondStressorUnit","Location","LocationType","Citation","DOI")]

##### standardization constant (std-cst) calculation #####
rAw$parameter <-ifelse(rAw$ConPhylum %in% unique(rAw$ConPhylum)[6:7],"gP","gBx10")

##### intermediate data export #####
rAw$Citation = gsub(",",";",rAw$Citation)
rAw$Location = gsub(",",";",rAw$Location)
write.csv(rAw, "../data/mData.csv", quote = F, row.names = F)
# summary(rAw$stdConst.day[which(rAw$role=="photocell")])
# summary(rAw$stdConst.day[which(rAw$role!="photocell")])
