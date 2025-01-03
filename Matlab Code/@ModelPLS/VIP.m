function obj = VIP(obj)
%
% 用法：
%    cvVIP = VIP_PLS(matY,matScoreX,matBasisX) 
%
% 功能：
%   计算PLS模型的各个主成分(得分)T对标识矩阵Y的解释能力。
%       PLS: X = T * P' + E      ( X 为样本矩阵)
%            T = X * W
%            Y = T * R' + F
%
% Inputs:
%    matY:          样本标识矩阵(Y)
%    matScoreX:     样本在新基上的得分矩阵(T)
%    matBasisX:     样本得分矩阵的新基(W)
% 
% Outputs:
%    cvVIP:    样本矩阵X各变量在解释Y时作用的重要性。
%
% 子函数：
%    Rd.m
%
% 参考书：
%  [1] 王惠文, 吴载斌, 孟洁. 偏最小二乘回归的线性与非线性方法. 国防工业出版社.
%      北京, 2006. (nVariable.119-120)
%
%************************************************************************

if obj.nComp==0,return;end

obj.cvVIP = zeros(obj.nVariable,1);

for j = 1:obj.nVariable
    for h = 1:obj.nComp
        obj.cvVIP(j) = obj.cvVIP(j) + subRd(obj.matRawY,obj.matScoreX(:,h)) * obj.matBasisX(j,h) * obj.matBasisX(j,h);
    end
    obj.cvVIP(j) = obj.cvVIP(j) * obj.nVariable;
    obj.cvVIP(j) = obj.cvVIP(j) / subRd(obj.matRawY,obj.matScoreX);
    obj.cvVIP(j) = sqrt(obj.cvVIP(j));
end
clear i h;
end


function result = subRd(partX,partT)
%
% 用法：
%    result=Rd(partX,partT) 
%
% 功能：
%   计算PCA或PLS模型的主成分(得分)T对样本矩阵X或标识矩阵Y的解释能力。(相关系数平方的平均)
%       PCA: X=T*P'+E
%       PLS: X=T*P'+E
%            Y=T*R'+F
%
% Inputs:
%    partX：    PCA模型中的X的某几列，或者PLS模型中的X或Y的某几列。
%    partT：    PCA或PLS模型中的T的的某几列。
% 
% Outputs:
%   result:    partT对partX的解释能力。正常的result范围应该在0～1。
%              若大于1，则说明partT中有些分量是0，或接近0的。
%
%
% 参考书：
%  [1] 王惠文, 吴载斌, 孟洁. 偏最小二乘回归的线性与非线性方法. 国防工业出版社.
%      北京, 2006. (p.117-118)
%      
% Copyright: Create by Dong JY at Sep. 15, 2009.
%
%************************************************************************

[rX,cX]=size(partX);
[rT,cT]=size(partT);

if rX~=rT
    disp('维数不匹配！')
    return
end

result=0;
for i=1:cX
    xi=partX(:,i);               % 取X的第i列，即第i个原始变量
    for j=1:cT
        tj=partT(:,j);           % 取T的第j列，即第j个新变量
        
        % 将接近0的tj排除掉，否则总贡献将有可能大于1
        if tj'*tj>1e-6
            r = corrcoef(xi,tj);  % 取xi和tj的相关系数的平方       
            result = result + r(2)*r(2);
        end
    end
end

result=result/cX; % 只需要对X的个数取平均，不需要对T的个数取平均！
end