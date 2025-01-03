function dbSymmetry = Symmetry(obj)

% 计算 ROI (Peak) 左右两边的对称性
% Measures correlation between left and right halves of a peak

% Reference
% Kelsey Chetnik, et al. Metabolomics, 2020, 16, 117.

% 分别计算峰左半部分和右半部分
half_length = floor(obj.nPointPad / 2);
left        = obj.cvPaddingPI(1:half_length);
right       = flipud(obj.cvPaddingPI(end-half_length+1:end));

% 计算皮尔逊相关系数
dbSymmetry = corr(left, right, 'Type', 'Pearson');

% 将NA值替换为1
if isnan(dbSymmetry),dbSymmetry = 0; end

clear half_length left right;