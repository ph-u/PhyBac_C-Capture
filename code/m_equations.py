#!/bin/env python3

# Author 		: PokMan Ho (pok.ho19@imperial.ac.uk)
# Script 		: m_equations.py
# Desc 			: adapted competition Lotka-Volterra equations
# Input 		: ```python3 m_equations.py```
# Output 		: none
# Arguments 	: 0
# Date 			: Jan 2020

"""adapted competition Lotka-Volterra equations"""

__appname__ 	="m_equations.py"
__author__ 		="PokMan Ho"
__version__ 	="0.0.1"
__license__ 	="None"

import scipy as sc

def ebc(pops, t=0):
	"""competitive LV model:
			variable preset - rp, rq, Jp, Jq, Kp, Kq
			equation input - pops, t"""
	p=pops[0]
	q=pops[1]

	hpq=Jq/(Jp+Jq)
	hqp=1-hpq

	dpdt=rp*p*(1-(p+hpq*q)/Kp)
	dqdt=rq*q*(1-(q+hqp*p)/Kq)

	return(sc.array([dpdt,dqdt]))
