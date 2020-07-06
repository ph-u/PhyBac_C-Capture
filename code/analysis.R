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
a = a[which(a$eqm4B>0 & is.finite(a$eqm4B)),] ## extract for positive but not crashed systems
## yield calculation
a$yield3C = ifelse(a$x==0,log(a$eqm3C+a$eqm3P),log(a$x*a$eqm3C))
a$yield4C = ifelse(a$x==0,log(a$eqm4C+a$eqm4P+a$eqm4B),log(a$x*a$eqm4C))
## carbon magnitude calculation
a$log3A = log(a$eqm3C+a$eqm3P)
a$log4A = log(a$eqm4C+a$eqm4P+a$eqm4B)

a = a[,-c(10:15)] ## parameters (9 cols), log yields (2 col), log total carbon (2 col)
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

##### system carbon: P+B vs P-only #####
a.sys = as.data.frame(matrix(NA, nr=length(unique(a$x))-1, nc=4))
colnames(a.sys) = c("x",paste0("total",c("_W","_p")),"n")
a.sys[,1] = unique(a$x)[order(unique(a$x))[-1]]
for(i in 1:nrow(a.sys)){ ## fill in Wilcox summary statistics and p-values
        t = cbind(a$log3A[which(a$x==a.sys[i,1])],a$log4A[which(a$x==a.sys[i,1])])
        t = as.data.frame(t[which(is.finite(t[,1]) & is.finite(t[,2])),])
        if(nrow(t)>5){
                w.y = wilcox.test(t[,1],t[,2])
                a.sys[i,2:3] = c(w.y$statistic, w.y$p.value)
                rm(w.y)
        }else{a.sys[i,2:3] = rep(NA,2)}
        a.sys[i,4] = nrow(t)
};rm(i,t)
a.sys$sig = ifelse(a.sys$total_p>.1,"=NS",ifelse(a.sys$total_p<.001,"<<0.01",ifelse(a.sys$total_p<.01,"<0.01",paste0("=",round(a.sys$total_p,3)))))

##### yield: P+B vs P-only #####
wIl = as.data.frame(matrix(NA, nr=length(unique(a$x)), nc=4))
colnames(wIl) = c("x",paste0("yield",c("_W","_p")),"n")
wIl[,1] = unique(a$x)[order(unique(a$x))]
for(i in 1:nrow(wIl)){ ## fill in Wilcox summary statistics and p-values
        t = cbind(a$yield3C[which(a$x==wIl[i,1])],a$yield4C[which(a$x==wIl[i,1])])
        t = as.data.frame(t[which(is.finite(t[,1]) & is.finite(t[,2])),])
        if(nrow(t)>5){
                w.y = wilcox.test(t[,1],t[,2])
                wIl[i,2:3] = c(w.y$statistic, w.y$p.value)
                rm(w.y)
        }else{wIl[i,2:3] = rep(NA,2)}
        wIl[i,4] = nrow(t)
};rm(i,t)
wIl$sig = ifelse(wIl$yield_p>.1,"=NS",ifelse(wIl$yield_p<.001,"<<0.01",ifelse(wIl$yield_p<.01,"<0.01",paste0("=",round(wIl$yield_p,3)))))

##### yield & totalC: x=0 vs x!=0 #####
a.PB = as.data.frame(matrix(NA, nr=length(unique(a$x))-1, nc=6))
colnames(a.PB) = c("x",paste0(rep(c("yieldDiff","totalCDiff"),each=2),rep(c("_W","_p"),2)),"n")
a.PB$x = a.sys$x
a.wide4 = dcast(a,ePR+eP+gP+aP+eBR+eB+gB+mB~x,fun.aggregate = sum, value.var = "yield4C") ## concentrate P+B systems in harvest rate for yield comparisons
a.wideC = dcast(a,ePR+eP+gP+aP+eBR+eB+gB+mB~x,fun.aggregate = sum, value.var = "log4A") ## concentrate P+B systems in harvest rate for total carbon comparisons
a.wide4[a.wide4==0] = a.wideC[a.wideC==0] = NA
for(i in 1:nrow(a.PB)){
        t = a.wide4[which(!is.na(a.wide4[,9+i])),c(1:9,9+i)]
        a.01 = wilcox.test(t[,ncol(t)-1], t[,ncol(t)])
        u = a.wideC[which(!is.na(a.wideC[,9+i])),c(1:9,9+i)]
        a.02 = wilcox.test(u[,ncol(u)-1], u[,ncol(u)])
        a.PB[i,-1] = c(a.01$statistic,ifelse(a.01$p.value>.1,"=NS",ifelse(a.01$p.value<.001,"<<0.01",ifelse(a.01$p.value<.01,"<0.01",paste0("=",round(a.01$p.value,3))))),
                       a.02$statistic,ifelse(a.02$p.value>.1,"=NS",ifelse(a.02$p.value<.001,"<<0.01",ifelse(a.02$p.value<.01,"<0.01",paste0("=",round(a.02$p.value,3))))),
                       nrow(t))
        ## prepare for plot
        t[,ncol(t)] = as.numeric(colnames(t)[ncol(t)])
        colnames(t)[ncol(t)] = "x"
        u[,ncol(u)] = as.numeric(colnames(u)[ncol(u)])
        colnames(u)[ncol(u)] = "x"
        if(i==1){
                p = t
                q = u
        }else{
                p = rbind(p,t)
                q = rbind(q,u)
        }
};rm(a.01,a.02, i,t,u)
## amend no harvest P+B data for plot
colnames(p)[ncol(p)-1] = colnames(q)[ncol(q)-1] = "value"
p$variable = "yield4C"
p$Source = "yield"
p$eqm = "no harvest P+B"
p = p[,c(10,1:8,11,9,12:ncol(p))]
q$variable = "log4A"
q$Source = "logA"
q$eqm = "no harvest P+B"
q = q[,c(10,1:8,11,9,12:ncol(q))]

