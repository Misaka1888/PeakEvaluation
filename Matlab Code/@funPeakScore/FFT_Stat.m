function [dbMeanFFT,dbStdFFT] = FFT_Stat(obj)
% fft_mean_coefficient

cvFFT = abs(fft(obj.cvNormSumPI));
dbMeanFFT = mean(cvFFT); % 计算傅里叶变换系数的均值
dbStdFFT  = std(cvFFT);  % 计算傅里叶变换系数的标准差

clear cvFFT;