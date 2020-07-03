#!/bin/env python3

# Author 	: PokMan HO
# Script 	: func.py
# Desc 		: project model
# Input 	: `import func` in a python3 script inside `code/` directory
# Output 	: none
# Arg 		: 0
# Date 		: May 2020

"""
function bin for python3:
#import sys
#sys.path.insert(0, '../code/')
#import func.py
"""

__appname__="func.py"
__author__="PokMan Ho"
__version__="0.0.1"
__license__="none"

##### pkg #####
#import scipy as sc
#import scipy.integrate as itg
#import sympy as sp

##### project model #####
def ebc7(Den,t,x, ePR,eP,gP,aP, eBR,eB,gB,mB):
	"""The 7th version of the model in this project"""
	
	## variable sorting
	C = Den[:0]
	P = Den[:1]
	B = Den[:2]

	## rate calculation
	dC = g_P*e_PR*(1-e_P)*P +a_P*P**2 +g_B*(e_BR*(1-e_B)-1)*C*B +m_B*B -x*C
	dP = g_P*e_PR*e_P*P -a_P*P**2
	dB = g_B*e_BR*e_B*C*B -m_B*B

	return(sc.array([dC,dP,dB]))

