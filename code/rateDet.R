#!/usr/bin/env Rscript

# Author 	: PokMan HO
# Script 	: rateDet.R
# Desc 		: BioTraits data wrangling
# Input 	: `Rscript rateDet.R`
# Output 	: `data/gRate.csv`, `result/stdCst.png`
# Arg 		: 0
# Date 		: Apr 2020

##### pkg import #####
source("../code/func.R")
paper = 7

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
),c("FinalID", "StandardisedTraitValue", "StandardisedTraitUnit", "ConPhylum", "ConGenus", "ConSpecies", "ConTemp", "ConTempUnit")]

##### standardization constant (std-cst) calculation #####
rAw$Ea.eV <-ifelse(rAw$ConPhylum %in% unique(rAw$ConPhylum)[6:7],.32,.66) ## activation energy of photosynthetic (0.32eV) and heterotrophic (0.65eV) lifestyle
rAw$role <-ifelse(rAw$ConPhylum %in% unique(rAw$ConPhylum)[6:7],"phytoplankton","bacteria")
rAw$stdConst.day <- normArrheniusEq(rAw$StandardisedTraitValue, rAw$Ea.eV, rAw$ConTemp)*60^2*24

##### boxplot std-cst #####
pdf("../result/stdCst.pdf", width = paper, height = paper*.7)
par(mfrow=c(1,2))
boxplot(rAw$stdConst.day~rAw$role, xlab = "role", ylab = "Standardisation constant (1/day)", pch=4, cex=.7)
boxplot(rAw$stdConst.day~rAw$role, ylim=c(0,9e5), xlab = "role", ylab = "Standardisation constant (1/day)", pch=4, cex=.7)
text(1,4e5,"values out of bound",srt=90)
invisible(dev.off())
cat("output Temperature standardisation constant boxplot finished\n")

##### intermediate data export #####
write.csv(rAw, "../data/gRate.csv", quote = F, row.names = F)
# summary(rAw$stdConst.day[which(rAw$role=="photocell")])
# summary(rAw$stdConst.day[which(rAw$role!="photocell")])
