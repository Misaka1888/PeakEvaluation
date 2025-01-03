function obj = ModelChange(obj)

% 
% 以下改变成分数时，需要手动计算更新
obj.matWstar    = []; % W*,
obj.matBeta     = []; % 不考虑均值影响：Y = X * Beta + E
obj.matBetaExt  = []; % 考虑 X 的均值和 Y 均值在内的，Y = X * BetaExt + E
obj.cvVIP       = [];