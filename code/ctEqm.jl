#!/bin/env julia

# Author 	: PokMan Ho
# Script 	: ctEqm.jl
# Desc 		: [hpc] numerical integration scanning
# Input 	: julia ctEqm.jl <iniPop>
# Output 	: result csv
# Arg 		: 1
# Date 		: May 2020

##### pkg #####
iNi = parse(Float64, ARGS[1])
pAth = "/rds/general/user/ph419/home/pj/"
include(pAth*"func.jl")

##### import #####
aNA = CSV.read(pAth*"maxYield_ALL.csv")
println("import finished")

##### function #####

##### scan #####
nUm = zeros(size(aNA)[1],4)
nUM = ones(size(aNA)[1],4)
#for i in 1:1000
for i in 1:size(aNA)[1]
	#a = ebcData(1000,1e-12,aNA[i,1:9])
	a = ebcData(1000,iNi,aNA[i,1:9])
	nUm[i,:] = a[size(a)[1],:]
	nUM[i,:] = a[size(a)[1],:]
	if i%5e4==0;println(string(round(i/size(aNA)[1]*100, digits=2))*"% finished; i > "*string(i/1e3)*"K");end
end

##### export #####
nUm = DataFrame(nUm)
nUM = DataFrame(nUM)
rename!(nUm, [Symbol("eqm$i") for i in ["C","P","B","A"]])
rename!(nUM, [Symbol("eqm$i") for i in ["C","P","B","A"]])
CSV.write(pAth*"res/j0_"*ARGS[1]*".csv",nUm)
CSV.write(pAth*"res/j1_"*ARGS[1]*".csv",nUM)
