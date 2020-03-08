#!/bin/bash

# Author: PokMan Ho pok.ho19@imperial.ac.uk
# Script: m_EBC_ccm_hpc.sh
# Desc: call run model parameter scan
# Input: qsub -J 1-100 ../m_EBC_ccm_hpc.sh
# Output: none
# Arguments: 0
# Date: Mar 2020

## test modeling script by given command
#PBS -l walltime=72:00:00
#PBS -l select=1:ncpus=1:mem=3gb
module load anaconda3/personal
date
$HOME/julia-1.3.1/bin/julia $HOME/paraScan/m_EBC_ccm_hpcParaScan.jl $1
echo "job $1 done"
date

exit
