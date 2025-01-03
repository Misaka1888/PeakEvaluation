function [matPreY,matPreY0] = PredictY(obj,matNewX)

if obj.nComp==0,return;end

if isempty(obj.matBetaExt)
    obj.Beta();
end

nSample = size(matNewX,1);

% 对新的 X 进行扩展，以校正由于 X 和 Y 的均值引起的误差
matNewX = matNewX - repmat(obj.rvMeanX,nSample,1);

matPreY  = [ones(nSample,1), matNewX] * obj.matBetaExt; 
matPreY0 = matNewX * obj.matBeta; 

clear nSample;
end



%**********************************************************************
%
% (1) 对 Y 进行回归时（不考虑 MeanY 的拟合残余！）
%          FitY = X * Beta_x
%               = (Xc + MeanX) * Beta_x           % Xc 是 X 的中心化
%               = Xc * Beta_x + MeanX * Beta_x
%
%               = FitYc + FitMeanY                % Yc 是 Y 的中心化
%
% (2) 考虑 Y 的均值 （考虑了 MeanY 的拟合残余！）
%         FitYc + MeanY = FitYc + FitMeanY + ResMeanY
%                       = FitY - FitMeanY + FitMeanY + ResMeanY
%                       = FitY + ResMeanY
%                       = FitY + MeanY - FitMeanY
%                       = X * Beta_x + (MeanY - MeanX * Beta_x) *** 回归时用
%                       = Xc * Beta_x + MeanY
%
%*************************** 可 见 ***********************************
%
% (1) PCA 计算时，X 不需要中心化
%
% MeanY 的残余为：
%          ResMeanY = MeanY - FitMeanY
%
%          FitYc = FitY - FitMeanY 
%
%          MeanY = mean(Y);
%          MeanX = mean(X);