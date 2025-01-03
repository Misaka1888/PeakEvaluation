function cvAutoCorr = AutoCorrelation(obj)
% autocorrelation
cvAutoCorr = xcorr(obj.cvNormMaxPI); % 计算自相关函数