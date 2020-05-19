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

##### plot time series model #####
ebcPlt = function(iniPop, pA){
  pA = as.numeric(pA[1:9])
  
  dAta=ebcData(endTime=1e3, iniPop=iniPop, parameter=pA)
  eQm=ebcEqm(pA)
  eQm=c(eQm,sum(eQm))
  
  par(mar=c(5, 5, 3, 1), xpd=TRUE, cex = 1) ## c(B,L,T,R)
  
  matplot(dAta[,1], dAta[,-1], type="l", lty=1, lwd=5, col=cBp[-c(3,5)], xlab=paste0(colnames(dAta)[1]," (day)"), ylab="carbon density (gC/m^3)", cex.lab=2, cex.axis=2, cex.main=2, main=paste0(c("x","e_PR","e_P","g_P","a_P","\ne_BR","e_B","g_B","m_B")," = ",signif(pA,4), collapse=", "))
  points(x=rep(dAta[nrow(dAta),1],ncol(dAta)-1), y=eQm, pch=rep(16,ncol(dAta)-1), col = cBp[-c(3,5)], cex=2)
  legend("topleft", inset=c(0,0), legend = paste0(colnames(dAta)[-1],": ",round(dAta[nrow(dAta),-1],2)), pch = rep(16,3), col = cBp[-c(3,5)], bty="n", cex = 2)
}

##### plot rate changes for time series model #####
ebcRPlt = function(iniPop, pA){
  dAta=ebcData(endTime=1e3, iniPop=1e-5, parameter=pA)
  rAte=as.data.frame(matrix(NA,nr=nrow(dAta),nc=ncol(dAta)-2))
  for(i in 1:nrow(rAte)){rAte[i,]=ebcRate(pop=as.numeric(dAta[i,2:4]), para=pA)};rm(i)
  matplot(dAta[,1], rAte, type="l", lty=1, lwd=5, col=cBp[-c(3,5)], xlab=paste0(colnames(dAta)[1]," (day)"), ylab="rate of change of carbon density (gC/(m^3 t))", cex.lab=2, cex.axis=2, cex.main=2, main=paste0(c("x","e_PR","e_P","g_P","a_P","\ne_BR","e_B","g_B","m_B")," = ",signif(pA,4), collapse=", "))
  legend("topleft", inset=c(0,0), legend = paste0(colnames(dAta)[2:4],": ",round(rAte[nrow(dAta),],2)), pch = rep(16,3), col = cBp[-c(3,5)], bty="n", cex = 2)
}

##### effect of initial carbon density #####
bOundary = function(pA){
  pA = as.numeric(pA)
  name = c("x","e_PR","e_P","g_P","a_P","\ne_BR","e_B","g_B","m_B")
  
  a1 = ebcAlt(pA,2)
  a1 = a1[which(a1!=Inf)]
  
  
  a = as.data.frame(matrix(NA,nc=4,nr=0))
  for(i0 in 0:12){for(i1 in c(1,5)){
    i2 = i1*10^-i0
    a0 = ebcData(endTime=1e3, iniPop=i2, parameter=pA)
    a = rbind(a,c(i2,as.numeric(a0[nrow(a0),-1])))
  }};rm(i0,i1,i2)
  colnames(a) = c("log10(iniPop)","C","P","B","A")
  
  rAngePlt = c(0,max(a1)*1.1)
  matplot(log10(a[,1]),a[,-1], type="l", lty=1, lwd=5, col=cBp[-c(3,5)], xlab=colnames(a)[1], ylab="final carbon density (gC/m^3)", cex.lab=2, cex.axis=2, cex.main=2, main=paste0(name," = ",signif(pA,4), collapse=", "), ylim=rAngePlt)
  legend("topright", inset=c(.3,0), legend = colnames(a)[-1], pch = rep(16,3), col = cBp[-c(3,5)], bty="n", cex = 2) # legend = paste0(colnames(a)[-1],": ",signif(a[nrow(a),-1],2))
  
  yL = a[nrow(a),-1]
  for(i in 1:length(yL)){if(yL[i]>rAngePlt[2] | yL[i]<0){yL[i] = rAngePlt[2]/5*i}};rm(i)
  text(x=rep(min(log10(a[,1])),4), y=yL+rAngePlt[2]*.05, label=paste0(colnames(a)[-1],": ",signif(a[nrow(a),-1],4)), cex=1.3)
  
  yR = a[1,-1]
  for(i in 1:length(yR)){if(yR[i]>rAngePlt[2] | yR[i]<0){yR[i] = rAngePlt[2]/5*i}};rm(i)
  text(x=rep(max(log10(a[,1])),4), y=yR+rAngePlt[2]*.05, label=paste0(colnames(a)[-1],": ",signif(a[1,-1],4)), cex=1.3)
}