#!/bin/bash

## Author 		: PokMan Ho (pok.ho19@imperial.ac.uk)
## Script 		: d_cleanStation.sh
## Desc 		: extract station id and geolocations
## Input 		: ```bash d_cleanStation.sh```
## Output 		: `data/` directory - `solar0.txt`, `solar1.txt`
## Arguements 	: 0
## Date 		: Dec 2019

cd ../data

echo -e "extract solar station id from time series data"
cat solarRef.txt | sort | uniq | cut -f 1 -d "," > solar0.txt ## get all solar station id from time series

## 		extract geo-data from .kmz to csv
echo -e "extract geo-data info from stations around the globe"
### 	prep kml raw file for extraction
cp midas_stations_by_area.kmz midas_stations_by_area.zip
unzip midas_stations_by_area.zip
### 	grep data into separate intermediate files
grep src_id midas_stations_by_area.kml | cut -f 6 -d ">" > t1
grep coordinates midas_stations_by_area.kml | cut -f 2 -d ">" | cut -f 1 -d "<" > t2
### 	fuse intermediate data as useful data
paste t1 t2 -d "," > solar1.txt # col: id, lon, lat, alt

## 		clean
rm midas_stations_by_area.zip
rm midas_stations_by_area.kml
rm t1
rm t2
rm solarRef.txt

exit
