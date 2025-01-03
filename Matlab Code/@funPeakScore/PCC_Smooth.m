function dbPCC_Smooth = PCC_Smooth(obj)

% 计算 ROI (Peak) 的在平滑前后的相关系数

% Reference
% Hailiang Zhang, et al. Anal. Chem., 2023, 95, 612.

% cvPI 中的缺失值用最小值代替。并最小值当成基线

dbPCC_Smooth = corr(obj.cvSmoothPI,obj.cvPI); % 此处必须是列矢量
dbPCC_Smooth = 0.5*log((1+dbPCC_Smooth)/(1-dbPCC_Smooth)); % Fisher Z 变换