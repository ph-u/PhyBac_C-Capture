#!/bin/env julia

# Author: 	PokMan HO
# Script: 	func.jl
# Desc: 	self-defined functions
# Input: 	none
# Output: 	none
# Arg: 		0
# Date: 	May 2020

##### pkg #####
using PyCall, DataFrames, CSV, Plots, SymPy
sc = pyimport("scipy")
cst = pyimport("scipy.constants")
itg = pyimport("scipy.integrate")

##### project model #####
function ebc7(Den,t,x, g_P,e_PR,e_P,a_P, g_B,e_BR,e_B,m_B)

    ## variable sorting
    C = Den[:1]
    P = Den[:2]
    B = Den[:3]

    ## rate calculation
    dC = g_P*e_PR*(1-e_P)*P +a_P*P^2 +g_B*(e_BR*(1-e_B)-1)*C*B +m_B*B -x*C
    dP = g_P*e_PR*e_P*P -a_P*P^2
    dB = g_B*e_BR*e_B*C*B -m_B*B

    return(sc.array([dC,dP,dB]))

end

##### numerical solving project model #####
function ebcData(endTime=1000, iniPop=1e-12, parameter=[0 .875 .63 .259 .001 .6 .55 1.046 .14])
		tIme = sc.linspace(0, endTime, endTime)
		pops, infodict = itg.odeint(ebc7, sc.array([iniPop,iniPop,iniPop]), tIme, full_output=true, args=(parameter[1],parameter[2],parameter[3],parameter[4],parameter[5],parameter[6],parameter[7],parameter[8],parameter[9]))
		pops = DataFrame(pops)
		pops[:,:x4] = pops[:,:x1]+pops[:,:x2]+pops[:,:x3]
		
		return(Array(pops))
end

##### analytical model solution #####
function ebcEqm(parameter=[0 .875 .63 .259 .001 .6 .55 1.046 .14])
		x=parameter[1]
		ePR=parameter[2]; eP=parameter[2]; gP=parameter[4]; aP=parameter[5]
		eBR=parameter[6]; eB=parameter[7]; gB=parameter[8]; mB=parameter[9]

		C = mB/(eBR*eB*gB)
		P = ePR*eP*gP/aP
		B = (aP*mB*x - eBR*eB*gB*eP*(ePR*gP)^2)/(gB*mB*aP*(eBR-1))

		return([C,P,B])
end

##### analytical model all solutions #####
function ebcAlt(parameter=[0 .875 .63 .259 .001 .6 .55 1.046 .14], out=1)
		x=parameter[1]
        ePR=parameter[2]; eP=parameter[2]; gP=parameter[4]; aP=parameter[5]
        eBR=parameter[6]; eB=parameter[7]; gB=parameter[8]; mB=parameter[9]

		a1 = [0,0,0,0]
		a2 = [mB/(eBR*eB*gB), 0, x/(gB*(eBR-1))]
		a2 = push!(a2,sum(a2))
		a3 = [eP*(ePR*gP)^2/(aP*x), ePR*eP*gP/aP, 0]
		a3 = push!(a3,sum(a3))
		a4 = [mB/(eBR*eB*gB), ePR*eP*gP/aP, (aP*mB*x - eBR*eB*gB*eP*(ePR*gP)^2)/(gB*mB*aP*(eBR-1))]
		a4 = push!(a4,sum(a4))

		if out!=1
			a0 = []
			a0 = append!(a0,x for x in [a1 a2 a3 a4])
		else
			a0 = [a1 a2 a3 a4]
			a0 = DataFrame(transpose(a0))
			rename!(a0,["C","P","B","A"])
		end
		return(a0)
end

##### ebc rate #####
function ebcRate(pop=[1e-5,1e-5,1e-5], para=[0 .875 .63 .259 .001 .6 .55 1.046 .14])
		a=ebc7(pop,0,para[1],para[1],para[3],para[4],para[5],para[6],para[7],para[8],para[9])
		return(a)
end
