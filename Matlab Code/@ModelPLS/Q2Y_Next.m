function dbQ2Y = Q2Y_Next(obj)
%
% 用法：
%    [dbQ2Y,PRESSh,RESSh_1]= Q2Y_NextComp(matX,matY,iComp,nFold)
%
% 功能：
%   计算偏最小二乘回归交叉有效性的子函数，即，Y的预测平方和。
%   一般地，我们希望Q2h越大越好，若Q2h大约0.0975，
%   则说明第nComp个成分的边际贡献是显著的。
%
% Inputs:
%    matX       data matrix of independent variables
%    matY       data matrix of dependent variables
%    iComp      specify the index of components 指定第iComp个隐成份
%    nFold      n-fold cross validation(default:7)
% 
% Outputs:
%   dbQ2Y:      Y的交叉验证有效性
%
% 参考书：
%  [1] 王惠文, 吴载斌, 孟洁. 偏最小二乘回归的线性与非线性方法. 国防工业出版社.
%      北京, 2006. (p.103-104)
%  [2] L.Eriksson, E.Johansson, N.Kettaneh-Wold, S.Wold. Multi- and
%      Megavariate Data Analysis. Principles and Applications. Umetrics
%      academy,2001

% the prediction error sum of squares (PRESS) is the sum of the squared
% differences between observed matY and predicted values when the observation
% s were kept out. we then have:
%
%           PRESS=sum(sum((handels.m_matY-preY).^2));
%
% For every dimension, the overall PRESS/SS is computed, where SS is the
% residual sum of squares of the previous dimension, and also (PRESS/SS)m
% for each matY variable (m).
%
% 其中，SS 应该是SSE，即
%   SSE: the sum of squares of residual variation (Error). 即，残差平方和，
%       SSE = sum( sum( (handles.m_matY-temY).^2 ) );
%       temY = handles.m_matY-T*R';
%
%
%************************************************************************

if obj.nFold > obj.nSample, obj.nFold = obj.nSample; end

if obj.nComp == min(obj.nSample,obj.nVariable)
    disp('reach the maximal component!');
    return;
end

% 指定各样本的 Fold 的编号
cvFoldIndex    = repmat((1:obj.nFold)',ceil(obj.nSample/obj.nFold)+1,1);
cvFoldIndex(1) = [];
cvFoldIndex(obj.nSample+1:end) = [];

% 预测值属性
preY = zeros(size(obj.matResY));

% 每次去掉一个group的样本，用剩余的样本集训练模型W，再计算预测误差平方
for i=1:obj.nFold
    
    % 将第i个group的样本删除
    trainX = obj.matResX(cvFoldIndex~=i,:);
    trainY = obj.matResY(cvFoldIndex~=i,:);
    
    % 取出第i个group的样本
    testX = obj.matResX(cvFoldIndex==i,:);

    if isequal(obj.strType,'matlab')    
        [~,XL,YL,~,~,W] = ModelPLS.pls_matlab(trainX,trainY,1);
    else
        [~,XL,YL,~,~,W] = ModelPLS.pls_book(trainX,trainY,1);
    end

    % 计算第i个group的样本的预测属性
    matBeta_ext = subGetBeta(trainX,trainY,XL,YL,W);

    preY(cvFoldIndex==i,:) = [ones(size(testX,1),1),testX] * matBeta_ext;
end

% 计算Y的预测误差平方和
PRESSh = sum(sum((obj.matResY-preY).^2));

% 计算Y的预测误差平方和
RESSh_1 = sum(sum(obj.matResY.^2));

% 计算交叉验证有效性
dbQ2Y = 1-PRESSh/RESSh_1;

clear testX trainX trainY cvFoldIndex XL YL W PRESSh PRESSh_1 i preY matBeta_ext;
end


function matBeta_ext = subGetBeta(matX,matY,matLoadingX,matLoadingY,matBasisX)

[nDimY,nComp]=size(matLoadingY);

matWstar = subGetWstar(matLoadingX,matBasisX);
Beta = matWstar * matLoadingY';

rvMeanY = mean(matY);
rvMeanX = mean(matX);

if nComp<3  % 此处可能是 2
   matBeta_ext =[zeros(1,nDimY); Beta];
else
    matBeta_ext =[rvMeanY - rvMeanX * Beta; Beta];
end

clear matWstar rvMeanY rvMeanX Beta nDimY nComp;
end


function matWstar = subGetWstar(matLoadingX,matBasisX)
% 计算权重系数 W*
% 计算时，Component的数目可以选择，不一定是全部的component

if isempty(matBasisX)
    matWstar=[];
    return;
end

[nVariable,nComp] = size(matBasisX);
matWstar=zeros(nVariable,nComp);

I = eye(nVariable,nVariable);
for h = 1:nComp
    matWstar(:,h) = matBasisX(:,h);
    if h == 1
        Wh = I - matBasisX(:,h) * matLoadingX(:,h)';
    else
        matWstar(:,h) = Wh * matWstar(:,h);                      % Wh-1
        Wh = Wh - Wh * matBasisX(:,h) * matLoadingX(:,h)'; % Wh
    end    
end

clear nComp nVariable Wh I;
end