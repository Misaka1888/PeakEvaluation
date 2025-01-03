function dbGaussSim = GaussSimilar(obj)

% 计算 ROI (Peak) 左右两边的对称性
% Measures similarity of a peak to Gaussianfitted curve

% Reference
% Kelsey Chetnik, et al. Metabolomics, 2020, 16, 117.

cvFitPI = obj.GaussianFit();
dbGaussSim = sum(cvFitPI.* obj.cvPI)/(norm(cvFitPI)*norm(obj.cvPI));

dbGaussSim = 0.5*log((1+dbGaussSim)/(1-dbGaussSim));  % Fisher Z 变换
clear cvFitPI;