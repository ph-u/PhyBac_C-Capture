#!/usr/bin/env Rscript

# Author 	: ph-u
# Script 	: paper_paraDistri.R
# Desc 		: mData.csv attribute graphs plotting
# Input 	: `Rscript paraDistri.R`
# Output 	: `p_paperGraphics/parComplete*.pdf`
# Arg 		: 0
# Date 		: 20201101

##### pkg #####
library(lattice)

##### in #####
rAw = read.csv("../p_paperGraphics/mData.csv", stringsAsFactor=F)

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

##### heatmap #####
rAw[is.na(rAw)] = "no_Info"
phy = long2wide("ConPhylum", "parameter", rAw)
pdf("../p_paperGraphics/parCompleteP.pdf", width=10)
levelplot(as.matrix(log(t(phy))), ylab="Consumer Phylum", xlab="parameter", main="The degree of overlap (log-scale) between parameter requirements and\nphylum of species in available data", col.regions = rev(grey(0:100/100)), aspect="fill")
invisible(dev.off())

phyC = long2wide("ConClass", "parameter", rAw)
pdf("../p_paperGraphics/parCompleteC.pdf", width=10)
levelplot(as.matrix(log(t(phyC))), ylab="Consumer Class", xlab="parameter", main="The degree of overlap (log-scale) between parameter requirements and\nclass of species in available data", col.regions = rev(grey(0:100/100)), aspect="fill")
invisible(dev.off())

phyO = long2wide("ConOrder", "parameter", rAw)
pdf("../p_paperGraphics/parCompleteO.pdf", width=10)
levelplot(as.matrix(log(t(phyO))), ylab="Consumer Order", xlab="parameter", main="The degree of overlap (log-scale) between parameter requirements and\norder of species in available data", col.regions = rev(grey(0:100/100)), aspect="fill")
invisible(dev.off())

phyF = long2wide("ConFamily", "parameter", rAw)
pdf("../p_paperGraphics/parCompleteF.pdf", width=12, height=21)
levelplot(as.matrix(log(t(phyF))), ylab="Consumer Family", xlab="parameter", main="The degree of overlap (log-scale) between parameter requirements and\nfamily of species in available data", col.regions = rev(grey(0:100/100)), aspect="fill")
invisible(dev.off())

phyG = long2wide("ConGenus", "parameter", rAw)
pdf("../p_paperGraphics/parCompleteG.pdf", width=10, height=21)
levelplot(as.matrix(log(t(phyG))), ylab="Consumer Genus", xlab="parameter", main="The degree of overlap (log-scale) between parameter requirements and\ngenus of species in available data", col.regions = rev(grey(0:100/100)), aspect="fill")
invisible(dev.off())
