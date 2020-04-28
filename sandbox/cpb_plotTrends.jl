using RCall, PyCall, DataFrames, CSV, Plots, SymPy
sc = pyimport("scipy")
cst = pyimport("scipy.constants")
itg = pyimport("scipy.integrate")
sympy.init_printing()
R"library(lattice)"

rAw = CSV.read("../result/maxYield_0.05.csv")
@rput rAw
R"
uNiqRAW = vector(mode='list')
for(i in 1:9){uNiqRAW[[i]]<-unique(rAw[,i])};rm(i)
uNiqRAW
"

R"
gPBmap = function(z,cRi,rAw,uNiqRAW){
## cRi = c(rep(1,3),0,rep(1,3),0,1) #set-up filter criteria (=position) & xy axis (=0)
pInt = rAw ## set-up data details to be filtered by iteration
xyAxis = which(cRi==0)

for(i in 1:9){
if(cRi[i]>0){
    pInt = pInt[which(pInt[,i]==uNiqRAW[[i]][cRi[i]]),] ## trim data
}};rm(i)

## plot heatmaps
levelplot(pInt[,z]~pInt[,xyAxis[1]]*pInt[,xyAxis[2]], xlab=colnames(pInt)[xyAxis[1]], ylab=colnames(pInt)[xyAxis[2]], col.regions = rev(gray(0:100/100)), main = paste0('Heatmap of ',colnames(pInt)[z],' gC/m^3 with\nC-rm rate ',uNiqRAW[[1]][cRi[1]],' t^-1 & aP ',uNiqRAW[[5]][cRi[5]],' m^3/(gC t)'))
}

cRiteria = as.data.frame(matrix(NA,nc=5,nr=9))
cRiteria[,1] = c(1,1,1,0,1,1,1,0,1) ##LL
cRiteria[,2] = c(1,1,1,0,length(uNiqRAW[[5]]),1,1,0,1) ##LH
cRiteria[,3] = c(length(uNiqRAW[[1]]),1,1,0,1,1,1,0,1) ##HL
cRiteria[,4] = c(length(uNiqRAW[[1]]),1,1,0,length(uNiqRAW[[5]]),1,1,0,1) ##HH
cRiteria[,5] = c(round(length(uNiqRAW[[1]])/2),1,1,0,round(length(uNiqRAW[[5]])/2),1,1,0,1) ##MM
"
println("env finished set-up, start contour plots")

R"
for(i in 10:13){
if(i>11){
if(i>12){cC<-'A'}else{cC<-'B'}
}else{
if(i<11){cC<-'C'}else{cC<-'P'}
}
for(i0 in 1:5){

if(i0==5){xX<-'M'}else if(i0>2){xX<-'H'}else{xX<-'L'}
if(i0==5){aA<-'M'}else if(i0%%2==0){aA<-'H'}else{aA<-'L'}

png(paste0('graph/x',xX,'a',aA,'pb',cC,'.png'))
gPBmap(i, cRiteria[,i0], rAw, uNiqRAW)
Sys.sleep(10)
dev.off()
}};rm(i,i0)
"
println("contour plots done, start integration set-up")

function ebc7(Den,t,x, g_P,e_PR,e_P,a_P, g_B,e_BR,e_B,m_B)
    
    ## variable sorting
    C = Den[:1]
    P = Den[:2]
    B = Den[:3]
    
    ## rate calculation
    dC = g_P*e_PR*(1-e_P)*P +a_P*P^2 +g_B*(e_BR*(1-e_B)-1)*C*B +m_B*B -x*C
    dP = g_P*e_PR*e_P*P -a_P*P^2
    dB = g_B*e_BR*e_B*C*B -m_B*B
    
    ## logic check
    if C<=0; dC=0;end
    if P<=0; dP=0;end
    if B<=0; dB=0;end
    
    return(sc.array([dC,dP,dB]))
    
end

@rget uNiqRAW cRiteria

function ebcPlt(tStp,eNd, sItuation, x,y, cRiteria,uNiqRAW)
    t = sc.linspace(0, eNd, tStp) # sample time series
    if(sItuation=="LL");coL=1;elseif(sItuation=="LH");coL=2;elseif(sItuation=="HL");coL=3;elseif(sItuation=="HH");coL=4;else coL=5;end # set heatmap situation
    if(x=="L");x=1;else x=length(uNiqRAW[4]);end
    if(y=="L");y=1;else y=length(uNiqRAW[8]);end
    
    ## collect arguments
    aRg = [uNiqRAW[1][Int(cRiteria[1,coL])],
            uNiqRAW[2][Int(cRiteria[2,coL])],
            uNiqRAW[3][Int(cRiteria[3,coL])],
            uNiqRAW[4][x],
            uNiqRAW[5][Int(cRiteria[5,coL])],
            uNiqRAW[6][Int(cRiteria[6,coL])],
            uNiqRAW[7][Int(cRiteria[7,coL])],
            uNiqRAW[8][y],
            uNiqRAW[9][Int(cRiteria[9,coL])]]
    
    pops, infodict = itg.odeint(ebc7, sc.array([.1/100000000000,.1/100000000000,.1/100000000000]), t, full_output=true, args=(aRg[1],aRg[2],aRg[3],aRg[4],aRg[5],aRg[6],aRg[7],aRg[8],aRg[9]))
    pops = DataFrame(pops)
    pops[:,:x4] = pops[:,:x1]+pops[:,:x2]+pops[:,:x3]
    pops = Array(pops)
    
    plot(pops, xlabel="time steps", ylabel="carbon density (gm^-3)",
        title=string(eNd)*" days progression on carbon density with parameters\nx="*string(aRg[1])*", ePR="*string(aRg[2])*", eP="*string(aRg[3])*", gP="*string(aRg[4])*", aP="*string(aRg[5])*",\neBR="*string(aRg[6])*", eB="*string(aRg[7])*", gB="*string(aRg[8])*", mB="*string(aRg[9]),
        lab=["organic carbon" "phytoplankton" "bacterial decomposer" "total carbon"])
end

tIme = 100
eNd = 1000
println("integration set-up done, start integration graphs")

for i0 in ["LL" "LH" "HL" "HH" "MM"];for i1 in ["L" "H"];for i2 in ["L" "H"]
	pLt = ebcPlt(tIme,eNd, i0, i1, i2,cRiteria,uNiqRAW)
	png(pLt, "graph/int_xa"*i0*"p"*i1*"b"*i2*".png")
end;end;end
