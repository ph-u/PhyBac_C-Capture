#!/bin/env julia

# Author: 	PokMan HO (hpokman@connect.hku.hk)
# Script: 	maxYield.jl
# Desc: 	analytical solve for searching the max yield of carbon
# Input: 	julia maxYield.jl <sig. density threshold>
# Output: 	../result/maxYield.csv
# Arg: 		1
# Date: 	Apr 2020

##### env set-up #####
using DataFrames, CSV, PyCall
ags = parse(Float16, ARGS[1]) # https://stackoverflow.com/questions/33440857/julia-convert-numeric-string-to-float-or-int
cst = pyimport("scipy.constants")

# @vars C P B
# x, e_PR,e_P,g_P,a_P, e_BR,e_B,g_B,m_B = symbols("x e_PR e_P g_P a_P e_BR e_B g_B m_B",positive=true)

##### equations #####
# dC = g_P*e_PR*(1-e_P)*P +a_P*P^2 +g_B*(e_BR*(1-e_B)-1)*C*B +m_B*B
# dP = g_P*e_PR*e_P*P -a_P*P^2
# dB = g_B*e_BR*e_B*C*B -m_B*B
# dCrm = g_P*e_PR*(1-e_P)*P +a_P*P^2 +g_B*(e_BR*(1-e_B)-1)*C*B +m_B*B -x*C

##### DataFrame set-up #####
rEs = DataFrame(x=Float16[],
				e_PR=Float16[],e_P=Float16[],g_P=Float16[],a_P=Float16[],
				e_BR=Float16[],e_B=Float16[],g_B=Float16[],m_B=Float16[],
				eqmC=Float16[],eqmP=Float16[],eqmB=Float16[],eqmA=Float16[])

##### eqm carbon density functions #####
function ebc7eqm(x, e_PR,e_P,g_P,a_P, e_BR,e_B,g_B,m_B)
	eqmC = m_B/(e_B*e_BR*g_B)
	eqmP = e_P*e_PR*g_P/a_P
	eqmB = (a_P*m_B*x - e_B*e_BR*e_P*e_PR^2*g_B*g_P^2)/(a_P*e_BR*g_B*m_B - a_P*g_B*m_B)
	eqmA = eqmC + eqmP + eqmB
	return([x e_PR e_P g_P a_P e_BR e_B g_B m_B eqmC eqmP eqmB eqmA])
end

function arRhenius(A0, Ea, TC)
		k = cst.physical_constants["Boltzmann constant in eV/K"][1]
		A = A0*exp(-Ea/(k*(TC+273.15)))
		return(A)
end

##### calculated rates #####
P0 = [72288 155144] ## IQR of photocell standardization value
B0 = [1.205e11 1.536e12] ## IQR of bacterial decomposer standardization value
P = arRhenius(P0, .32, 23) ## testing daily growth rates range of photocell
B = arRhenius(B0, .66, 23) ## testing daily growth rates range of bacterial decomposer

##### test range set-up #####
x = collect(0:.01:1) # rate of carbon removal
#e = [1:100;]/100 # scan test of fractions
ePR = .875 #collect(.5:.1:1) # non-respired carbon fraction of photocell
eP = .63 #collect(.5:.1:1) # fraction of biomass-fixed carbon in photocell
gP = collect(P[1]:(P[2]-P[1])/10:P[2]) # rate of phytocell growth
aP = collect(.001:(.4-.001)/10:.4) # rate of phytocell death due to intraspecific interference
eBR = .6 #collect(.5:.1:1) # non-respired carbon fraction of detritivore
eB = .55 #collect(.5:.1:1) # fraction of biomass-fixed carbon in detritivore
gB = collect(B[1]:(B[2]-B[1])/100:B[2]) # rate of detritivore growth
mB = .14 #collect(.1:.2:1) # rate of detritivore death

##### eqm scan #####
for c0 in x
for p1 in ePR;for p2 in eP;for p3 in gP;for p4 in aP
for b1 in eBR;for b2 in eB;for b3 in gB;for b4 in mB
#for p1 in e;for p2 in e;for p3 in gP;for p4 in aP
#for b1 in e;for b2 in e;for b3 in gB;for b4 in mB
resu = ebc7eqm(c0,p1,p2,p3,p4,b1,b2,b3,b4)
if resu[10]>ags && resu[11]>ags && resu[12]>ags ## eqm never return an absolute zero, must have a significance threshold
	push!(rEs, resu)
end

end;end;end;end;end;end;end;end;end

##### export data #####
CSV.write("../result/maxYield_"*string(ags)*".csv", rEs)
