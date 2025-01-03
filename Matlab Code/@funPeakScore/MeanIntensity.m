function [dbMean,dbMedian,dbMAE] = MeanIntensity(obj)
dbMean   = mean(obj.cvNormSumPI); % 计算信号的熵
dbMedian = median(obj.cvNormSumPI); % 计算信号的熵

dbMAE = mean(abs(obj.cvNormSumPI-dbMean));