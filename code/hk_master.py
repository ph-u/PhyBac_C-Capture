#!/bin/env python3

# Author 		: PokMan Ho (pok.ho19@imperial.ac.uk)
# Script 		: hk_master.py
# Desc 			: Project workflow
# Input 		: ```python3 hk_master.py```
# Output 		: none - see child scripts
# Arguments 	: 0
# Date 			: Jan 2020

"""Project workflow"""

__appname__ 	="hk_master.py"
__author__ 		="PokMan Ho"
__version__ 	="0.0.1"
__license__ 	="None"

import subprocess as s

s.Popen("date", shell=True).wait() # keep track of stepwise time
s.Popen("./d_rfcvSolar.sh 						2> nohup.out", shell=True).wait() # organize solar power reference curve data
s.Popen("date", shell=True).wait() # keep track of stepwise time
s.Popen("./d_extStation.sh 						2> nohup.out", shell=True).wait() # extract station id from hourly insolation data
s.Popen("date", shell=True).wait() # keep track of stepwise time
s.Popen("./d_cleanStation.sh 					2> nohup.out", shell=True).wait() # extract station geo-info from kmz data
s.Popen("date", shell=True).wait() # keep track of stepwise time
s.Popen("Rscript d_avaStation.R 				2> nohup.out", shell=True).wait() # trim geo-info to solar data coverage
s.Popen("date", shell=True).wait() # keep track of stepwise time
s.Popen("mkdir -p ../data/solarGeoCleaned 		2> nohup.out", shell=True).wait() # make subdirectory in case, for storing time series data by location
s.Popen("./d_trimSolar.sh 3 					2> nohup.out", shell=True).wait() # combine solar hourly time series into single data
s.Popen("date", shell=True).wait() # keep track of stepwise time

#s.Popen("./hk_luaLTX.sh thesis.tex ../result 	2> nohup.out", shell=True).wait() # write report
s.Popen("date", shell=True).wait() # keep track of stepwise time

## completing Proj workflow
s.Popen("rm nohup* 											", shell=True).wait() # clean up
s.Popen("./hk_gen_readme.sh 								", shell=True).wait() # gen readme
s.Popen("date", shell=True).wait() # keep track of time
