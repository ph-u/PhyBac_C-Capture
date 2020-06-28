#!/bin/env R

# Author 	: PokMan HO
# Script 	: analysis.R
# Desc 		: modIRL.R result analyses
# Input 	: run this script in R console; graphs can't be run via automated loops
# Output 	: plots in `result/`
# Arg 		: 0
# Date 		: Jun 2020

##### in #####
source("func.R")
library(gridExtra)
library(ggplot2)
ot = "../result/"
a = read.csv("../data/anaIRL.csv", header = T)
## yield calculation
a$yield3C = ifelse(is.finite(a$eqm3A),log(a$eqm3C*ifelse(a$x==0,1,a$x)),NA)
a$yield4C = ifelse(is.finite(a$eqm4A),log(a$eqm4C*ifelse(a$x==0,1,a$x)),NA)
## carbon magnitude calculation
a$log3A = log(a$eqm3A)
a$log4A = log(a$eqm4A)

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

## reformat table to adapt ggplot
{a.t = a[,-c(10:17)] ## parameters (9 cols), log yields (2 col), log total carbon (2 col)
        a.HR = rbind(a.t,a.t)
        a.HR$yield4C[1:nrow(a.t)] = a.t$yield3C
        a.HR$log4A[1:nrow(a.t)] = a.t$log3A
        a.HR$eqm = rep(c(3,4), each=nrow(a.t))
        a.HR$yield3C = a.HR$log3A = NULL
        colnames(a.HR)[10:11] = c("yield","totalC")
        rm(a.t)
}
## yield comparisons
st.ref = c(1.7,2.3,12)
## pairwise Wilcox based on carbon harvest rate
st.0 = seq(st.ref[1],st.ref[1]+length(unique(a$x))-2,1) ## line segment start coordinate
st.1 = seq(st.ref[2],st.ref[2]+length(unique(a$x))-2,1) ## line segment end coordinate
st.2 = seq(st.ref[3],st.ref[3]+(nrow(a.PB)-1)*1.5,1.5) ## pairwise Wilcox within P+B systems
png(paste0(ot,"Wilcox.png"), width = 1800, height = 1000)
ggplot()+theme_bw()+
        geom_boxplot(aes(x=as.factor(a.HR$x), y=a.HR$yield, fill=as.factor(a.HR$eqm)))+
        xlab("carbon harvest rate (1/day)") + ylab("log yield flux") +
        scale_fill_manual(name="system", labels=c("P-only", "P+B"), values = cBpT[c(4,2)])+
        scale_y_continuous(breaks = round(seq(min(a.HR$yield[is.finite(a.HR$yield)]),max(a.HR$yield[is.finite(a.HR$yield)]),2)))+
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
dev.off()
rm(list = ls(pattern = "st."))

##### distribution across biological parameters #####
## restructure dataframe
value = c(a$yield3C,a$yield4C,a$log3A,a$log4A)
Source = rep(c("yield","logA"), each=nrow(a)*2)
eqm = rep(c("P-only","P+B"), 2, each=nrow(a))
a.pt = data.frame(a,Source,value,eqm);rm(Source,value, eqm)

## line plots with 95% confidence interval
xX=2;{a.Ln = a.pt[which(a.pt$x==xX),]
p_tmp = ggplot()+theme_bw()+ylim(c(-9,5)) + ylab(paste0("natural log eqm values, harvest = ",xX," day^-1")) + scale_linetype_manual(name="type", labels=c("total carbon", "yield flux"), values = 1:2)
if(xX>0){
        p_tmp = p_tmp + scale_fill_manual(name="system", values = cBpT[c(4,2)])+scale_colour_manual(name="system", values = cBp[c(4,2)])
}else{
        p_tmp = p_tmp + scale_fill_manual(name="system", values = cBpT[2])+scale_colour_manual(name="system", values = cBp[2])
}

p_2 = p_tmp + xlab(colnames(a.Ln)[2]) + geom_smooth(aes(x=a.Ln[,2], y=a.Ln$value, fill=a.Ln$eqm, col=a.Ln$eqm, linetype=a.Ln$Source)) + geom_text(aes(x=.1, y=4, label="(A)"), size=10)
p_3 = p_tmp + xlab(colnames(a.Ln)[3]) + geom_smooth(aes(x=a.Ln[,3], y=a.Ln$value, fill=a.Ln$eqm, col=a.Ln$eqm, linetype=a.Ln$Source)) + geom_text(aes(x=.45, y=4, label="(B)"), size=10)
p_4 = p_tmp + xlab(colnames(a.Ln)[4]) + geom_smooth(aes(x=a.Ln[,4], y=a.Ln$value, fill=a.Ln$eqm, col=a.Ln$eqm, linetype=a.Ln$Source)) + geom_text(aes(x=.25, y=4, label="(C)"), size=10)
p_5 = p_tmp + xlab(colnames(a.Ln)[5]) + geom_smooth(aes(x=a.Ln[,5], y=a.Ln$value, fill=a.Ln$eqm, col=a.Ln$eqm, linetype=a.Ln$Source)) + geom_text(aes(x=.1, y=4, label="(D)"), size=10)
p_6 = p_tmp + xlab(colnames(a.Ln)[6]) + geom_smooth(aes(x=a.Ln[,6], y=a.Ln$value, fill=a.Ln$eqm, col=a.Ln$eqm, linetype=a.Ln$Source)) + geom_text(aes(x=.15, y=4, label="(E)"), size=10)
p_7 = p_tmp + xlab(colnames(a.Ln)[7]) + geom_smooth(aes(x=a.Ln[,7], y=a.Ln$value, fill=a.Ln$eqm, col=a.Ln$eqm, linetype=a.Ln$Source)) + geom_text(aes(x=.15, y=4, label="(F)"), size=10)
p_8 = p_tmp + xlab(colnames(a.Ln)[8]) + geom_smooth(aes(x=a.Ln[,8], y=a.Ln$value, fill=a.Ln$eqm, col=a.Ln$eqm, linetype=a.Ln$Source)) + geom_text(aes(x=.25, y=4, label="(G)"), size=10)
p_9 = p_tmp + xlab(colnames(a.Ln)[9]) + geom_smooth(aes(x=a.Ln[,9], y=a.Ln$value, fill=a.Ln$eqm, col=a.Ln$eqm, linetype=a.Ln$Source)) + geom_text(aes(x=.05, y=4, label="(H)"), size=10)

};{
        png(paste0(ot,"var_",ifelse(xX<1,"0",""),xX*10,".png"), res = 100, width = 2000, height = 700)
        grid.arrange(p_2, p_3, p_4, p_5, p_6, p_7, p_8, p_9, nrow=2)
        dev.off()
};rm(list=ls(pattern = "p_"));rm(xX, a.Ln)
