function dbMean2Diff = Mean2Diff(obj)

% 计算差分绝对值均值 与 均值 之比

dbMean2Diff = mean(abs(diff(obj.cvPI)))/obj.dbMean; % 计算差分均值