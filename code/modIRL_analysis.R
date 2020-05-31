#!/bin/env R

# Author 	: PokMan HO
# Script 	: modIRL_analysis.R
# Desc 		: analysis for result by `modIRL.R` parameter scan
# Input 	: none
# Output 	: graphs in `../result/` directory
# Arg 		: 0
# Date 		: May 2020

##### pkg, data in #####
library(lattice)
a = read.csv("../result/anaIRL.csv", header = T)
uQfactors = vector(mode = "list")
for(i in 1:9){uQfactors[[i]] = unique(a[,i])};rm(i) ## extract a list of unique factors

##### contour plot function#####
indexVect=c(1,1,1,"x",1,4,1,0,1)
## function of contour plot
cOntour = function(indexVect = c(rep(c(rep(1,3),0),2),1), df = a, equilibrium=4, target=4, colour = cBp){## xyAxis can be a char / number < 1
  indexVect = suppressWarnings(as.numeric(indexVect))
  ## check input valid
  if(length(indexVect)>ncol(df)){stop("input need dataframe col = factors & data, rows as data entries; or else index vector too long")}
  if(!is.numeric(equilibrium) | equilibrium>4 | equilibrium<2){warning("acceptable values: 2-4; changing to coexisting solution with value 4");equilibrium=4}
  if(!is.numeric(target) | target>4 | target<1){warning("acceptable values: 1-4; changing to total carbon overview with value 4");target=4}
  
  df0 = df
  for(i in 1:length(indexVect)){
    uQ = unique(df[,i])
    ## check input valid
    if(!is.na(indexVect[i]) & indexVect[i] > length(uQ)){
      warning(paste0("factor ",i,", ",colnames(df)[i]," exceeded limit at ",length(uQ),", now it changed to this max value\n"))
      indexVect[i] = length(uQ)
    }
    
    ## subset data if not xyAxis
    if(!is.na(indexVect[i]) & indexVect[i]>0 & indexVect[i]<=length(uQ)){
      df0 = df0[which(df0[,i]==uQ[indexVect[i]]),]
    }
  };rm(i)
  
  ## plot subsetted data
  xyAxis = which(is.na(indexVect) | indexVect<=0)
  if(length(xyAxis)!=2){stop("index vector -- need only two axes indications")}
  ptCol = c(xyAxis,length(indexVect)+4*(equilibrium-2)+target) ## plot column choices
  ptMain = ptVal = c();for(i in 1:length(indexVect)){if(!(i%in%ptCol)){ ## extract selected data details
    ptMain = c(ptMain, colnames(df)[i]) ## corresponding parameter names
    ptVal=c(ptVal, unique(df0[,i])) ## corresponding parameter values
  }};rm(i)
  df0 = df0[,ptCol]
  contourplot(df0[,3]~df0[,1]*df0[,2], xlab=colnames(df)[xyAxis[1]], ylab=colnames(df)[xyAxis[2]], main=paste0(ptMain," = ",round(ptVal,4), collapse = ", "))
}

##### contour plots #####
cOntour(target = 3)
