#!/bin/env julia

# Author: 	PokMan HO
# Script: 	numScan1.jl
# Desc: 	numerical solve for searching breakpoint boundary for parameters combinations
# Input: 	julia numScan1.jl <id> <min_x> <ePR> <eP> <gP> <min_aP> <eBR> <eB> <gB> <mB>
# Output: 	../data/numScan_<id>.csv
# Arg: 		10
# Date: 	Apr 2020

##### pkg #####
using PyCall, DataFrames, CSV
sc = pyimport("scipy")
itg = pyimport("scipy.integrate")

##### functions #####
function ebc7(Den,t,x, g_P,e_PR,e_P,a_P, g_B,e_BR,e_B,m_B)

    ## variable sorting
    C = Den[:1]
    P = Den[:2]
    B = Den[:3]

    ## rate calculation
    dC = g_P*e_PR*(1-e_P)*P +a_P*P^2 +g_B*(e_BR*(1-e_B)-1)*C*B +m_B*B -x*C
    dP = g_P*e_PR*e_P*P -a_P*P^2
    dB = g_B*e_BR*e_B*C*B -m_B*B

    ## logic check
    if C<=0; dC=0;end
    if P<=0; dP=0;end
    if B<=0; dB=0;end

    return(sc.array([dC,dP,dB]))

end

function ebcPlt(iniPop, tIme, eNd, para)
	t = sc.linspace(0, eNd, tIme) # sample time series
	pops, infodict = itg.odeint(ebc7, iniPop, t, full_output=true, args=(para[1],para[2],para[3],para[4],para[5],para[6],para[7],para[8],para[9]))
    pops = DataFrame(pops)
    pops[:,:x4] = pops[:,:x1]+pops[:,:x2]+pops[:,:x3]
	
	return(vcat(aRg,Array(pops[tIme,:])))
end

##### default settings #####
ini = sc.array([.1/100000000000,.1/100000000000,.1/100000000000]) ## 1e-12 for all 3 pools, approx population of 1000
tIme = 100 ## time step of 100
eNd = 1000 ## total time line of 1000 units

rEs = DataFrame(x=Float16[],
                e_PR=Float16[],e_P=Float16[],g_P=Float16[],a_P=Float16[],
                e_BR=Float16[],e_B=Float16[],g_B=Float16[],m_B=Float16[],
                eqmC=Float16[],eqmP=Float16[],eqmB=Float16[],eqmA=Float16[]) ## result record dataframe

aRg = [];for i in 2:length(ARGS); push!(aRg, parse(Float16, ARGS[i]));end

##### collection #####
aRg0 = aRg
xMax = collect(aRg[1]:.05:aRg[1]+.5)
aMax = collect(aRg[5]:.05:aRg[5]+.5)

for i0 in 1:length(xMax)
	aRg0[1] = xMax[i0]
	for i1 in 1:length(aMax)
		aRg0[5] = aMax[i1]
		push!(rEs, ebcPlt(ini,tIme,eNd,aRg0))
end;end
CSV.write("../data/nS_"*ARGS[1]*".csv", rEs)
