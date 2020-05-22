#!/bin/env julia

# Author:   PokMan Ho
# Script:   ctEqm.jl
# Desc:   	numerical integration scanning
# Input: 	julia ctEqm.jl <iniPop>
# Output: 	result csv
# Arg: 		1
# Date: 	May 2020

##### pkg #####
iNi = parse(Float16, ARGS[1])
include("../code/func.jl")

##### import #####
aNA = CSV.read("../result/maxYield_ALL.csv")
println("import finished")

##### function #####

##### scan #####
nUm = zeros(size(aNA)[1],4)
for i in 1:1000
#for i in 1:size(aNA)[1]
	a = ebcData(1000,1e-12,aNA[i,1:9])
	#a = ebcData(1000,iNi,aNA[i,1:9])
	nUm[i,:] = a[size(a)[1],:]
	if i%5e4==0;println(string(round(i/size(aNA)[1]*100, digits=2))*"% finished; i > "*string(i/1e3)*"K");end
end

##### export #####
nUm = DataFrame(nUm)
rename!(nUm, [Symbol("eqm$i") for i in ["C","P","B","A"]])
CSV.write("p_tmp1/num_"*ARGS[1]*".csv",nUm)
