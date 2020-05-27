#!/bin/bash

# Author 	: PokMan Ho
# Script 	: jobSub_ctEqm.sh
# Desc 		: [hpc] submitting numerical integration job
# Input 	: qsub -v pb=${i} jobSub_ctEqm.sh
# Output 	: none
# Arg 		: 0
# Date 		: May 2020

## hpc-specific arg
#PBS -l walltime=72:00:00
#PBS -l select=1:ncpus=1:mem=4gb

##### cmd prefix rec #####
date
echo -e "job ${jb} start"

##### cmd #####
# $HOME/folder/cmd_run $1
# all paths in file `cmd_run` must be full path
# $HOME = /rds/general/user/ph419/home

## run R/py3
# module load anaconda3/personal
# R --vanilla < $HOME/xxx.R $1

## run julia
# $HOME/julia-1.3.1/bin/julia $HOME/folder/xxx.jl <> <>
$HOME/julia-1.3.1/bin/julia $HOME/pj/ctEqm.jl 1e-${jb}

##### cmd postfix rec #####
## rmb .e/.o files appear on directory of job submission
echo -e "job ${jb} done"
date
exit