##### summary plot #####
a.HR = a.pt[which(a.pt$Source=="yield" & a.pt$x>0),] ## extract table for plot
a.HR = rbind(a.HR,p)
a.TC = a.pt[which(a.pt$Source=="logA" & a.pt$x>0),] ## extract table for plot
a.TC = rbind(a.TC,q)
rm(p,q)

st.ref = c(0.7,1,1.3)
st.0 = seq(st.ref[1],st.ref[1]+length(unique(a$x))-2,1) ## line segment start coordinate
st.1 = seq(st.ref[2],st.ref[2]+length(unique(a$x))-2,1) ## line segment mid coordinate
st.2 = seq(st.ref[3],st.ref[3]+length(unique(a$x))-2,1) ## line segment end coordinate
st.y = round(range(a.HR$value[is.finite(a.HR$value)])) ## set y scale
png(paste0(ot,"yield.png"), width = 2000, height = 1000)
suppressWarnings(print( ## prevent huge load of known NA-related warnings and default method switch calls
        ggplot()+theme_bw()+xlab("carbon harvest rate (1/day)") + ylab("log yield flux") +
                scale_y_continuous(breaks = seq(st.y[1],st.y[2],2))+
                geom_boxplot(aes(x=as.factor(a.HR$x), y=a.HR$value, fill=as.factor(a.HR$eqm)))+
                scale_fill_manual(name="system", values = cBpT[c(1,4,2)], label=c("[P, with B, no harvest]", "[P, no B, with harvest]", "[P, with B, with harvest]"))+
                geom_segment(aes(x=st.1,xend=st.2,y=max(st.y)+1,yend=max(st.y)+1))+
                geom_text(aes(x=round(st.1), y=max(st.y)+2, label=paste0("W = ",wIl$yield_W[-1],"\np ",wIl$sig[-1],"\nn = ",wIl$n[-1])), size=5)+
                geom_segment(aes(x=st.0,xend=st.2,y=min(st.y)-1,yend=min(st.y)-1), col="red")+
                geom_text(aes(x=round(st.0), y=min(st.y)-2, label=paste0("W = ",a.PB$yieldDiff_W,"\np ",a.PB$yieldDiff_p,"\nn = ",a.PB$n)), size=5, col="red")+
                theme(axis.title = element_text(size = 20),
                      #axis.title.y = element_text(hjust = .25),
                      axis.text = element_text(size = 20),
                      legend.text = element_text(size = 20),
                      legend.title = element_text(size = 20),
                      legend.position = "bottom")
))
invisible(dev.off())
cat("Yield distribution comparison boxplot finished\n")

png(paste0(ot,"totC.png"), width = 2000, height = 1000)
suppressWarnings(print( ## prevent huge load of known NA-related warnings and default method switch calls
        ggplot()+theme_bw()+xlab("carbon harvest rate (1/day)") + ylab("log total carbon") +
                scale_y_continuous(breaks = seq(st.y[1],st.y[2],2))+
                geom_boxplot(aes(x=as.factor(a.TC$x), y=a.TC$value, fill=as.factor(a.TC$eqm)))+
                scale_fill_manual(name="system", values = cBpT[c(1,4,2)], label=c("[P, with B, no harvest]", "[P, no B, with harvest]", "[P, with B, with harvest]"))+
                geom_segment(aes(x=st.1,xend=st.2,y=max(st.y)+1,yend=max(st.y)+1))+
                geom_text(aes(x=round(st.1), y=max(st.y)+2, label=paste0("W = ",a.sys$total_W,"\np ",a.sys$sig,"\nn = ",a.sys$n)), size=5)+
                geom_segment(aes(x=st.0,xend=st.2,y=min(st.y)-1,yend=min(st.y)-1), col="red")+
                geom_text(aes(x=round(st.0), y=min(st.y)-2, label=paste0("W = ",a.PB$totalCDiff_W,"\np ",a.PB$totalCDiff_p,"\nn = ",a.PB$n)), size=5, col="red")+
                theme(axis.title = element_text(size = 20),
                      axis.text = element_text(size = 20),
                      legend.text = element_text(size = 20),
                      legend.title = element_text(size = 20),
                      legend.position = "bottom")
))
invisible(dev.off())
cat("Carbon distribution comparison boxplot finished\n")

rm(list = ls(pattern = "st."));rm(a.HR,wIl,a.PB)

##### distribution across biological parameters #####
## line plots with 95% confidence interval
xX=2;{a.Ln = a.pt[which(a.pt$x==xX),]
st.y = quantile(a.Ln$value[is.finite(a.Ln$value)], probs = c(.05,.95)); st.y = c(floor(st.y)[1],ceiling(st.y)[2])
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
cat("Biological parameters effect on yield combined plot finished\n")
