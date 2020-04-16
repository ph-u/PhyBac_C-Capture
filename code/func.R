#!/bin/env R

# Author: 	PokMan HO (hpokman@connect.hku.hk)
# Script: 	func.R
# Desc: 	self-defined functions
# Input: 	none
# Output: 	none
# Arg: 		0
# Date: 	Apr 2020

normArrheniusEq = function(rate, Ea, tempC){
  ## an function calculate standardization value from measured rate
  ## rate: in any unit for rate
  ## Ea: activation energy (unit eV)
  ## tempC: temperature (unit deg-Celsius)
  k <- 8.617333262145e-5 ## Boltzmann constant (unit eV/K)
  rate0 <- rate/exp(-Ea/(k*(tempC+273.15)))
  return(rate0)
}
