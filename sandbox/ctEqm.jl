#!/bin/env julia

# Author:   PokMan Ho
# Script:   ctEqm.jl
# Desc:   	count eqm position from numerical estimations
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
nUm = DataFrame(e1=Float16[],e2=Float16[],e3=Float16[],e4=Float16[])
#nUm = DataFrame(e1=Float16[],e2=Float16[],e3=Float16[],e4=Float16[],Sim=Float16[])
for i in 1:size(aNA)[1]
	a = ebcData(1000,iNi,aNA[i,1:9])
	p0 = a[size(a)[1],1:3]
	p1 = Array(aNA[i,names(aNA)[10:12]])
	p2 = Array(aNA[i,names(aNA)[14:16]])
	p3 = Array(aNA[i,names(aNA)[18:20]])
	p4 = Array(aNA[i,names(aNA)[22:24]])
	push!(nUm, vcat(sum(p0-p1), sum(p0-p2), sum(p0-p3), sum(p0-p4)))
#p5 = vcat(sum(p0-p1), sum(p0-p2), sum(p0-p3), sum(p0-p4))
#p6 = broadcast(abs,p5)
#if minimum(p6)<10
#p6 = findall(x -> x == minimum(p6), p6)
#else
#p6 = 0
#end
	if i%5e4==0;println(string(round(i/size(aNA)[1]*100, digits=2))*"% finished; i > "*string(i/1e3)*"K");end
	## findall https://stackoverflow.com/questions/41636928/julia-find-the-indices-of-all-maxima
	## broadcast https://stackoverflow.com/questions/53943507/julia-absolute-value-of-an-array
#push!(nUm, vcat(p5,p6))
end

##### export #####
CSV.write("p_tmp1/"*ARGS[1]*".csv")
