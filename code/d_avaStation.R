#!/bin/env R

# Author 		: PokMan Ho (pok.ho19@imperial.ac.uk)
# Script 		: d_avaStation.R
# Desc 			: extract station geo-data within solar time series and city data coverage - R version
# Input 		: ```Rscript d_avaStation.R```
# Output 		: none
# Arguments 	: 0
# Date 			: Jan 2020

cat("trim solar station data\n")

## set geo-buffer in-out determination function
geoBuffer<-function(area.km2, centreX, centreY, testX, testY, city){
  r=sqrt(area.km2 * (1e3)^2 / pi) # assume flat area
  d=sqrt((testX - centreX)^2 + 2*(testY - centreY)^2) * 6371e3/180 # coordinate distance
  ## Y-dist *2: scale y-axis up from -90~+90 to -180~+180, same with x-axis
  ## EarthR/180: ratio between Earth mean radius to coordinate limit (assume Earth = sphere, coordinate = circle)
  return(ifelse(d < r, city, NA))
}

## 	read raw data
a.0<-read.table("../data/solar0.txt", header=F, stringsAsFactors=F)[,1]

a.1<-read.table("../data/solar1.txt", header=F, stringsAsFactors=F, sep=",")
colnames(a.1)=c("src_id", "lon", "lat", "alt.m")
a.1$alt.m<-ifelse(a.1$alt.m=="None",NA,a.1$alt.m)
a.1[,4]<-as.numeric(a.1[,4])

a.2<-read.csv("../data/cities_GPCI.csv", header=T, stringsAsFactors=F)[,-5]

## trim station geo-data using irradiation availability
a.1<-a.1[which(a.1[,1] %in% a.0),]

## set up necessary global pixels with information
a.1$clus<-paste0("lat",round(a.1$lat),"lon",round(a.1$lon))
a.2$clus<-paste0("lat",round(a.2$latitude),"lon",round(a.2$longitude))
for(i in 1:nrow(a.2)){
  if(a.2$clus[i] %in% a.1$clus){a.1$clus[which(a.1$clus==a.2$clus[i])]<-a.2$City[i]}
};rm(i)

## 	export geo-data as useable station geo-data
write.csv(a.1,"../data/solar1.csv", quote=F, row.names=F)

## clean up directory
unlink("../data/solar0.txt")
unlink("../data/solar1.txt")
