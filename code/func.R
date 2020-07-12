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

