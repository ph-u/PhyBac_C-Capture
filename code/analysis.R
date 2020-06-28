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
a$yield3C = log(a$eqm3C*ifelse(a$x==0,1,a$x))
a$yield4C = log(a$eqm4C*ifelse(a$x==0,1,a$x))
## carbon magnitude calculation
a$log3C = log(a$eqm3C);a$log3A = log(a$eqm3A)
a$log4C = log(a$eqm4C);a$log4A = log(a$eqm4A)
## exclude meaningless result for later filtering
a[a==Inf] = a[a==-Inf] = NA

##### plot of Wilcox test summary #####
wIl = as.data.frame(matrix(NA, nr=length(unique(a$x)), nc=3))
colnames(wIl) = c("x",paste0("yield",c("_W","_p")))
wIl[,1] = unique(a$x)[order(unique(a$x))]
for(i in 1:nrow(wIl)){ ## fill in Wilcox summary statistics and p-values
        w.y = try(wilcox.test(a$yield3C[which(a$x==wIl[i,1])], a$yield4C[which(a$x==wIl[i,1])]), silent = T)
        ## silence error while filling in summary statistics
        if(class(w.y)=="try-error"){wIl[i,2:3] = rep(NA,2)}else{wIl[i,2:3] = c(w.y$statistic, w.y$p.value)}
};rm(i,w.y)
wIl$sig = ifelse(wIl$yield_p>.1,"NS",ifelse(wIl$yield_p<.001,"<<0.01",ifelse(wIl$yield_p<.01,"<0.01",round(wIl$yield_p,3))))

## reformat table to adapt ggplot
{a.t = a[,c(1:9,22:23,25,27)] ## parameters (9 cols), log yields (2 col), log total carbon (2 col)
        a.HR = rbind(a.t,a.t)
        a.HR$yield4C[1:nrow(a.t)] = a.t$yield3C
        a.HR$log4A[1:nrow(a.t)] = a.t$log3A
        a.HR$eqm = rep(c(3,4), each=nrow(a.t))
        a.HR$yield3C = a.HR$log3A = NULL
        colnames(a.HR)[10:11] = c("yield","totalC")
        rm(a.t)
}
## yield comparisons
st.0 = seq(1.7,10.7,1);st.1 = seq(2.3,11.3,1)
png(paste0(ot,"Wilcox.png"), width = 1000)
ggplot()+theme_bw()+
        geom_boxplot(aes(x=as.factor(a.HR$x), y=a.HR$yield, fill=as.factor(a.HR$eqm)))+
        xlab("carbon removal rate (1/day)") + ylab("log yield flux") +
        scale_fill_manual(name="system", labels=c("P-only", "P+B"), values = cBpT[c(4,2)])+
        geom_segment(aes(x=st.0,xend=st.1,y=7,yend=7))+
        geom_text(aes(x=round(st.0), y=7.5, label=wIl$sig[which(!is.na(wIl$sig))]), size=5)+
        theme(axis.title = element_text(size = 20),
              axis.text = element_text(size = 20),
              legend.text = element_text(size = 20),
              legend.title = element_text(size = 20))
dev.off()
rm(st.0,st.1)

##### comparison of P+B systems removal rate: 0 vs 0.1 #####
a.01 = a[which(a$x==0 | a$x==1),]
wilcox.test(a.01$yield4C[which(a.01$x==0)], a.01$yield4C[which(a.01$x==1)])

