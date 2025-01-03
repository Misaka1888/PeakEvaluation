function result=MeanCenter(X)
%
%用法：
%   result=MeanCenter(X)
%
%输入：
%   X：    样本矩阵，每一行一个样本，每一列为一个变量。
%
%输出：
%   result: 大小与X相同的矩阵
%
%********************************************************************
result=[];

% 如果矩阵X是空矩阵，则给出提示并返回
if isempty(X), return; end;

% 如果矩阵X中包含复数，则不计算
if isreal(X)==0
    disp('只能对实矩阵进行标准化，Not Real Matrix Input!')
    return
end

% 获取行数和列数
nSample=size(X,1);

% 中心化：每一列元素减去该列的平均值
result = X - repmat(mean(X,1),nSample,1);
% result = X - ones(nSample,1)*mean(X,1);

clear nSample;