function [matXScore,matXRecon] = PredictX(obj,matNewX)

nSample = size(matNewX,1);

matNewX = matNewX - repmat(obj.rvMeanX,nSample,1);

matXScore = matNewX * obj.matBasisX;
matXRecon = matXScore * obj.matLoadingX;

clear nSample;