#!/bin/env R

# Author 		: PokMan Ho (pok.ho19@imperial.ac.uk)
# Script 		: d_filSolar.R
# Desc 			: export hourly solar data by location - R version
# Input 		: ```Rscript d_filSolar.R```
# Output 		: csv files, each location a file
# Arguments 	: 0
# Date 			: Jan 2020

cat("tearing solar data blob by location\n")

## raw data
solarGeoL<-read.csv("../data/solar1.csv", header = T, stringsAsFactors = F)
solarHour<-read.table("../data/solarT.csv", header = T, stringsAsFactors = F, sep = ",")

## get unique location
a.0<-gsub(";","_",unique(solarGeoL$clus))
a.0<-gsub(":","",a.0)

## match location with solar data
solarHour$location<-NA
for(i in 1:nrow(solarGeoL)){
  solarHour$location[which(solarHour$SRC_ID==solarGeoL$src_id[i])]<-solarGeoL$clus[i]
};rm(i)

## export data by location
for(i in 1:length(a.0)){
  write.csv(solarHour[which(solarHour$location==a.0[i]),-3], paste0("../data/solarGeoCleaned/solar_",a.0[i],".csv"), col.names = T, quote = F)
};rm(i)
