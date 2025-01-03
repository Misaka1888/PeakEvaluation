function [XS,XL,YL,XRes,YRes,W,C] = pls_book(X,Y,nComp)
%
%  介绍：
%    本算法根据王惠文书P.98-102编写，并已经与 SIMCA-P 12.0.1 的结果匹配！
%
% 输入参数:
%    X      data matrix of independent variables
%    Y      data matrix of dependent variables(将被算法中心化后参与计算)
%    nComp  specify the number of components 指定隐成份的个数
% 
% 输出参数:
%   XS      score matrix of X   (正交, 但不归一)
%   XL      loading matrix of X (不正交，也不归一)
%   YL      loading matrix of Y with respect to XS (计算时只能 XS*YL')
%   XRes    The predictor residuals, that is, X0 - XScore*XLoading'. 
%   YRes    The response residuals, that is,  Y0 - XScore*YLoading'.
%   W       new Basis of X  (正交归一)
%           A p-by-ncomp matrix of PLS weights so that XScore = X0*W.
%   C       new Basis of Y
%
% 说明：
%    X = XS * XL' + XRes (近似相等？) 
%    XS(:,i) = (X-XS(:,i-1)*XL(:,i-1)') * W （严格相等)
%    MeanCenter(Y) = XS * YL'  + YRes (近似相等)
%    MeanCenter(Y) = X * Beta  + YRes (近似相等)
%
% 参考书：
%  [1] 王惠文, 吴载斌, 孟洁. 偏最小二乘回归的线性与非线性方法. 国防工业出版社.
%      北京, 2006. (p.98-102)
%      
%
%************************************************************************

XRes = X;
[nSample,nVariable]=size(X);

nDimY = size(Y,2);
YRes = Y;
% YRes = Y - repmat(mean(Y,1),nSample,1); % 中心化

% [W,~,C] = svds((XRes'*YRes)*(YRes'*XRes),nComp); % 不能计算 nComp>1 的情况！！！！！！！！！！！！！！！！！！！！！！！！！！！！******************

XS = zeros(nSample,nComp);         % modified by Jiyang Dong, 2015.11.4
XL = zeros(nVariable,nComp);
YL = zeros(nDimY,nComp);
W  = zeros(nVariable,nComp);
C  = zeros(nDimY,nComp);
for i=1:nComp
    [W(:,i),~,C(:,i)] = svds(XRes'*YRes,1);
    XS(:,i) = XRes  * W(:,i);
    XL(:,i) = XRes' * XS(:,i)/(XS(:,i)'*XS(:,i));    
    YL(:,i) = YRes' * XS(:,i)/(XS(:,i)'*XS(:,i));
    XRes = XRes - XS(:,i) * XL(:,i)';
    YRes = YRes - XS(:,i) * YL(:,i)';
end
end