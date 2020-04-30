#!/bin/env R

# Author: 	PokMan HO
# Script: 	func.R
# Desc: 	self-defined functions
# Input: 	none
# Output: 	none
# Arg: 		0
# Date: 	Apr 2020

k <- 8.617333262145e-5 ## Boltzmann constant (unit eV/K)

normArrheniusEq = function(rate, Ea, tempC){
  ## a function calculate standardization value from measured rate
  ## rate: in any unit for rate
  ## Ea: activation energy (unit eV)
  ## tempC: temperature (unit deg-Celsius)
  rate0 <- rate/exp(-Ea/(k*(tempC+273.15)))
  return(rate0)
}

ArrheniusEq = function(A0, Ea, tempC){
  ## a function calculate temperature-standardized rate from standardized data
  ## A0: in any unit for rate
  ## Ea: activation energy (unit eV)
  ## tempC: temperature (unit deg-Celsius)
  A = A0*exp(-Ea/(k*(tempC+273.15)))
  return(A)
}

getXfromY = function(y, yInt, sLope){
  ## a function calculate relative x values from given y
  ## yInt: y intercept
  ## sLope: slope value of the linear equation
  X = (y-yInt)/sLope
  return(X)
}
