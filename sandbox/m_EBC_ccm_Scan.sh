#!/bin/bash

# author: 	PokMan Ho
# script: 	m_EBC_ccm_Scan.sh
# desc: 	run m_EBC_ccm_paraScan.jl
# input: 	```bash m_EBC_ccm_Scan.sh```
# output: 	log file with timestamp of running the Julia-lang script
# arg: 		0
# date: 	Mar 2020

date
julia m_EBC_ccm_paraScan.jl
date
