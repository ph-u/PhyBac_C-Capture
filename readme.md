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

## Scripts


### d_avaStation.R

#### Features

extract station geo-data within solar time series data coverage

#### Suggested input

```Rscript d_avaStation.R```

#### Expected Output

none

*****

### d_cleanStation.sh

#### Features

extract station id and geolocations

#### Suggested input

```bash d_cleanStation.sh```

#### Expected Output

`data/` directory - `solar0.txt`, `solar1.txt`

*****

### d_extStation.sh

#### Features

extract all station info from yearly data files

#### Suggested input

```bash d_extStation.sh```

#### Expected Output

`data/` directory - `solarRef.txt`

*****

### d_trimSolar.sh

#### Features

combine global 1947-2019 solar data into single file

#### Suggested input

```bash d_trimSolar.sh```

#### Expected Output

`data/` subdirectory - `solarT.csv`

*****

### hk_gen_readme.sh

#### Features

readme.md generator

#### Suggested input

```bash hk_gen_readme.sh```

#### Expected Output

`readme.md` file

*****

### hk_luaLTX.sh

#### Features

use lualatex as .tex file compiler

#### Suggested input

```nohup bash hk_luaLTX.sh <tex with .tex> <optional/output/path/>```

#### Expected Output

pdf file in designated directory

*****

### hk_master.py

#### Features

Project workflow

#### Suggested input

```python3 hk_master.py```

#### Expected Output

none - see child scripts

*****

### m_equations.py

#### Features

equations bin for the ODE model -- python version

#### Suggested input

```python3 m_equations.py```

#### Expected Output

none

*****

### m_equations.R

#### Features

equations bin for the ODE model -- R version

#### Suggested input

```Rscript m_equations.R```

#### Expected Output

none

*****
