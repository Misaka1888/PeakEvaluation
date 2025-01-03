function [dbMeanWavelet,dbStdWavelet] = Wavelet_Stat(obj)

% 计算小波变换的绝对均值和标准差
wavelet_transform = cwt(obj.cvNormSumPI, 'amor'); % 进行连续小波变换 确保您的 MATLAB 版本支持 cwt 函数

dbMeanWavelet = mean(abs(wavelet_transform(:))); % 计算小波变换的绝对均值
dbStdWavelet  = std(wavelet_transform(:)); % 计算小波变换的标准差

if dbMeanWavelet>0
    dbMeanWavelet = log10(dbMeanWavelet);
end
if dbStdWavelet>0
    dbStdWavelet = log10(dbStdWavelet);
end

clear wavelet_transform;