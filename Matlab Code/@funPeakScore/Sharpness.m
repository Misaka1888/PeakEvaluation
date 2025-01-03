function dbSharpness = Sharpness(obj)

% 计算 ROI (Peak) 左右两边的对称性
% Captures steepness of a peak by summing the ratio of the difference 
% between neighboring points and the point within the pair expected to have the lower value

% Reference
% Kelsey Chetnik, et al. Metabolomics, 2020, 16, 117.

if obj.iPosMax==1
    dbSharpness = sum((obj.cvNormMaxPI(obj.iPosMax:end-1)-obj.cvNormMaxPI(obj.iPosMax+1:end))./obj.cvNormMaxPI(obj.iPosMax+1:end));
elseif obj.iPosMax== obj.nPoint
    dbSharpness = sum((obj.cvNormMaxPI(2:obj.iPosMax)-obj.cvNormMaxPI(1:obj.iPosMax-1))./obj.cvNormMaxPI(1:obj.iPosMax-1));
else
    dbSharpness = sum((obj.cvNormMaxPI(2:obj.iPosMax)-obj.cvNormMaxPI(1:obj.iPosMax-1))./obj.cvNormMaxPI(1:obj.iPosMax-1)) +...
        sum((obj.cvNormMaxPI(obj.iPosMax:end-1)-obj.cvNormMaxPI(obj.iPosMax+1:end))./obj.cvNormMaxPI(obj.iPosMax+1:end));
end

dbSharpness = log10(dbSharpness); % 加上这句，不然太多0. 2024-08-23,

if isinf(dbSharpness),dbSharpness=0;end
if isnan(dbSharpness),dbSharpness=0;end