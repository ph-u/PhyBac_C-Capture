#!/bin/env julia

# Author:   PokMan Ho
# Script:   ctEqm.jl
# Desc:   	count eqm position from numerical estimations
# Input: 	julia ctEqm.jl <iniPop>
# Output: 	result csv
# Arg: 		1
# Date: 	Apr 2020

##### pkg #####
iNi = parse(Float16, ARGS[1])
include("../code/func.jl")


