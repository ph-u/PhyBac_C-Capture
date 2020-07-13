#!/usr/bin/env Rscript

# Author 	: PokMan HO
# Script 	: yieldStats.R
# Desc 		: determination of maximum yield flux for all systems
# Input 	: `Rscript yieldStats.R`
# Output 	: none
# Arg 		: 0
# Date 		: Jul 2020

##### in #####
source("yieldWrangling.R")

##### group descriptions #####
sTats = as.data.frame(matrix(NA, nrow = 7, nc=4))
colnames(sTats) = unique(interaction(yield$harvest,yield$system))
i=1;for(i0 in unique(yield$harvest)){for(i1 in unique(yield$system)){
  t = yield$yieldFlux[which(yield$harvest==i0 & yield$system==i1)]
  sTats[,i] = c(length(t),summary(t))
  if(i==1){rownames(sTats) = c("n",names(summary(t)))}
  i=i+1
}};rm(i,i0,i1,t)

##### Wilcox #####
pairwise.wilcox.test(yield$yieldFlux,g=interaction(yield$harvest,yield$system), p.adjust.method = "bonferroni", paired = F)
