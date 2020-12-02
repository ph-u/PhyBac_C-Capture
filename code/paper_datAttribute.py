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

for i in range(len(pAr)-1):
    for j in range(len(dTl)-1):
        iDx = [i,j]
        pltDF = tOtal[tOtal['parameter']==pAr[iDx[0]]]
        p = pltDF[[dTl[iDx[1]][0],'perDay']].boxplot(by=dTl[iDx[1]][0], figsize=dTl[iDx[1]][1], grid=False, rot=90)
        mp.savefig("../p_paperGraphics/"+pAr[iDx[0]]+"_"+dTl[iDx[1]][0]+".pdf", dpi=99)

##### data source distribution on parameters #####
gRp = rAw.copy()
gRp['CitationCode'] = pd.Categorical(gRp.Citation).codes
gRp.groupby(['CitationCode','Citation']).size().to_csv("../p_paperGraphics/citationREF.csv", header=True) ## citation index reference count table

for i in gRp.columns[2:7]:
    gRp.groupby(['CitationCode','parameter',i]).size().to_csv("../p_paperGraphics/countTable_"+i+".csv", header=True) ## use csv as record
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

##### Fig.6 reproduce with top feasibility % (PBC, 0.3%) #####


#sys.exit(0)
