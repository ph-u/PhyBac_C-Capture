![alt text](http://www.imperial.ac.uk/ImageCropToolT4/imageTool/uploaded-images/Blue-on-white--tojpeg_1495792235526_x1.jpg)

# Carbon harvest maximised by a theoretical phytoplankton and bacteria system (2019-20 ICL CMEE MRes)

This repository is the collection of scripts, programs and report(s) for the thesis project as a partial fulfillment of graduation requirement for the course.

## License

Apache-2.0

##  Getting started

comp-lang | packages | version
--- | --- | ---
bash | | 3.2.57(1)-release
python | | 3.7.3
. | SciPy | 1.2.3
. | SymPy | 1.5.1
R | | 3.6.0
. | ggplot2 | 3.3.2
. | gridExtra | 2.3
. | reshape2 | 1.4.4
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
0. `data/`: small data files
0. `result/`: important graphs
0. `report/`: main thesis TeX script and categorized report content
0. the project can be reproduced by running `bash project.sh` in the `code/` directory

## Coding scripts summary


### analysis.R

#### Features

modIRL.R result analyses

#### Suggested input

`Rscript analysis.R`

#### Expected Output

plots in `result/`

*****

### func.py

#### Features

project model

#### Suggested input

`import func` in a python3 script inside `code/` directory

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

### project.sh

#### Features

main script for project reproduction

#### Suggested input

`bash project.sh`

#### Expected Output

none; see respective scripts

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
