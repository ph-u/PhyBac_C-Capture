#!/bin/env R

# Author: 	PokMan HO (hpokman@connect.hku.hk)
# Script: 	respEff.R
# Desc: 	getting ranges of respiration efficiencies from BioTrait data and published respiration linear equation in relation to growth rate
# Input: 	none
# Output: 	none
# Arg: 		0
# Date: 	Apr 2020

##### pkg import #####
source("func.R")

##### data import #####
gRate = read.csv("../data/gRate.csv",stringsAsFactors = F) ## dimension (n*c) = 3160*11
pResp = read.csv("../data/photoResp.csv", stringsAsFactors = F) ## dimension (n*c) = 33*5

##### temperature standardization #####
pResp = pResp[which(pResp$temperature.C>=23 & pResp$temperature.C<=25),] ## model setting is decided at temperature range of 23-25 deg-Celsius
rEs = data.frame("details"=c("yIntercept", "slope"), "value"=c(mean(pResp$intercept),mean(pResp$slope)))

gRate$rate.23C = ArrheniusEq(gRate$stdConst.day,gRate$Ea.eV,23) ## temperature-standardized growth rate
pCellGRate = summary(gRate$rate.23C[which(gRate$role=="photocell")])
1-(rEs[1,2]-rEs[2,2]*unname(pCellGRate[4]))/unname(pCellGRate[4]) ## overall fraction of non-respired carbon
