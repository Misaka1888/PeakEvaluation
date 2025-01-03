function [dbZZ,dbDeltaZZ] = Zigzag(obj)

% 计算 ROI (Peak) 在平滑前后的 Zigzag 指数差

% Reference
% Hailiang Zhang, et al. Anal. Chem., 2023, 95, 612.


% cvPI 中的缺失值用最小值代替。并最小值当成基线
dbZZ = obj.nPoint*(obj.dbMax - obj.dbMin)^2;
dbZZ = sum((2*obj.cvPI(2:end-1) - obj.cvPI(1:end-2)  - obj.cvPI(3:end)).^2)/dbZZ;

if dbZZ > 0
    dbZZ = log10(dbZZ);
end

% 平滑
dbZ0 = obj.nPoint*(max(obj.cvSmoothPI) - min(obj.cvSmoothPI))^2;
dbZ0 = sum((2*obj.cvSmoothPI(2:end-1) - obj.cvSmoothPI(1:end-2)  - obj.cvSmoothPI(3:end)).^2)/dbZ0;

if dbZ0 > 0
    dbZ0 = log10(dbZ0);
end

dbDeltaZZ = abs(dbZZ - dbZ0); 

clear dbZ0;