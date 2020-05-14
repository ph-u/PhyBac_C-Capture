source("../code/func.R")
dIs = read.csv("../result/discrepancy_1e-12.csv", header = T)
dIs0 = read.csv("../result/discrepancy_1e-5.csv", header = T)
rAw = read.csv("../result/maxYield_all.csv", header = T)
tHd = .05 ## discrepancy threshold
eXt = dIs[which(dIs0[,12]+rAw[,12]<1e-5 & dIs[,12]>3),]

# eXt = dIs[which(dIs[,10:13]>tHd),]
# print(paste("total scan on",nrow(eXt),"situations"))
# 
# for(i in 1:nrow(eXt)){
#   pA = ebcData(iniPop=1e-5, parameter = as.numeric(eXt[i,1:9]))
#   if(i%%5e3==0){cat(paste0(round(i/nrow(eXt)*100),"% finished, i=",i,"; "))}
#   if(pA[nrow(pA),4]<.001 & pA[nrow(pA),4]>0 & pA[nrow(pA),1]<1e3){break}
# };cat("\n")
# if(i==nrow(eXt)){cat("no exceptions\n")}else{print(eXt[i,])}
