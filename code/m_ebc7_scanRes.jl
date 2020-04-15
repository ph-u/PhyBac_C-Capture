#!/bin/env julia

# author: 	PokMan HO (hpokman@connect.hku.hk)
# script: 	m_ebc7_scanRes.jl
# desc: 	plotting for scan result (Jupyter notebook replacement)
# input: 	julia m_ebc7_scanRes.jl <>
# output: 	../sandbox/gif/surfacePlt.gif
# arg: 		1
# date: 	Apr 2020

##### CLI input #####
colChg = parse(Int8,ARGS[1]) # col for animation
xyAxis = [parse(Int8,ARGS[2]) parse(Int8,ARGS[3]) parse(Int8,ARGS[4])] # xyz axis col
setPara = [1 2 2 1 2 2 2 2 3] # 9 default parameter

##### pkg #####
println("pkg importing")
using DataFrames, CSV, RCall, Plots

##### raw data import & R env set-up #####
println("setting up env & data")
rAw = CSV.read("../result/maxYield_0.1.csv")

@rput rAw
R"
u0 = vector(mode='list', length=9)
for(i in 1:9){
    u0[[i]] = unique(rAw[,i])
};rm(i)
"

##### plot #####
println("making video...")
aa = @animate for i in 1:length(unique(rAw[:,colChg]))
    setPara[colChg] = i
    @rput setPara xyAxis
    R"
    ## extract necessary data
    pp = rAw
    for(i in 1:9){
        if(i%in%xyAxis==F){
        pp = pp[which(rAw[,i]==u0[[i]][setPara[i]]),]
    }};rm(i)
    
    ## convert data into matrix
    mm = matrix(NA, nr=length(unique(pp[,xyAxis[1]])), nc=length(unique(pp[,xyAxis[2]])))
    rownames(mm)=unique(pp[,xyAxis[1]])
    colnames(mm)=unique(pp[,xyAxis[2]])
    for(i0 in 1:nrow(pp)){
        mm[which(rownames(mm)==pp[i0,xyAxis[1]]),which(colnames(mm)==pp[i0,xyAxis[2]])] <- pp[i0,xyAxis[3]]
    };rm(i0)
    mmR <- rownames(mm)
    mmC <- colnames(mm)
    "
    @rget mm mmR mmC u0
    if size(mm)[1] >0
    p0 = plot(mmR, mmC, mm, st=:surface, zlim=[0,30],
    xlabel=string(names(rAw)[xyAxis[1]]),
    ylabel=string(names(rAw)[xyAxis[2]]),
    zlabel=string(names(rAw)[xyAxis[3]])*" (gC/m^3)",
    title="Surface plot with default parameters x="*string(u0[1][setPara[1]])*"
        ePR="*string(u0[2][setPara[2]])*", eP="*string(u0[3][setPara[3]])*", gP="*string(u0[4][setPara[4]])*", aP="*string(u0[5][setPara[5]])*"
        eBR="*string(u0[6][setPara[6]])*", eB="*string(u0[7][setPara[7]])*", gB="*string(u0[8][setPara[8]])*", mB="*string(u0[9][setPara[9]]))
    end
end
gif(aa, "gif/surfacePlt.gif", fps=1)
