function [XS,XL,YL,XRes,YRes,W,C] = pls_matlab(matX,matY,nComp)
%
%  介绍：
%    本算法用的是 SIMPLS 算法，在计算前，算法已经缺省地将 matX 和 matY 中心化了！！！
%
%    XL = (XS\X0)' = X0'*XS。 XS是正交归一矩阵
%    YL = (XS\Y0)' = Y0'*XS,
%    YS = Y0*YL = Y0*Y0'*XS， 
%
%    MeanCenter(matX) = XS*XL' + XRes (近似相等？) 
%    MeanCenter(matY) = XS*YL' + YRes (严格相等)
%    MeanCenter(matY) = MeanCenter(matX)*Beta  + YRes (近似相等)
%
%    matScore = MeanCenter(matX)*W (近似相等)
%
% 输入参数:
%    matX   data matrix of independent variables(将被算法中心化后参与计算)
%    matY   data matrix of dependent variables(将被算法中心化后参与计算)
%    nComp  specify the number of components 指定隐成份的个数
% 
% 输出参数:
%   XS      score matrix of X   (正交归一)
%   XL      loading matrix of X (不正交，也不归一)
%   YL      loading matrix of Y with respect to XS (计算时只能 XS*YL')
%   XRes    The predictor residuals, that is, X0 - XScore*XLoading'. 
%   YRes    The response residuals, that is,  Y0 - XScore*YLoading'.
%   W       new Basis of X  (不正交，也不归一)
%           A p-by-ncomp matrix of PLS weights so that XScore = X0*W.
%   C       new Basis of Y
%
% 参考书：
%  [1] matlab2010b自带函数 plsregress
%      
%  plsregress uses the SIMPLS algorithm, and first centers X and Y by
%     subtracting off column means to get centered variables X0 and Y0.
%     However, it does not rescale the columns.  To perform partial least
%     squares regression with standardized variables, use ZSCORE to normalize X
%     and Y.
%     也就是说，输入X,Y可以是非中心化的，但plsregress算法在计算时，会先将输入的
%     X,Y做中心化，得到X0，Y0，然后再计算相应的score，loading等结果。
%
%     因此，当输入X,Y本身就已经是中心化的数据，那么plsregress得到的Beta的第一个
%     数值Beta(1)=0；
%************************************************************************

[XL,YL,XS,~,~,~,~,stats]=plsregress(matX,matY,nComp);

W       = stats.W;
% T2      = stats.T2;
XRes = stats.Xresiduals; 
YRes = stats.Yresiduals;
dimY = size(matY,2);
C    = ones(dimY,nComp);  % 自带算法中没有计算 C，因此用1代替

% 
% [Xloadings,Yloadings,Xscores,Yscores,betaPLS] = plsregress(X,Y,2); % 2
% 个成分， Y 可以是非中心化的，X 也可以是非中心化的。
%
% yfitPLS = [ones(n,1) X]*betaPLS;  % 回归方法
%
%  BETA is a (P+1)-by-M matrix, containing intercept
%     terms in the first row, i.e., Y = [ONES(N,1) X]*BETA + Yresiduals, and
%     Y0 = X0*BETA(2:END,:) + Yresiduals.
%  其中 X0，Y0 是中心化的(plsregress的中间变量)，而 X,Y 是非中心化的, 即
%     X0=MeanCenter(X),Y0=MeanCenter(Y)
%
% Beta    此处的 Beta 已经做了 X,Y 的均值校正

clear stats dimY;
end