function [dbUniformity,dbUniformityStd] = Uniformity(obj,nBin)
if ~exist('nBin','var'),nBin =20;end

rvHist = histcounts(obj.cvPI,nBin);
rvHist = rvHist/sum(rvHist);

dbUniformity = sum(rvHist.*rvHist);

nPoint = length(rvHist);
rvHist = rvHist/nPoint;

dbUniformityStd = sum(rvHist.*rvHist);
clear rvHist nPoint;