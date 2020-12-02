#!/usr/bin/env python3

# Author 	: ph-u
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
#import func
"""

__appname__="func.py"
__author__="ph-u"
__version__="0.0.1"
__license__="none"

##### pkg #####
import scipy as sc
#import scipy.integrate as itg
#import sympy as sp

##### project model #####
def ebc7(Den,t,x, ePR,eP,gP,aP, eBR,eB,gB,mB):
	"""The 7th version of the model in this project"""
	
	## variable sorting
	C = Den[0]
	P = Den[1]
	B = Den[2]

	## rate calculation
	dC = gP*ePR*(1-eP)*P +aP*P**2 +gB*(eBR*(1-eB)-1)*C*B +mB*B -x*C
	dP = gP*ePR*eP*P -aP*P**2
	dB = gB*eBR*eB*C*B -mB*B

	return(sc.array([dC,dP,dB]))

