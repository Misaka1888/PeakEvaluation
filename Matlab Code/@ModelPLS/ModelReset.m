function obj = ModelReset(obj)

% 以下改变成分数时，会自动计算更新
obj.nComp       = 0;  % 成分个数
obj.matResX     = [];
obj.matResY     = [];
obj.matScoreX   = []; % X得分矩阵        
obj.matLoadingX = []; % X负载矩阵        
obj.matBasisX   = []; % W

obj.matScoreY   = []; % Y得分矩阵        
obj.matLoadingY = []; % Y负载矩阵
obj.matBasisY   = []; % Y分解的基

obj.cvR2X       = []; % R2X
obj.cvR2Y       = []; % R2Y
obj.cvQ2Y       = []; % Q2Y

% 以下改变成分数时，需要手动计算更新
obj.matWstar    = []; % W*,
obj.matBeta     = []; % 不考虑均值影响：Y = X * Beta + E
obj.matBetaExt  = []; % 考虑 X 的均值和 Y 均值在内的，Y = X * BetaExt + E
obj.cvVIP       = [];