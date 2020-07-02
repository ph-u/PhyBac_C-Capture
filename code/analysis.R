#!/bin/env R

# Author 	: PokMan HO
# Script 	: analysis.R
# Desc 		: modIRL.R result analyses
# Input 	: `Rscript analysis.R`
# Output 	: plots in `result/`
# Arg 		: 0
# Date 		: Jun 2020

##### in #####
source("func.R")
lib = c("gridExtra","ggplot2","reshape2")
invisible(lapply(lib,library,character.only=T));rm(lib)
ot = "../result/"
a = read.csv("../data/anaIRL.csv", header = T)
a.0 = a ## conserve raw data
## yield calculation
a$yield3C = ifelse(is.finite(a$eqm3A),log(a$eqm3C*ifelse(a$x==0,1,a$x)),NA)
a$yield4C = ifelse(is.finite(a$eqm4A),log(a$eqm4C*ifelse(a$x==0,1,a$x)),NA)
## carbon magnitude calculation
a$log3A = log(a$eqm3A)
a$log4A = log(a$eqm4A)

a = a[which(a$eqm4B>0 & is.finite(a$eqm4B)), ## extract only P+B valid data for fair comparison
      -c(10:17)] ## parameters (9 cols), log yields (2 col), log total carbon (2 col)
## check sample size is same across all valid record
# cHeck = as.data.frame(matrix(NA,nc=5,nr=length(unique(a$x))))
# colnames(cHeck) = c("x",paste0(rep(c("yield_","totalCarbon_"),each=2),3:4))
# cHeck$x = unique(a$x)
# for(i in 1:nrow(cHeck)){
#         t = a[which(a$x==cHeck[i,1]),]
#         for(i0 in 2:ncol(cHeck)){cHeck[i,i0] = sum(is.finite(t[,8+i0]))}
# };rm(i,i0,t)

## restructure dataframe
a.pt = melt(a, id.vars = colnames(a)[1:9])
a.pt$Source = ifelse(a.pt$variable=="yield3C" | a.pt$variable=="yield4C", "yield","logA")
a.pt$eqm = ifelse(a.pt$variable=="yield3C" | a.pt$variable=="log3A", "P-only","P+B")

##### plot of Wilcox test summary & carbon harvest comparison #####
wIl = as.data.frame(matrix(NA, nr=length(unique(a$x)), nc=3))
colnames(wIl) = c("x",paste0("yield",c("_W","_p")))
wIl[,1] = unique(a$x)[order(unique(a$x))]
for(i in 1:nrow(wIl)){ ## fill in Wilcox summary statistics and p-values
        w.y = try(wilcox.test(a$yield3C[which(a$x==wIl[i,1])], a$yield4C[which(a$x==wIl[i,1])]), silent = T)
        ## silence error while filling in summary statistics
        if(class(w.y)=="try-error"){wIl[i,2:3] = rep(NA,2)}else{wIl[i,2:3] = c(w.y$statistic, w.y$p.value)}
};rm(i,w.y)
wIl$sig = ifelse(wIl$yield_p>.1,"=NS",ifelse(wIl$yield_p<.001,"<<0.01",ifelse(wIl$yield_p<.01,"<0.01",paste0("=",round(wIl$yield_p,3)))))

## carbon harvest comparison
a.PB = as.data.frame(matrix(NA, nr=length(unique(a$x))-1, nc=3))
colnames(a.PB) = c("x",paste0("yieldDiff",c("_W","_p")))
a.PB$x = wIl$x[-1]
for(i in 1:nrow(a.PB)){
        a.01 = wilcox.test(a$yield4C[which(a$x==0)], a$yield4C[which(a$x==a.PB[i,1])])
        a.PB[i,-1] = c(a.01$statistic,ifelse(a.01$p.value>.1,"=NS",ifelse(a.01$p.value<.001,"<<0.01",ifelse(a.01$p.value<.01,"<0.01",paste0("=",round(a.01$p.value,3))))))
};rm(a.01, i)


a.HR = a.pt[which(a.pt$Source=="yield"),] ## extract table for plot
## yield comparisons
st.ref = c(1.7,2.3,12)
## pairwise Wilcox based on carbon harvest rate
st.0 = seq(st.ref[1],st.ref[1]+length(unique(a$x))-2,1) ## line segment start coordinate
st.1 = seq(st.ref[2],st.ref[2]+length(unique(a$x))-2,1) ## line segment end coordinate
st.2 = seq(st.ref[3],st.ref[3]+(nrow(a.PB)-1)*1.5,1.5) ## pairwise Wilcox within P+B systems
st.y = round(range(a.HR$value[is.finite(a.HR$value)])) ## set y scale
png(paste0(ot,"Wilcox.png"), width = 1800, height = 1000)
suppressWarnings(print( ## prevent huge load of known NA-related warnings and default method switch calls
        ggplot()+theme_bw()+
                geom_boxplot(aes(x=as.factor(a.HR$x), y=a.HR$value, fill=as.factor(a.HR$eqm)))+
                xlab("carbon harvest rate (1/day)") + ylab("log yield flux") +
                scale_fill_manual(name="system", values = cBpT[c(4,2)])+
                scale_y_continuous(breaks = seq(st.y[1],st.y[2],2))+
                geom_segment(aes(x=st.0,xend=st.1,y=8.5,yend=8.5))+
                geom_text(aes(x=round(st.0), y=10.5, label=paste0("W = ",wIl$yield_W[-1],"\np ",wIl$sig[-1])), size=5)+
                geom_segment(aes(x=rep(1,length(st.1)), xend=st.1, y=st.2, yend=st.2), col="red", lty=4)+
                geom_text(aes(x=round(st.0)-.5, y=st.2+.7, label=paste0("W = ",a.PB$yieldDiff_W[which(!is.na(a.PB$yieldDiff_W))],"; p ",a.PB$yieldDiff_p)), size=5, col="red")+
                theme(axis.title = element_text(size = 20),
                      axis.title.y = element_text(hjust = .25),
                      axis.text = element_text(size = 20),
                      legend.text = element_text(size = 20),
                      legend.title = element_text(size = 20),
                      legend.position = "bottom")
))
invisible(dev.off())
rm(list = ls(pattern = "st."));rm(a.HR,wIl,a.PB)
cat("output Distribution comparison boxplot with Wilcox test summaries finished\n")

