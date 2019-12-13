#!/bin/env python3

# Author 		: PokMan Ho (pok.ho19@imperial.ac.uk)
# Script 		: m_equations.py
# Desc 			: equations bin for the ODE model
# Input 		: ```python3 m_equations.py```
# Output 		: none
# Arguments 	: 0
# Date 			: Dec 2019

"""equations bin for the ODE model"""

__appname__ 	="m_equations.py"
__author__ 		="PokMan Ho"
__version__ 	="0.0.1"
__license__ 	="None"

import scipy as sc

## Main term key:
## PC 	: photocurrent-confirmed autotrophs -- Anabaena sp & Synechocystis sp
## Cs 	: Chroococcidiopsis sp
## bm 	: button mushrooms
def ebc( 												## eco-bioelectric cell model
				pop 		=sc.array([500,500,30]), 	## population array [PC, Cs, bm]
				time		=0, 						## time-step series, start with 0
				growthA 	=1., 						## growth rate of PC
				growthB 	=1., 						## growth rate of Cs
				growthM 	=.01, 						## growth rate of bm
				deathA 		=.3, 						## death rate of PC
				deathB 		=.3, 						## death rate of Cs
				deathM 		=.001, 						## death rate of bm
				energyA 	=.05, 						## energy extraction ability of PC
				energyB 	=.05, 						## energy extraction ability of Cs
				batch 		=.05 						## population removal upon death of host bm
				):
		"""eco-bioelectric cell: bio-population fluctuation main model"""
		PA=pop[0] 												## PC population
		PB=pop[1] 												## Cs population
		PM=pop[2] 												## bm population

		energy 		= energyB/(energyA+energyB) 				## energy factor division between PC & Cs
		hinderBA 	= energy*growthA 							## competition hinder rate of Cs on PC
		hinderAB 	= (1-energy)*growthB 						## competition hinder rate of PC on Cs

		dPAdt = growthA*PA -deathA*PA -hinderBA*PA*PB -batch 	## rate of PC population fluctuation
		dPBdt = growthB*PB -deathB*PB -hinderAB*PA*PB -batch 	## rate of Cs population fluctuation
		dPMdt = growthM*PM -deathM*PM 							## rate of bm population fluctuation

		return sc.array([dPAdt, dPBdt, dPMdt]) 					## return population rate array for next time step

