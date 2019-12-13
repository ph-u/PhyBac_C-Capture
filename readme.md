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

1. Scripts in this project were stored in `code` subdirectory.  Header of each scripts were containing its own details.  A summary of these details were ordered alphabetically in Section "Scripts".  
2. Data and intermediate files used in this project were stored in `data` subdirectory.  
3. Graphs and reports in this project were stored in `results` subdirectory.  
4. References for this project were stored in `reference` subdirectory.  Brief descriptions for each paper was written in `refDesc.txt`; bibliography files for the proposal and thesis are  `proposal.bib` and `thesis.bib` respectively.

## Features

This readme.md and the project was automated with minimal non-structural manual modifications.

## Scripts


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

### m_equations.py

#### Features

equations bin for the ODE model

#### Suggested input

```python3 m_equations.py```

#### Expected Output

none

*****
