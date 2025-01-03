function [cvScore,nScore] = AllScore(obj)

nScore = 34;
cvScore = zeros(nScore,1);


% 以下是 ROI 的峰形判断指标
[cvScore(1),cvScore(2),cvScore(3)] = obj.SNR_CV_ABRatio(); % Peak 信噪比\变异系数\计算峰顶Apex和峰沿 Boundray 的比例

cvScore(4) = obj.Symmetry();       % 计算对称性

cvScore(5) = obj.GaussSimilar();   % 计算高斯拟合前后的相似性。
cvScore(6) = obj.TPASR();          % 计算三角形和实际峰面积的比，胖瘦程度        

[~,cvScore(7)] = obj.FWHM();       % 计算半高宽

[cvScore(8),cvScore(9)] = obj.Zigzag(); % 计算平滑前后的Zigzag差
cvScore(10) = obj.PCC_Smooth();  % 计算平滑前后的相关系数        
cvScore(11) = obj.Sharpness();   % 计算陡峭程度

% 时域统计特征
cvScore(12) = obj.Skewness(); % 偏度
cvScore(13) = obj.Kurtosis(); % 峰度
cvScore(14) = obj.RMS();      % 计算 root-mean-square 均方误差
cvScore(15) = obj.Slope_ecdf(); % 计算经验分布函数斜率

% 频域统计特征
[cvScore(16),cvScore(17)] = obj.FFT_Stat();     % 计算傅里叶变换系数的均值和标准差
[cvScore(18),cvScore(19)] = obj.Wavelet_Stat(); % 计算小波变换的绝对均值和标准差

% 计算基于时域的时序特征
cvScore(20) = obj.CentroidRatio();   % 质心与中心的比
cvScore(21) = obj.Mean2Diff();       % 计算差分均值 与 均值 之比
cvScore(22) = obj.Modality();        % 计算模态
cvScore(23) = obj.Entropy();         % 计算信号分布熵 *** 大部分为 0 *** 
cvScore(24) = obj.Jaggedness();      % 计算粗糙读

cvScore(25) = obj.NormalTest();      % 计算粗糙读
cvScore(26) = obj.SimpsonRule();

% 2024-09-18 新增
[cvScore(27),cvScore(28)] = obj.EntropySignal();  % 计算信号熵
[cvScore(29),cvScore(30)] = obj.Uniformity(20);   % 计算信号分布的均匀性
cvScore(31) = obj.Energy();                       % 计算信号的能量
[cvScore(32),cvScore(33),cvScore(34)] = obj.MeanIntensity();

warning off;
