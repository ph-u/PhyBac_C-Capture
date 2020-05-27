#!/bin/env Rscript

# Author 	: PokMan Ho
# Script 	: j_pie.R
# Desc 		: [hpc] equilibrium position identification & representation
# Input 	: j_pie.R <power>
# Output 	: `res/` directory - j_d1e-${i}.csv, j_p1e-${i}.png
# Arg 		: 1
# Date 		: May 2020

##### env #####
args=(commandArgs(T))
ref = read.csv("maxYield_ALL.csv", header=T) ## possible eqm positions
a0 = read.csv(paste0("res/j_1e-",args[1],".csv"), header=T) ## numerical solution
rEs = as.data.frame(matrix(NA, nc=5, nr=nrow(ref))) ## discrepancy rec

##### convert NA to Inf #####
a0[is.na(a0)]=Inf

##### discrepancy compare #####
for(i in 1:(ncol(rEs)-1)){
	p0 = 0
	for(i0 in 1:3){
		p0 = p0+abs(a0[,i0]-ref[,(9+4*(i-1)+i0)]) ## vector sum of discrepancies for one eqm position
	}
	rEs[,i] = p0 ## mark total discrepancy for one eqm position
};rm(i,i0)
for(i in 1:nrow(rEs)){
		if(length(which(rEs[i,-5]<1))==0 | length(which(rEs[i,-5]==min(rEs[i,-5])))>1){
				rEs[i,5]=0
		}else{
				rEs[i,5]=which(rEs[i,-5]==min(rEs[i,-5]))
		}
		if(i%%5e4==0){cat(paste0(round(i/nrow(rEs)*100,2),"% finished; i=",i,"\n"))}
};rm(i) ## get min discrepancy

##### export #####
png(paste0("res/j_p1e-",args[1],".png"))
pie(table(rEs[,5]), main=paste0("initial carbon density = 1e-",args[1]))
dev.off()

colnames(rEs) = c(paste0("eqm",1:4), "best_eqm")
write.csv(rEs,paste0("res/j_d1e-",args[1],".csv"), row.names=F)
