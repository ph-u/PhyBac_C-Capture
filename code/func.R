#!/usr/bin/env Rscript

# Author 	: PokMan HO
# Script 	: func.R
# Desc 		: self-defined functions
# Input 	: `source("../code/func.R")` in R scripts
# Output 	: none
# Arg 		: 0
# Date 		: Apr 2020

##### pkg & constant #####
k = 8.617333262145e-5 ## Boltzmann constant (unit eV/K)

##### standardization value (Arrhenius) #####
normArrheniusEq = function(rate, Ea, tempC){
  ## a function calculate standardization value from measured rate
  ## rate: in any unit for rate
  ## Ea: activation energy (unit eV)
  ## tempC: temperature (unit deg-Celsius)
  return(rate/exp(-Ea/(k*(tempC+273.15))))
}

##### Arrhenius Equation #####
ArrheniusEq = function(A0, Ea, tempC){
  ## a function calculate temperature-standardized rate from standardized data
  ## A0: in any unit for rate
  ## Ea: activation energy (unit eV)
  ## tempC: temperature (unit deg-Celsius)
  return(A0*exp(-Ea/(k*(tempC+273.15))))
}

##### calculate x values from given y #####
getXfromY = function(y, yInt, sLope){
  ## a function calculate relative x values from given y
  ## yInt: y intercept
  ## sLope: slope value of the linear equation
  return((y-yInt)/sLope)
}

##### analytical model all solutions #####
ebcAlt = function(parameter, out=1){
  x = parameter[1]
  ePR = parameter[2]; eP = parameter[3]; gP = parameter[4]; aP = parameter[5]
  eBR = parameter[6]; eB = parameter[7]; gB = parameter[8]; mB = parameter[9]
  
  rEs = c(eP*(ePR*gP)^2/(aP*x), ## PoH - C
          ePR*eP*gP/aP, ## PoH - P
          0, ## PoH - B
          mB/(eBR*eB*gB), ## PBH - C
          ePR*eP*gP/aP, ## PBH - P
          (aP*mB*x - eBR*eB*gB*eP*(ePR*gP)^2)/(gB*mB*aP*(eBR-1)) ## PBH - B
          )
  x = which(rEs<0 | rEs==Inf) ## search for non-reasonable density values
  if(any(x>3)){rEs[4:6]=NA} ## set PBH solution of non-reasonable to NA if necessary
  if(any(x<4)){rEs[1:3]=NA} ## set PoH solution of non-reasonable to NA if necessary
  if(out==1){return(rEs)}else{
    rEs = as.data.frame(matrix(rEs[c(1,4,2,5,3,6)], nr=2))
    colnames(rEs) = c("C","P","B")
    return(rEs)
    }
}
