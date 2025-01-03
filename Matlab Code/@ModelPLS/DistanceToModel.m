function [cvDModX,cvDModY,cvDModX_adj,cvDModY_adj] = DistanceToModel(obj)
%
% 用法：
%    [cvDMod,adjcvDMod]=DistanceToModel(matResXoY,cvIndex)
%
% 功能：
%   计算第index个样本在X(或Y)空间到模型(PCA或PLS)的距离。
%       PLS: X=T*P'+E
%            Y=T*R'+F
%       PCA: X=T*P'+E
%
% Inputs:
%    matResXoY      X 或 Y 的残差矩阵
%    nComp     成分个数
%    cvIndex   待计算距离的样本号
% 
% Outputs:
%   cvDMod:     样本i到模型的距离
%   adjcvDMod:  调整后的样本i到模型的距离
%
% 参考书：
%  [1] 王惠文, 吴载斌, 孟洁. 偏最小二乘回归的线性与非线性方法. 国防工业出版社.
%      北京, 2006. (nVariable.125-127)
%      
%
%************************************************************************

cvIndex = (1:obj.nSample)'; % 样本索引号

[cvDModX,cvDModX_adj] = subDMod(obj.matResX,obj.nComp,obj.nVariable,obj.nSample,cvIndex);
[cvDModY,cvDModY_adj] = subDMod(obj.matResY,obj.nComp,obj.nDimY,obj.nSample,cvIndex);

clear cvIndex;
end


function [cvDMod,adjcvDMod] = subDMod(matX,nComp,nVariable,nSample,cvIndex)

% 计算平方误差矩阵
E2X = matX .* matX;

% 距离归一化常数
if (nVariable - nComp <= 0) || (nSample - nComp - 1 <= 0)
    c = 1;
else
    c = sqrt(nSample/((nVariable - nComp)*(nSample - nComp-1)));
end

% 计算第i个样本Xi与模型的距离
if nVariable==1
    cvDMod = ( c*sqrt( E2X(cvIndex,:)' ) )';
else
    cvDMod = (c*sqrt(sum((E2X(cvIndex,:)'))))';
end

% 计算所有n个样本与模型的距离的平均值
coief = sqrt(sum(E2X(:))*c*c/nSample);

% 计算第i个样本Xi与模型的调整后距离
adjcvDMod = cvDMod/coief;

clear E2X c coief;
end