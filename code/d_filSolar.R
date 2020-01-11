#!/bin/env R

# Author 		: PokMan Ho (pok.ho19@imperial.ac.uk)
# Script 		: d_filSolar.R
# Desc 			: combine irradiation data with location - R version
# Input 		: ```Rscript d_filSolar.R```
# Output 		: solarG.csv
# Arguments 	: 0
# Date 			: Jan 2020

cat("combine solar data blob with geo-location\n")

## raw data
solarGeoL<-read.csv("../data/solar1.csv", header = T, stringsAsFactors = F)
solarHour<-read.table("../data/solarT.csv", header = T, stringsAsFactors = F, sep = ",")

## get unique location
a.1<-unique(solarGeoL$clus)

## match location with solar data
solarHour$location<-NA
for(i in 1:nrow(solarGeoL)){
  solarHour$location[which(solarHour$SRC_ID==solarGeoL$src_id[i])]<-solarGeoL$clus[i]
};rm(i)

## export data single
write.table(a.1, "../data/solarG.txt", row.names = F, col.names = F, quote = F)
write.csv(solarHour[,-3], "../data/solarG.csv", row.names = F, quote = F)
## export data by location (too slow)
#for(i in 1:length(a.1)){
#  write.csv(solarHour[which(solarHour$location==a.1[i]),-c(3,5)], paste0("../data/solarGeoCleaned/solar_",a.0[i],".csv"), row.names = F, quote = F)
#};rm(i)
