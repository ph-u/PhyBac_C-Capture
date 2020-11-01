#!/usr/bin/env Rscript

# Author 	: PokMan HO
# Script 	: paraDistri.R
# Desc 		: mData.csv attribute graphs plotting
# Input 	: `Rscript paraDistri.R`
# Output 	: graphs in `result/parComplete.pdf` on data attribute discriptions
# Arg 		: 0
# Date 		: 20201101

##### pkg import #####

##### in #####
rAw = read.csv("../data/mData.csv", stringsAsFactor=F)

##### func #####
long2wide = function(col1, col2, data) {
    dF = as.data.frame(matrix(nr=length(unique(data[,col1])), nc=length(unique(data[,col2]))), row.names = unique(data[,col1]))
    colnames(dF) = unique(data[,col2])
    cat(paste0("col: ",ncol(dF),"; row: ",nrow(dF),"\n"))
    for(y in 1:ncol(dF)){for(x in 1:nrow(dF)){
        dF[x,y] = nrow(dF[which(as.character(interaction(data[,col1],data[,col2])) == as.character(interaction(rownames(dF)[x],colnames(dF)[y]))),])
    }}
    return(dF)
}
wide2long = function(data,c1,c2) {
    dF = as.data.frame(matrix(nr = prod(dim(data)), nc = 3))
    colnames(dF) = c(c1,c2,"value")
    i=1
    for(x in 1:nrow(data)){for(y in 1:ncol(data)){
        dF[i,] = c(rownames(data)[x],colnames(data)[y],data[x,y])
        i = i+1
    }}
    return(dF)
}

##### pivot tables #####
rAw[is.na(rAw)] = "no_Info"
phy = long2wide("ConPhylum", "parameter", rAw)
pdf("../result/parComplete.pdf", width=10)
levelplot(as.matrix(log(t(phy))), ylab="ConPhylum", xlab="parameter", main="The degree of overlap between parameter requirements and\nphylum of species in available data", col.regions = rev(grey(0:100/100)), aspect="fill")
dev.off()
