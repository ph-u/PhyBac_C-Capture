#!/bin/env python3

# author: ph-u
# script: paper_datAttribute.py
# desc: analysis of data source and attributes
# in: python3 datAttribute.py
# out: none
# arg: 0
# date: 20201124

import sys, os, re
import pandas as pd
import matplotlib.pyplot as mp
import numpy as np

rAw = pd.read_csv("../p_paperGraphics/mData.csv", keep_default_na=False)

##### set data structure #####
rAw['perDay'] = np.nan
for i in range(len(rAw)):
    uNit = rAw['StandardisedTraitUnit'][i]
    pAra = rAw['parameter'][i]
    if uNit == 's^-1':
        uNit = 60**2*24
    else:
        uNit = 1
    if pAra == 'gB10':
        uNit = uNit/10
    rAw['perDay'][i] = (rAw['StandardisedTraitValue'][i]*uNit).copy()

wHole = rAw.copy()
wHole.columns
wHole[['ConPhylum','ConClass','ConOrder','ConFamily','ConGenus']] = 'all'
tOtal = rAw.append(wHole, ignore_index=True)

##### plot by taxonomic group #####
pAr = tOtal['parameter'].unique()
cOl = tOtal.columns[2:7]
dTl = [[cOl[0],(5,10)],[cOl[1],(7,13)],[cOl[2],(7,14)],[cOl[3],(14,26)],[cOl[4],(14,14)]]

for i in range(len(pAr)):
    for j in range(len(dTl)):
        iDx = [i,j]
        pltDF = tOtal[tOtal['parameter']==pAr[iDx[0]]]
        p = pltDF[[dTl[iDx[1]][0],'perDay']].boxplot(by=dTl[iDx[1]][0], figsize=dTl[iDx[1]][1], grid=False, rot=90)
        mp.savefig("../p_paperGraphics/"+pAr[iDx[0]]+"_"+dTl[iDx[1]][0]+".pdf", dpi=99)

##### data source distribution on parameters #####
gRp = rAw.copy()
gRp['CitationCode'] = pd.Categorical(gRp.Citation).codes
gRp.groupby(['CitationCode','Citation']).size().to_csv("../p_paperGraphics/citationREF.csv", header=True, index=False) ## citation index reference count table

for i in gRp.columns[2:7]:
    gRp.groupby(['CitationCode','parameter',i]).size().to_csv("../p_paperGraphics/countTable_"+i+".csv", header=True, index=False) ## use csv as record
    cTable = pd.read_csv("../p_paperGraphics/countTable_"+i+".csv", keep_default_na=False)
    uPara = cTable['parameter'].unique()
    uPylm = cTable[i].unique()
    for k in range(len(uPara)):
        for j in range(len(uPylm)):
            plotDF = cTable.loc[(cTable['parameter']==uPara[k]) & (cTable[i]==uPylm[j])]
            if plotDF.shape[0]>0:
                plotDF.plot.bar(x='CitationCode', y='0', legend=False, title=uPara[k]+" from "+uPylm[j])#;mp.show()
                if plotDF.shape[0]>1:
                    pp = 'multi'
                else:
                    pp = 'one'
                mp.savefig("../p_paperGraphics/"+pp+"REF/"+uPara[k]+"_"+i+"_"+uPylm[j]+"_refFreq.pdf", dpi=99)

##### Fig.6 reproduce with top feasibility % (PBC, 0.3%) [20201204 dumped, use R instead] #####
dEst = pd.read_csv("../data/destructive_Lin.csv", keep_default_na=False)
cOnt = pd.read_csv("../data/continuous.csv", keep_default_na=False)

## divide data into 4 systems, filter illogical results (finite positive biomass values)
PoD = dEst[dEst.columns[0:12]].copy()
PBD = dEst.drop(dEst.columns[9:12], axis=1).copy()
PoC = cOnt[cOnt.columns[0:12]].copy()
PBC = cOnt.drop(cOnt.columns[9:12], axis=1).copy()
for i in range(PoD.shape[0]):
    if any(PoD.loc[i,PoD.columns[9:12]]<0) or any(np.isfinite(PoD.loc[i,PoD.columns[9:12]])==False): PoD.loc[i,PoD.columns[9:12]]=np.nan
    if PBD.loc[i,PBD.columns[9]]<0 or any(PBD.loc[i,PBD.columns[10:12]]<=0) or any(np.isfinite(PBD.loc[i,PBD.columns[9:12]])==False): PBD.loc[i,PBD.columns[9:12]]=np.nan
    if any(PoC.loc[i,PoC.columns[9:12]]<0) or any(np.isfinite(PoC.loc[i,PoC.columns[9:12]])==False): PoC.loc[i,PoC.columns[9:12]]=np.nan
    if PBC.loc[i,PBC.columns[9]]<0 or any(PBC.loc[i,PBC.columns[10:12]]<=0) or any(np.isfinite(PBC.loc[i,PBC.columns[9:12]])==False): PBC.loc[i,PBC.columns[9:12]]=np.nan
    if i%1e4==0: print(str(round(i/PoD.shape[0]*100,1))+"%")

PoD.to_csv("../p_paperGraphics/PoD.csv", header=True, index=False)
PBD.to_csv("../p_paperGraphics/PBD.csv", header=True, index=False)
PoC.to_csv("../p_paperGraphics/PoC.csv", header=True, index=False)
PBC.to_csv("../p_paperGraphics/PBC.csv", header=True, index=False)

## in
dAta = [pd.read_csv("../p_paperGraphics/"+i+".csv") for i in ["PoD","PBD","PoC","PBC"]]

## calculate yield
sOurce = ['PoD','PBD','PoC','PBC']
for i in range(len(dAta)):
    dAta[i]['Src'] = sOurce[i]
    if i<2:
        dAta[i]['yield'] = dAta[i].loc[:,dAta[i].columns[9:12]].sum(axis=1).div(dAta[i]['x'].astype(float))
    else:
        dAta[i]['yield'] = dAta[i][dAta[i].columns[9]].mul(dAta[i]['x']).astype(float)

# [[np.nanmin(dAta[i]['yield']),np.nanmax(dAta[i]['yield'])] for i in range(len(dAta))]
## filter top yield simulations
refLine = min([sum(np.isfinite(dAta[i]['yield'])) for i in range(len(dAta))])
sOrt = [dAta[i].sort_values(by='yield',axis=0, ascending=False, inplace=False).head(refLine) for i in range(len(dAta))]
for i in range(len(dAta)):
    tmp = list(sOrt[i].columns)
    tmp[9:12] = ['c','p','b']
    sOrt[i].columns = tmp

## combine data
pLot = sOrt[0]
for i in range(1,4):
    pLot = pLot.append(sOrt[i], ignore_index=True, sort=False)

## standardise parameter values
for i in range(9):
    pLot[pLot.columns[i]] = pLot[pLot.columns[i]].round(4)

pLot.to_csv("../p_paperGraphics/totalPlot.csv", header=True, index=False)

#sys.exit(0)
