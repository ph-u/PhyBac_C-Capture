/*
Author 	: ph-u
Script 	: stablePositions.c
Desc 	: calculate two alternative stabilities from a parameter scenario
Input 	: `gcc stablePositions.c -o p_sP;./p_sP [x] [ePR] [eP] [gP] [aP] [eBR] [eB] [gB] [mB]`
Output 	: verbose csv entry
Arg 	: 9
Date: 	: Jul 2020
*/

#include <stdio.h>
#include <stdlib.h>

int main (int argc, char *argv[]){

    if(argc == 10){
        
        float x = atof(argv[1]);
        float ePR = atof(argv[2]); float eP = atof(argv[3]);float gP = atof(argv[4]); float aP = atof(argv[5]);
        float eBR = atof(argv[6]); float eB = atof(argv[7]);float gB = atof(argv[8]); float mB = atof(argv[9]);

        float c3 = eP*(ePR*gP)*(ePR*gP)/(aP*x); /* PoH - C */
        float p3 = ePR*eP*gP/aP; /* PoH - P */
        int b3 = 0; /* PoH - B */
        float c4 = mB/(eBR*eB*gB); /* PBH - C */
        float p4 = ePR*eP*gP/aP; /* PBH - P */
        float b4 = (aP*mB*x - eBR*eB*gB*eP*ePR*gP*ePR*gP)/(gB*mB*aP*(eBR-1)); /* PBH - B */

        printf("%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%d,%f,%f,%f\n", x,ePR,eP,gP,aP,eBR,eB,gB,mB,c3,p3,b3,c4,p4,b4); /* output stabilities calculation result */

    }else{
        printf("number of arguments should be 9\n");
    }

    return 0;
}
