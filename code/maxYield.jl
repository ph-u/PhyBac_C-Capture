#!/bin/env julia

# author: 	PokMan HO (hpokman@connect.hku.hk)
# script: 	maxYield.jl
# desc: 	numerical solve for searching the max yield of carbon
# input: 	julia maxYield.jl <sig. density threshold>
# output: 	../result/maxYield.csv
# arg: 		1
# date: 	Apr 2020

##### env set-up #####
using DataFrames, CSV
ags = parse(Float16, ARGS[1]) # https://stackoverflow.com/questions/33440857/julia-convert-numeric-string-to-float-or-int
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

##### test range set-up #####
x = collect(0:.5:1)#0 # rate of carbon removal
#e = [1:100;]/100 # scan test of fractions
ePR = collect(.1:.5:1)#.563 # non-respired carbon fraction of photocell
eP = collect(.1:.5:1)#.63 # fraction of biomass-fixed carbon in photocell
gP = collect(.1:.2:2) # rate of phytocell growth
aP = collect(.001:.1:1) # rate of phytocell death due to intraspecific interference
eBR = collect(.1:.5:1)#.6 # non-respired carbon fraction of detritivore
eB = collect(.1:.5:1)#.55 # fraction of biomass-fixed carbon in detritivore
gB = collect(.1:.2:2) # rate of detritivore growth
mB = collect(.001:.1:1) # rate of detritivore death

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
