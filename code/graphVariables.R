#!/usr/bin/env Rscript

# Author 	: PokMan HO
# Script 	: graphVariables.R
# Desc 		: self-defined objects for plots
# Input 	: `source("../code/graphVariables.R")` in R scripts
# Output 	: none
# Arg 		: 0
# Date 		: Jul 2020

cBp = data.frame(PBN=c("#000000","#0000001A"), PoN=c("#D55E00","#D55E004D"), PBH=c("#E69F00","#E69F004D"), PoH=c("#009E73","#009E734D"))

fontSize = function(graphWidth=17){
  ## 17cm: a4paper 21cm - margin 2cm *2
  ## https://medium.com/@zkareemz/golden-ratio-62b3b6d4282a
  a = 14/433*graphWidth
  return(a)
}
