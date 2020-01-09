#!/bin/env R

# Author 		: PokMan Ho (pok.ho19@imperial.ac.uk)
# Script 		: d_avaStation.R
# Desc 			: extract station geo-data within solar time series data coverage
# Input 		: ```Rscript d_avaStation.R```
# Output 		: none
# Arguments 	: 0
# Date 			: Jan 2020

cat("trim solar station data\n")

## 	read raw data
a.0<-read.table("../data/solar0.txt", header=F, stringsAsFactors=F)[,1]
a.1<-read.table("../data/solar1.txt", header=F, stringsAsFactors=F, sep=",")
colnames(a.1)=c("src_id", "lon", "lat", "alt.m")

## trim station geo-data
a.1<-a.1[which(a.1[,1] %in% a.0),]
a.1[,4]<-as.numeric(a.1[,4]) # unknown reason not initially treated as int

## 	export geo-data as useable station geo-data
write.csv(a.1,"../data/solar1.csv", quote=F, row.names=F)

## clean up directory
unlink("../data/solar0.txt")
unlink("../data/solar1.txt")
