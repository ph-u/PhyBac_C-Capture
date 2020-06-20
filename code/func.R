#!/bin/env R

# Author 	: PokMan HO
# Script 	: func.R
# Desc 		: self-defined functions
# Input 	: `source(../code/func.R)` in R scripts
# Output 	: none
# Arg 		: 0
# Date 		: Apr 2020

##### pkg #####
cBp <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#0072B2", "#D55E00", "#CC79A7", "#e79f00", "#9ad0f3", "#F0E442", "#999999", "#cccccc", "#6633ff", "#00FFCC", "#0066cc")

##### constant #####
k <- 8.617333262145e-5 ## Boltzmann constant (unit eV/K)

##### standardization value (Arrhenius) #####
normArrheniusEq = function(rate, Ea, tempC){
  ## a function calculate standardization value from measured rate
  ## rate: in any unit for rate
  ## Ea: activation energy (unit eV)
  ## tempC: temperature (unit deg-Celsius)
  rate0 <- rate/exp(-Ea/(k*(tempC+273.15)))
  return(rate0)
}

##### Arrhenius Equation #####
ArrheniusEq = function(A0, Ea, tempC){
  ## a function calculate temperature-standardized rate from standardized data
  ## A0: in any unit for rate
  ## Ea: activation energy (unit eV)
  ## tempC: temperature (unit deg-Celsius)
  A = A0*exp(-Ea/(k*(tempC+273.15)))
  return(A)
}

##### calculate x values from given y #####
getXfromY = function(y, yInt, sLope){
  ## a function calculate relative x values from given y
  ## yInt: y intercept
  ## sLope: slope value of the linear equation
  X = (y-yInt)/sLope
  return(X)
}

##### analytical model all solutions #####
ebcAlt = function(parameter=c(0,.875,.63,.259,.001,.6,.55,1.046,.14), out=1){
  x = parameter[1]
  ePR = parameter[2]; eP = parameter[3]; gP = parameter[4]; aP = parameter[5]
  eBR = parameter[6]; eB = parameter[7]; gB = parameter[8]; mB = parameter[9]
  
  rEs = as.data.frame(matrix(0,nc=4,nr=4))
  colnames(rEs) = c("C","P","B","total")
  tmp = c(mB/(eBR*eB*gB), 0, x/(gB*(eBR-1)))
  rEs[2,] = c(tmp,sum(tmp))
  tmp = c(eP*(ePR*gP)^2/(aP*x), ePR*eP*gP/aP, 0)
  rEs[3,] = c(tmp,sum(tmp))
  tmp = c(mB/(eBR*eB*gB), ePR*eP*gP/aP, (aP*mB*x - eBR*eB*gB*eP*(ePR*gP)^2)/(gB*mB*aP*(eBR-1)))
  rEs[4,] = c(tmp,sum(tmp))

  if(out==1){return(rEs)}else{
    tmp = c()
    for(i in 1:nrow(rEs)){
      tmp = c(tmp,as.numeric(rEs[i,]))
    };rm(i)
    return(tmp)
  }
}

