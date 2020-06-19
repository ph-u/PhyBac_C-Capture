![alt text](https://unichoices.co.uk/wp-content/uploads/2015/09/Imperial-College-London.jpg)

# 2019-20 MRes CMEE Dissertation Project -- PokMan Ho

This repository is the collection of scripts, programs and report(s) for the thesis project as a partial fulfillment of graduation requirement for the course.

## License

Apache-2.0

##  Getting started

bash version: 3.2.57(1)-release  
Julia version: v.1.3.1  
python3 version: 3.7.3  
r version: 3.6.0  
LaTeX version: TeX Live 2019  
BibTex version: 0.99d (TeX Live 2019)  
Other languages: awk

## Packages used

Julia: RCall, PyCall, Plots, ProgressMeter, DataFrames, SymPy  
python3: scipy, scipy.constants, scipy.integrate, math, sympy, mpmath  
R: NONE  
LaTeX: geometry, inputenc, babel, graphicx, hyperref, longtable, amsmath, amssymb, subfiles  

## Guides

1. Scripts were in `code` subdirectory with description headers, which summarized in Section "Scripts" in readme
2. Intermediate files were in `data` subdirectory
3. Request for hourly insolation [data](http://data.ceda.ac.uk/badc/ukmo-midas/data/RO) from [CEDA Archive](https://catalogue.ceda.ac.uk/uuid/220a65615218d5c9cc9e4785a3234bd0)
4. Download global solar station [geo-location](http://archive.ceda.ac.uk/midas_stations/google_earth/) open data from CEDA Archive
5. Download solar power reference curve from US Department of Energy [website](https://www.nrel.gov/grid/solar-resource/spectra-am1.5.html)
6. Optional download cities geo-location [data](https://drive.google.com/drive/folders/1tp2miPXis7bn-km1THC3ZaRHSRXQGCi5)
7. Graphs were in `results` subdirectory
8. Final report was `results` subdirectory
9. References were in `reference` subdirectory
   1. `refDesc.txt`: brief descriptions for each paper
   2. `proposal.bib`: proposal bibliography
   3. `thesis.bib`: thesis bibliography

## Features

This readme.md and the project was automated with minimal non-structural manual modifications for reproducibility and flexibility.

## Reproduce project

1. Folder structure within working directory: `mkdir -p {code,data,result,reference}; mkdir -p data/yearly_files`
2. Request and download CEDA Archive data (.txt files) to `data/yearly_files` subdirectory
3. Download CEDA Archive data headers to `data/` subdirectory
4. Download CEDA Archive global solar station kmz file to `data/` subdirectory
5. Download solar power reference curve data zip file to `data/` subdirectory
6. Download [bibliography](https://github.com/ph-u/Project/blob/master/reference/thesis.bib) file to `reference/` subdirectory
7. (Optional) Download cities geo-location data csv to `data/` subdirectory
8. Run the code `python3 hk_master.py` in the `code/` subdirectory

## Scripts


### analysis.R

#### Features

modIRL.R result analyses

#### Suggested input

none

#### Expected Output

plots

*****

### func.R

#### Features

self-defined functions

#### Suggested input

none

#### Expected Output

none

*****

### func.jl

#### Features

self-defined functions

#### Suggested input

none

#### Expected Output

none

*****

### hk_gen_readme.sh

#### Features

readme.md generator

#### Suggested input

```bash hk_gen_readme.sh```

#### Expected Output

`readme.md` file

*****

### j_pie.R

#### Features

[hpc] equilibrium position identification & representation

#### Suggested input

j_pie.R <power>

#### Expected Output

`res/` directory - j_d1e-${i}.csv, j_p1e-${i}.png

*****

### jobSub_ctEqm.sh

#### Features

[hpc] submitting numerical integration job

#### Suggested input

qsub -v pb=${i} jobSub_ctEqm.sh

#### Expected Output

none

*****

### maxYield.jl

#### Features

analytical solve for searching the max yield of carbon

#### Suggested input

julia maxYield.jl <sig. density threshold>

#### Expected Output

../result/maxYield.csv

*****

### modIRL.R

#### Features

analytical scan using real-life parameter ranges

#### Suggested input

none

#### Expected Output

`../result/anaIRL.csv`

*****

### nDiff.R

#### Features

scan for discrepancies between numerical and analytical model solution scan

#### Suggested input

Rscript nDiff.R <iniPop>

#### Expected Output

../result/discrepancy_${i}.csv

*****

### nDisc.R

#### Features

plot discrepancy.csv result, showing parameter-wise solution differences between analytical and numerical approaches

#### Suggested input

none

#### Expected Output

../sandbox/graph/

*****

### nSplt.R

#### Features

plot contourplots for parameter scan result

#### Suggested input

none

#### Expected Output

none

*****

### numScan0.sh

#### Features

master script for numerical scan of model

#### Suggested input

bash numScan0.sh

#### Expected Output

none

*****

### numScan1.jl

#### Features

numerical solve for searching breakpoint boundary for parameters combinations

#### Suggested input

julia numScan1.jl <id> <min_x> <ePR> <eP> <gP> <min_aP> <eBR> <eB> <gB> <mB>

#### Expected Output

../data/numScan_<id>.csv

*****

### numScan2.R

#### Features

generate runID and parameter values

#### Suggested input

Rscript numScan2.R <xMin> <xMax>  <ePRMin> <ePRMax> <ePMin> <ePMax>  <gPMin> <gPMax> <aPMin> <aPMax>  <eBRMin> <eBRMax> <eBMin> <eBMax>  <gBMin> <gBMax> <mBMin> <mBMax>

#### Expected Output

../data/nS_para.txt

*****

### rateDet.R

#### Features

BioTraits data handling

#### Suggested input

none

#### Expected Output

none

*****

### respEff.R

#### Features

getting ranges of respiration efficiencies from BioTrait data and published respiration linear equation in relation to growth rate

#### Suggested input

none

#### Expected Output

none

*****
