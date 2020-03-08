#!/bin/env julia

# author: 	PokMan HO (pok.ho19@imperial.ac.uk)
# script: 	m_EBC_ccm_hpcParaScan.jl
# desc: 	hpc adapted numerical Scan on eqm position of EBC-ccm model
# input: 	```julia m_EBC_ccm_paraScan.jl```
# output: 	csv file in same directory
# arg: 		0
# date: 	Mar 2020

# Pkg
using RCall, PyCall, DataFrames, CSV, Dates
mt = pyimport("math")
sc = pyimport("scipy")
itg = pyimport("scipy.integrate")

# get env arguments
i1=Int8(ARGS[1])/100 ## phy growth rate

# model
function ebc0(popDen, t, gp,ep,Rp,mp, gc,ec,Rc,mc)

    ## population densities
    P = popDen[:1]
    M = popDen[:2]
    C = popDen[:3]

    ## fluctuation model
    dp = P*(gp*ep - Rp - mp)
    dm = P*(gp*(1-ep) + mp) + C*(gc*(1-ec)*M + mc)
    dc = C*(gc*ec*M - Rc - mc)

    ## non-recoverable elimination
    if P <=0; dp=0;end
    if C <=0; dc=0;end

    return(sc.array([dp,dm,dc]))
end

# set time
t = sc.linspace(0, 50, 100) # 100 time steps in 50 time units

# initiate empty df
parm = DataFrame(gp = Float64[], ep = Float64[], Rp = Float64[], mp = Float64[], gc = Float64[], ec = Float64[], Rc = Float64[], mc = Float64[])
ctNAs = 1 ## initiate token

println("finish env setup at "*string(Dates.now()))

## nested loops testing
for i2 in 1:100;for i3 in 1:100;for i4 in 1:100
                for i5 in 1:100;for i6 in 1:100;for i7 in 1:100;for i8 in 1:100

                                i2 = i2/100 ## phy handling efficiency
                                i3 = i3/100 ## phy respiration rate
                                i4 = i4/100 ## phy death rate
                                i5 = i5/100 ## eco growth rate
                                i6 = i6/100 ## eco handling efficiency
                                i7 = i7/100 ## eco respiration rate
                                i8 = i8/100 ## eco death rate

                                pops = sc.array([5,5,5]) ## initial C-conc
                                pops, infodict = itg.odeint(ebc0, pops, t, full_output=true, args=(i1,i2,i3,i4,i5,i6,i7,i8))

                                @rput pops
                                R"
                                pops[pops<=0] <- NA
                                ctNAs <- sum(is.na(pops))
                                "
                                @rget ctNAs

                                if ctNAs ==0
                                    push!(parm, [i1,i2,i3,i4,i5,i6,i7,i8]) ## rbind in Julia
                                end
end;end;end;end;end;end;end

println("finish model scanning at "*string(Dates.now()))

## export DataFrame as csv
CSV.write("/rds/general/user/ph419/home/paraScan/res/stableParm."*ARGS[1]*".csv",parm)
