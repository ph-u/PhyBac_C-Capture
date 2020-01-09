#!/bin/env R

# Author 		: PokMan Ho (pok.ho19@imperial.ac.uk)
# Script 		: m_equations.R
# Desc 			: equations bin for the ODE model -- R version
# Input 		: ```Rscript m_equations.R```
# Output 		: none
# Arguments 	: 0
# Date 			: Dec 2019

## Main term key:
## PC   : photocurrent-confirmed autotrophs -- Anabaena sp & Synechocystis sp
## Cs   : Chroococcidiopsis sp
## bm   : button mushrooms

ebc<-function( 									## eco-bioelectric cell model
				pop 		=c(500,500,30), 	## population array (PC, Cs, bm)
				time 		=0, 				## time-step series, start with 0
				gAexpt 		=1., 				## growth rate of PC in reference experiment
				gBexpt 		=1., 				## growth rate of Cs in reference experiment
				JAexpt 		=1., 				## energy per unit time gained by PC in reference experiment
				JBexpt 		=1., 				## energy per unit time gained by Cs in reference experiment
				growthM 	=.01, 				## growth rate of bm
				deathA 		=.3, 				## death rate of PC
				deathB 		=.3, 				## death rate of Cs
				deathM 		=.001, 				## death rate of bm
				energyA 	=.05, 				## energy extraction ability of PC
				energyB 	=.05, 				## energy extraction ability of Cs
				batch 		=.05				## population removal upon death of host bm
				){
		PA=pop[1] 												## PC population
		PB=pop[2] 												## Cs population
		PM=pop[3] 												## bm population

		growthA 	= gAexpt/JAexpt*energyA 					## PC growth rate
		growthB 	= gBexpt/JBexpt*energyB 					## Cs growth rate

		energy 		= energyB/(energyA+energyB) 				## energy factor division between PC & Cs
		hinderBA 	= energy*growthA 							## competition hinder rate of Cs on PC
		hinderAB 	= (1-energy)*growthB 						## competition hinder rate of PC on Cs

		dPAdt = growthA*PA -deathA*PA -hinderBA*PA*PB -batch    ## rate of PC population fluctuation
        dPBdt = growthB*PB -deathB*PB -hinderAB*PA*PB -batch    ## rate of Cs population fluctuation
        dPMdt = growthM*PM -deathM*PM                           ## rate of bm population fluctuation

		return(c(dPAdt, dPBdt, dPMdt)) 							## return population rate array for next time step
}