##### distribution across biological parameters #####
## restructure dataframe
{a.bx = rbind(a,a)
a.bx$log4C[1:nrow(a)]=a$log3C
a.bx$log4A[1:nrow(a)]=a$log3A
a.bx$yield4C[1:nrow(a)]=a$yield3C
a.bx$yield3C = a.bx$log3C = a.bx$log3A = NULL
a.bx$eqm = c(rep("P_only",nrow(a)),rep("P+B",nrow(a)))
colnames(a.bx)[22:24] = c("yield","logC","logA")
a.pt = rbind(a.bx,a.bx)
# a.pt = rbind(a.bx,a.bx,a.bx)
a.pt$logA[1:nrow(a.bx)] = a.bx$yield
# a.pt$logA[1:nrow(a.bx)+nrow(a.bx)] = a.bx$logC
a.pt$Source = rep(c(colnames(a.bx)[22],colnames(a.bx)[24]), each=nrow(a.bx))
# a.pt$Source = c(rep(colnames(a.bx)[22],nrow(a.bx)),rep(colnames(a.bx)[23],nrow(a.bx)),rep(colnames(a.bx)[24],nrow(a.bx)))
colnames(a.pt)[24] = "value"
# a.pt$yield = a.pt$logC = NULL
}

## line plots with 95% confidence interval
xX=1;{a.Ln = a.pt[which(a.pt$x==xX),]
p_tmp = ggplot()+theme_bw()+ylim(c(-9,5)) + ylab(paste0("natural log eqm values, harvest = ",xX," day^-1")) + scale_linetype_manual(name="type", labels=c("total carbon", "yield flux"), values = 1:2)
if(xX>0){
        p_tmp = p_tmp + scale_fill_manual(name="system", values = cBpT[c(4,2)])+scale_colour_manual(name="system", values = cBp[c(4,2)])
}else{
        p_tmp = p_tmp + scale_fill_manual(name="system", values = cBpT[2])+scale_colour_manual(name="system", values = cBp[2])
}

p_2 = p_tmp + xlab(colnames(a.Ln)[2]) + geom_smooth(aes(x=a.Ln[,2], y=a.Ln$value, fill=a.Ln$eqm, col=a.Ln$eqm, linetype=a.Ln$Source))
p_3 = p_tmp + xlab(colnames(a.Ln)[3]) + geom_smooth(aes(x=a.Ln[,3], y=a.Ln$value, fill=a.Ln$eqm, col=a.Ln$eqm, linetype=a.Ln$Source))
p_4 = p_tmp + xlab(colnames(a.Ln)[4]) + geom_smooth(aes(x=a.Ln[,4], y=a.Ln$value, fill=a.Ln$eqm, col=a.Ln$eqm, linetype=a.Ln$Source))
p_5 = p_tmp + xlab(colnames(a.Ln)[5]) + geom_smooth(aes(x=a.Ln[,5], y=a.Ln$value, fill=a.Ln$eqm, col=a.Ln$eqm, linetype=a.Ln$Source))
p_6 = p_tmp + xlab(colnames(a.Ln)[6]) + geom_smooth(aes(x=a.Ln[,6], y=a.Ln$value, fill=a.Ln$eqm, col=a.Ln$eqm, linetype=a.Ln$Source))
p_7 = p_tmp + xlab(colnames(a.Ln)[7]) + geom_smooth(aes(x=a.Ln[,7], y=a.Ln$value, fill=a.Ln$eqm, col=a.Ln$eqm, linetype=a.Ln$Source))
p_8 = p_tmp + xlab(colnames(a.Ln)[8]) + geom_smooth(aes(x=a.Ln[,8], y=a.Ln$value, fill=a.Ln$eqm, col=a.Ln$eqm, linetype=a.Ln$Source))
p_9 = p_tmp + xlab(colnames(a.Ln)[9]) + geom_smooth(aes(x=a.Ln[,9], y=a.Ln$value, fill=a.Ln$eqm, col=a.Ln$eqm, linetype=a.Ln$Source))

};{
        png(paste0(ot,"var_",ifelse(xX<1,"0",""),xX*10,".png"), res = 100, width = 2000, height = 700)
        grid.arrange(p_2, p_3, p_4, p_5, p_6, p_7, p_8, p_9, nrow=2)
        dev.off()
};rm(list=ls(pattern = "p_"));rm(xX, a.Ln)
