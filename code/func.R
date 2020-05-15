#!/bin/env R

# Author: 	PokMan HO
# Script: 	func.R
# Desc: 	self-defined functions
# Input: 	none
# Output: 	none
# Arg: 		0
# Date: 	Apr 2020

##### pkg #####
library(deSolve)
library(lattice)
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

##### project model #####
ebc7 = function(t, pop, para){
  ## the 7th version of the model in this project
  ## t = time series sequence starting from 0
  ## pop = initial population, a named vector
  ## para = parameters used, a named vector
  with(as.list(c(pop, para)),{
    ## ode
    dC = g_P*e_PR*(1-e_P)*P +a_P*P^2 +g_B*(e_BR*(1-e_B)-1)*C*B +m_B*B -x*C
    dP = g_P*e_PR*e_P*P -a_P*P^2
    dB = g_B*e_BR*e_B*C*B -m_B*B
    
    list(c(dC, dP, dB))
  })
}

##### numerical solving project model #####
ebcData = function(endTime=1e3, iniPop=1e-12, parameter=c(0,.875,.63,.259,.001,.6,.55,1.046,.14)){
  ## a function solving integral of the model using deSolve package
  ## endTime: time of finishing integral
  ## iniPop: collective start carbon density for the three pools
  ## parameter: values of parameters used in the project model, an unnamed vector
  
  ## env setting
  tIme = seq(0,endTime,1)
  pAra = c(x = parameter[1],
           e_PR = parameter[2], e_P = parameter[3], g_P = parameter[4], a_P = parameter[5],
           e_BR = parameter[6], e_B = parameter[7], g_B = parameter[8], m_B = parameter[9])
  if(length(iniPop)==3){
    pops = c(C = iniPop[1], P = iniPop[2], B = iniPop[3])
  }else{
    if(length(iniPop)!=1){
      iniPop=1e-12
      cat(paste0("invalid initial values, setting all ",iniPop,"\n"))
    }
    pops = c(C = iniPop, P = iniPop, B = iniPop)
  }
  
  ## ode solve
  rEs = ode(y=pops, times=tIme, func=ebc7, parms=pAra)
  rEs = as.data.frame(rEs)
  rEs$total = rEs$C+rEs$P+rEs$B
  
  return(rEs)
}

##### analytical model solution #####
ebcEqm = function(parameter=c(0,.875,.63,.259,.001,.6,.55,1.046,.14)){
  x = parameter[1]
  ePR = parameter[2]; eP = parameter[3]; gP = parameter[4]; aP = parameter[5]
  eBR = parameter[6]; eB = parameter[7]; gB = parameter[8]; mB = parameter[9]
  
  C = mB/(eBR*eB*gB)
  P = ePR*eP*gP/aP
  B = (aP*mB*x - eBR*eB*gB*eP*(ePR*gP)^2)/(gB*mB*aP*(eBR-1))
  
  return(c(C,P,B))
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

##### ebc rate #####
ebcRate = function(pop=rep(1e-5,3), para=c(0,.875,.63,.259,.001,.6,.55,1.046,.14)){
  a=ebc7(pop = c(C=pop[1],P=pop[2],B=pop[3]),
         para=c(x=para[1],
                e_PR=para[2], e_P=para[3], g_P=para[4], a_P=para[5],
                e_BR=para[6], e_B=para[7], g_B=para[8], m_B=para[9]))
  return(a[[1]])
}
