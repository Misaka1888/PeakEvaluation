function qScore = NormalTest(obj)

% 正态性检验
[~,~,qScore] = lillietest(obj.cvNormMaxPI,0.05);
qScore = - log10(qScore);
