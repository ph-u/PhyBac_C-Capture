![alt text](http://www.imperial.ac.uk/ImageCropToolT4/imageTool/uploaded-images/Blue-on-white--tojpeg_1495792235526_x1.jpg)

# Carbon harvest maximised by a theoretical phytoplankton and bacteria system (2019-20 ICL CMEE MRes)

This repository is the collection of scripts, programs and report(s) for the thesis project as a partial fulfillment of graduation requirement for the course.

## License

Apache-2.0

##  Getting started

comp-lang | packages | version
--- | --- | ---
bash | | 3.2.57(1)-release
Julia-lang | | 1.3.1
. | PyCall | 1.91.4
. | DataFrames | 0.20.2
. | SymPy | 1.0.7
python | | 3.7.3
. | SciPy | 1.2.3
R | | 3.6.0
. | ggplot2 | 3.3.2
. | gridExtra | 2.3
TeX | | TeX Live 2019
. | LuaTeX | 1.10.0
. | BibTeX | 0.99d
. | geometry | 5.8
. | babel | 3.36
. | graphicx | 1.1a
. | hyperref | 7.00c
. | longtable | 4.12
. | amsmath | 2.17d
. | amssymb | 3.01
. | csquotes | 5.2h
. | float | 1.3d
. | csvsimple | 1.21
. | biblatex | 3.13a
. | subfiles | 1.5

## Guides

1. `code/`: scripts with description headers
2. `data/`: small data files
3. large data files are stored in Google [drive](https://drive.google.com/drive/folders/1tp2miPXis7bn-km1THC3ZaRHSRXQGCi5?usp=sharing)
4. `result/`: important graphs
5. `report/`: main thesis TeX script and categorized report content

## Coding scripts summary


### analysis.R

#### Features

modIRL.R result analyses

#### Suggested input

run this script in R console; graphs can't be run via automated loops

#### Expected Output

plots in `result/`

*****

### func.jl

#### Features

self-defined functions

#### Suggested input

`include("../code/func.jl")` in jl scripts

#### Expected Output

none

*****

### func.R

#### Features

self-defined functions

#### Suggested input

`source("../code/func.R")` in R scripts

#### Expected Output

none

*****

### modIRL.R

#### Features

analytical scan using real-life parameter ranges

#### Suggested input

`Rscript modIRL.R`

#### Expected Output

`result/anaIRL.csv`

*****

### rateDet.R

#### Features

BioTraits data wrangling

#### Suggested input

`Rscript rateDet.R`

#### Expected Output

`data/gRate.csv`, `result/stdCst.png`

*****

### writeREADME.sh

#### Features

readme.md generator

#### Suggested input

```bash writeREADME.sh```

#### Expected Output

`readme.md` file

*****
