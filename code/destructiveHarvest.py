#!/usr/bin/env python3

# Author 	: PokMan HO
# Script 	: destructiveHarvest.py
# Desc 		: destructive harvest scenarios model run (numerical integration)
# Input 	: `python3 destructiveHarvest.py [simulated days]`
# Output 	: `data/destructive.csv`
# Arg 		: 1
# Date 		: Jul 2020

"""
destructive harvest scenarios model run (numerical integration)
"""

__appname__="destructiveHarvest.py"
__author__="PokMan Ho"
__version__="0.0.1"
__license__="none"

##### pkg #####
import scipy as sc
import scipy.integrate as itg
import numpy as np
import pandas as pd

import warnings
warnings.filterwarnings("ignore")

import sys
sys.path.insert(0, '../code/')
import func as fc

##### in #####
a = pd.read_csv("../data/scenario.csv")
eNd = int(sys.argv[1])

##### numerical run #####
t = np.linspace(0,eNd,int(eNd/100))
rEs = pd.DataFrame(columns=['x', 'ePR','eP','gP','aP', 'eBR','eB','gB','mB', 'c3','p3','b3', 'c4','p4','b4'])
for i in range(len(a)):
    den3, infodict = itg.odeint(fc.ebc7, [1,1,0],t, full_output=True, args=(0,a.iloc[i,0],a.iloc[i,1],a.iloc[i,2],a.iloc[i,3],a.iloc[i,4],a.iloc[i,5],a.iloc[i,6],a.iloc[i,7]))
    den4, infodict = itg.odeint(fc.ebc7, [1,1,1],t, full_output=True, args=(0,a.iloc[i,0],a.iloc[i,1],a.iloc[i,2],a.iloc[i,3],a.iloc[i,4],a.iloc[i,5],a.iloc[i,6],a.iloc[i,7]))
    p = pd.DataFrame({'t':[round(lk) for lk in t], ## list(t) and rounding to int
        'ePR':a.iloc[i,0],'eP':a.iloc[i,1],'gP':a.iloc[i,2],'aP':a.iloc[i,3], ## P bio parameters
        'eBR':a.iloc[i,4],'eB':a.iloc[i,5],'gB':a.iloc[i,6],'mB':a.iloc[i,7], ## B bio parameters
        'c3':den3[:,0],'p3':den3[:,1],'b3':den3[:,2], ## P-only system time-dependent densities
        'c4':den4[:,0],'p4':den4[:,1],'b4':den4[:,2]}) ## P+B system time-dependent densities
    rEs = rEs.append(p)
    if i%100==0: print('scenario',str(i),'out of',str(len(a)),':',str(round(i/len(a)*100)),'% done')

##### data export #####
rEs.to_csv("../data/destructive.csv", index=False)
