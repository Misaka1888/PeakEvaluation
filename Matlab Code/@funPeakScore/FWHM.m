function [dbFWHM,dbFWHM2Base] = FWHM(obj)
%
% full width half max 计算半高宽 % 定义计算FWHM的函数

half_max = obj.dbMax/2;

% 计算左侧和右侧的索引
left_idx  = find(obj.cvPI(1:obj.iPosMax) < half_max, 1, 'last');
right_idx = find(obj.cvPI(obj.iPosMax:end) < half_max, 1, 'first');

if isempty(left_idx)
    t_left  = obj.cvRT(1);
else
    % 插值计算时间
    t_left  = interp1(obj.cvPI(left_idx:left_idx+1),   obj.cvRT(left_idx:left_idx+1),   half_max);
end
if isempty(right_idx)
    t_right = obj.cvRT(end);
else
    right_idx = right_idx + obj.iPosMax - 1;
    t_right = interp1(obj.cvPI(right_idx-1:right_idx), obj.cvRT(right_idx-1:right_idx), half_max);
end

% 计算FWHM
dbFWHM = t_right - t_left;
dbFWHM2Base = dbFWHM / (obj.cvRT(end) - obj.cvRT(1));

clear half_max left_idx right_idx t_left t_right;