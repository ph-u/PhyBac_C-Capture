#!/bin/env python3

# Author: 	PokMan HO
# Script: 	func.py
# Desc: 	self-defined functions
# Input: 	none
# Output: 	none
# Arg: 		0
# Date: 	May 2020

"""function bin for python3"""

__appname__="func.py"
__author__="PokMan Ho"
__version__="0.0.1"
__license__="none"

##### pkg #####
#import scipy as sc
#from scipy import integrate as itg
#import sympy as sp
#import pandas as pd
#import matplotlib.pyplot as plt

##### project model #####
def ebc7(Den,t,x, ePR,eP,gP,aP, eBR,eB,gB,mB):
	"""The 7th version of the model in this project"""
	
	## variable sorting
	C = Den[:1]
	P = Den[:2]
	B = Den[:3]

	## rate calculation
	dC = g_P*e_PR*(1-e_P)*P +a_P*P**2 +g_B*(e_BR*(1-e_B)-1)*C*B +m_B*B -x*C
	dP = g_P*e_PR*e_P*P -a_P*P**2
	dB = g_B*e_BR*e_B*C*B -m_B*B

	return(sc.array([dC,dP,dB]))

def ebcData():
	"""a function solving integral of the model"""
	return()

def ebcEqm():
	"""analytical model solution"""
	return()

def ebcAlt():
	"""analytical model all solutions"""
	return()

def ebcRate():
	"""ebc rate"""
	return()

