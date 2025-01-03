function [dbSNR,dbCV,dbABRatio] = SNR_CV_ABRatio(obj)

% 计算 ROI (Peak) 的信噪比\ 计算 ROI (Peak) 在峰顶和边沿的差
% Uses boundary-over-apex intensity ratio to assess completeness of integration

% Reference
% Kelsey Chetnik, et al. Metabolomics, 2020, 16, 117.

% Checked by Jiyang Dong, 2024-07-30

dbSNR = (obj.dbMax - obj.dbMean)/obj.dbStd;
dbCV  = obj.dbStd/obj.dbMean;

dbABRatio = max(obj.cvPI(1),obj.cvPI(end))/obj.dbMax;