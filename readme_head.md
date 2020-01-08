![alt text](https://unichoices.co.uk/wp-content/uploads/2015/09/Imperial-College-London.jpg)

# 2019-20 MRes CMEE Dissertation Project -- PokMan Ho

This repository is the collection of scripts, programs and report(s) for the thesis project as a partial fulfillment of graduation requirement for the course.

## License

Apache-2.0

##  Getting started

bash version: 3.2.57(1)-release  
python3 version: 3.7.3  
r version: 3.6.0  
LaTeX version: TeX Live 2019
BibTex version: 0.99d (TeX Live 2019)
Other languages: awk

## Packages used
LaTeX: geometry, inputenc, babel, graphicx, hyperref, longtable, amsmath, amssymb, subfiles
R: NONE
Python3: subprocess, scipy

## Guides

1. Scripts were in `code` subdirectory with description headers, which summarized in Section "Scripts" in readme
2. Intermediate files were in `data` subdirectory
3. Request for hourly insolation [data](http://data.ceda.ac.uk/badc/ukmo-midas/data/RO) from [CEDA Archive](https://catalogue.ceda.ac.uk/uuid/220a65615218d5c9cc9e4785a3234bd0)
4. Download global solar station [geo-location](http://archive.ceda.ac.uk/midas_stations/google_earth/) open data from CEDA Archive
5. Graphs were in `results` subdirectory
6. Final report was `results` subdirectory
7. References were in `reference` subdirectory
   1. `refDesc.txt`: brief descriptions for each paper
   2. `proposal.bib`: proposal bibliography
   3. `thesis.bib`: thesis bibliography

## Features

This readme.md and the project was automated with minimal non-structural manual modifications for reproducibility and flexibility.

## Reproduce project

1. Request and download 
2. Run the code `python3 hk_master.py` in the `code/` subdirectory

## Scripts
