![alt text](http://www.imperial.ac.uk/ImageCropToolT4/imageTool/uploaded-images/Blue-on-white--tojpeg_1495792235526_x1.jpg)

# The potential of phytoplankton-bacteria systems to maximise carbon capture

Scripts for the partial fulfilment of the requirements for the degree of Master of Research at Imperial College London.  
Submitted for the MRes in Computational Methods in Ecology and Evolution.

## License

Apache-2.0

##  Getting started

comp-lang | packages | version
--- | --- | ---
bash | | 3.2.57(1)-release
C | gcc | 7.5.0
. | stdio.h | .
. | stdlib.h | .
python | | 3.7.3
. | SciPy | 1.2.3
. | SymPy | 1.5.1
. | numpy | 1.19.0
. | pandas | 1.0.5
R | | 4.0.2

## Guides

1. `code/`: scripts and the new quantitative model
0. `data/`: raw data
0. `result/`: important graphs
0. This project is **reproducible**: run `bash project.sh` in `code/`

## Coding scripts summary


### continuousHarvest.sh

#### Features

continuous harvest scenarios model run (analytical calculation)

#### Suggested input

```bash continuousHarvest.sh [min x] [max x] [samples]```

#### Expected Output

`data/continuous.csv`

*****

### destructiveHarvest.py

#### Features

destructive harvest scenarios model run (numerical integration)

#### Suggested input

`python3 destructiveHarvest.py [simulated days]`

#### Expected Output

`data/destructive.csv`

*****

### func.R

#### Features

self-defined functions

#### Suggested input

`source("../code/func.R")` in R scripts

#### Expected Output

none

*****

### func.py

#### Features

project model

#### Suggested input

`import func` in a python3 script inside `code/` directory

#### Expected Output

none

*****

### graphVariables.R

#### Features

self-defined objects for plots

#### Suggested input

`source("../code/graphVariables.R")` in R scripts

#### Expected Output

none

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

`data/gRate.csv`, `result/stdCst.pdf`

*****

### scenario.R

#### Features

fix sample scenario using real-life parameter ranges

#### Suggested input

`Rscript scenario.R`

#### Expected Output

`data/scenario.csv`

*****

### stablePositions.c

#### Features

calculate two alternative stabilities from a parameter scenario

#### Suggested input

`gcc stablePositions.c -o p_sP;./p_sP [x] [ePR] [eP] [gP] [aP] [eBR] [eB] [gB] [mB]`

#### Expected Output

verbose csv entry

*****

### writeREADME.sh

#### Features

readme.md generator

#### Suggested input

```bash writeREADME.sh```

#### Expected Output

`readme.md`

*****

### yieldPlot.R

#### Features

the combined plot for yield flux by each parameter

#### Suggested input

`Rscript yieldPlot.R`

#### Expected Output

`result/yieldFlux.pdf`

*****

### yieldWrangling.R

#### Features

collect and wrangle all scenario simulation data

#### Suggested input

`source("../code/yieldWrangling.R")` in R scripts

#### Expected Output

none

*****
