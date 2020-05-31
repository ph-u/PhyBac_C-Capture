#!/bin/env R

# Author 	: PokMan HO
# Script 	: func_analysis.R
# Desc 		: functions for `modIRL.R` parameter scan result analysis
# Input 	: none
# Output 	: none
# Arg 		: 0
# Date 		: May 2020

##### pkg, data in #####
library(lattice)
library(gridExtra) ## easy multi-panel lattice plots
a = read.csv("../result/anaIRL.csv", header = T)
#uQfactors = vector(mode = "list")
#for(i in 1:9){uQfactors[[i]] = unique(a[,i])};rm(i) ## extract a list of unique factors

##### contour plot function#####
## function of contour plot
cOntour = function(indexVect = c(rep(c(rep(1,3),0),2),1), df = a, equilibrium=4){## xyAxis can be a char / number < 1
  indexVect = suppressWarnings(as.numeric(indexVect))
  ## check input valid
  if(length(indexVect)>ncol(df)){stop("input need dataframe col = factors & data, rows as data entries; or else index vector too long")}
  if(!is.numeric(equilibrium) | equilibrium>4 | equilibrium<2){warning("acceptable values: 2-4; changing to coexisting solution with value 4");equilibrium=4}

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
  
  ## subsetted data attributes
  xyAxis = which(is.na(indexVect) | indexVect<=0)
  if(length(xyAxis)!=2){stop("index vector -- need only two axes indications")}
  ptCol = c(xyAxis,(length(indexVect)+4*(equilibrium-2)+1):(length(indexVect)+4*(equilibrium-2)+4)) ## plot column choices
  ptMain = ptVal = c();for(i in 1:length(indexVect)){if(!(i%in%ptCol)){ ## extract selected data details
    ptMain = c(ptMain, colnames(df)[i]) ## corresponding parameter names
    ptVal=c(ptVal, unique(df0[,i])) ## corresponding parameter values
  }};rm(i)
  df0 = df0[,ptCol]
  
  ## plots
  for(i in 3:6){
    assign(paste0("p",i-2), contourplot(df0[,i]~df0[,1]*df0[,2], xlab=colnames(df0)[1], ylab=colnames(df0)[2], main=colnames(df0)[i]))
  };rm(i)
  grid.arrange(p1,p2,p3,p4, ncol=2, bottom=paste0(ptMain," = ",round(ptVal,4), collapse = ", "))
}

##### selected contour plots #####
#cOntour(indexVect = c(5,3,4,0,2,1,1,0,1), equilibrium = 4)
#plot(a$eqm4A~a$x)