##### distribution across biological parameters #####
## line plots with 95% confidence interval
xX=2;{a.Ln = a.pt[which(a.pt$x==xX),]
st.y = range(a.Ln$value[is.finite(a.Ln$value)]); st.y = c(floor(st.y)[1],ceiling(st.y)[2])
p_tmp = ggplot()+theme_bw()+ylim(st.y) + ylab(paste0("natural log eqm values, harvest = ",xX," day^-1")) + scale_linetype_manual(name="type", labels=c("total carbon", "yield flux"), values = 1:2)
if(xX>0){
        p_tmp = p_tmp + scale_fill_manual(name="system", values = cBpT[c(4,2)])+scale_colour_manual(name="system", values = cBp[c(4,2)])
}else{
        p_tmp = p_tmp + scale_fill_manual(name="system", values = cBpT[2])+scale_colour_manual(name="system", values = cBp[2])
}

p_2 = p_tmp + xlab(colnames(a.Ln)[2]) + geom_smooth(aes(x=a.Ln[,2], y=a.Ln$value, fill=a.Ln$eqm, col=a.Ln$eqm, linetype=a.Ln$Source)) + geom_text(aes(x=max(a[,2])-diff(range(a[,2]))*.1, y=st.y[2]-1, label="(A)"), size=10)
p_3 = p_tmp + xlab(colnames(a.Ln)[3]) + geom_smooth(aes(x=a.Ln[,3], y=a.Ln$value, fill=a.Ln$eqm, col=a.Ln$eqm, linetype=a.Ln$Source)) + geom_text(aes(x=max(a[,3])-diff(range(a[,3]))*.1, y=st.y[2]-1, label="(B)"), size=10)
p_4 = p_tmp + xlab(colnames(a.Ln)[4]) + geom_smooth(aes(x=a.Ln[,4], y=a.Ln$value, fill=a.Ln$eqm, col=a.Ln$eqm, linetype=a.Ln$Source)) + geom_text(aes(x=max(a[,4])-diff(range(a[,4]))*.1, y=st.y[2]-1, label="(C)"), size=10)
p_5 = p_tmp + xlab(colnames(a.Ln)[5]) + geom_smooth(aes(x=a.Ln[,5], y=a.Ln$value, fill=a.Ln$eqm, col=a.Ln$eqm, linetype=a.Ln$Source)) + geom_text(aes(x=max(a[,5])-diff(range(a[,5]))*.1, y=st.y[2]-1, label="(D)"), size=10)
p_6 = p_tmp + xlab(colnames(a.Ln)[6]) + geom_smooth(aes(x=a.Ln[,6], y=a.Ln$value, fill=a.Ln$eqm, col=a.Ln$eqm, linetype=a.Ln$Source)) + geom_text(aes(x=max(a[,6])-diff(range(a[,6]))*.1, y=st.y[2]-1, label="(E)"), size=10)
p_7 = p_tmp + xlab(colnames(a.Ln)[7]) + geom_smooth(aes(x=a.Ln[,7], y=a.Ln$value, fill=a.Ln$eqm, col=a.Ln$eqm, linetype=a.Ln$Source)) + geom_text(aes(x=max(a[,7])-diff(range(a[,7]))*.1, y=st.y[2]-1, label="(F)"), size=10)
p_8 = p_tmp + xlab(colnames(a.Ln)[8]) + geom_smooth(aes(x=a.Ln[,8], y=a.Ln$value, fill=a.Ln$eqm, col=a.Ln$eqm, linetype=a.Ln$Source)) + geom_text(aes(x=max(a[,8])-diff(range(a[,8]))*.1, y=st.y[2]-1, label="(G)"), size=10)
p_9 = p_tmp + xlab(colnames(a.Ln)[9]) + geom_smooth(aes(x=a.Ln[,9], y=a.Ln$value, fill=a.Ln$eqm, col=a.Ln$eqm, linetype=a.Ln$Source)) + geom_text(aes(x=max(a[,9])-diff(range(a[,9]))*.1, y=st.y[2]-1, label="(H)"), size=10)

};{
        png(paste0(ot,"var_",ifelse(xX<1,"0",""),xX*10,".png"), res = 100, width = 2000, height = 700)
        suppressWarnings(suppressMessages( ## prevent huge load of known NA-related warnings and default method switch calls
                grid.arrange(p_2, p_3, p_4, p_5, p_6, p_7, p_8, p_9, nrow=2)
        ))
        invisible(dev.off())
};rm(list=ls(pattern = "p_"));rm(xX, a.Ln)
cat("output Combined plot of specified harvest rate based on biological parameters finished\n")
