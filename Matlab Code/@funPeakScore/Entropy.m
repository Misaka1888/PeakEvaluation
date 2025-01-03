function dbEntropy = Entropy(obj)

% *** 大部分计算不了！是 nan 或 0 ，为什么？****

dbEntropy = entropy(obj.cvNormMaxPI); % 计算信号的熵