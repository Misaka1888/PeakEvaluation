function dbTPASR = TPASR(obj)

% 计算 ROI (Peak) 左右两边的对称性
% Estimates shape quality by comparing peak area to area of triangle formed by the apex and boundaries

% Reference
% Kelsey Chetnik, et al. Metabolomics, 2020, 16, 117.

dbTPASR = 0.5*obj.nPoint*obj.dbMax/obj.dbSum;

if dbTPASR<=0
    dbTPASR = 0;
else
    dbTPASR = log10(dbTPASR);
end