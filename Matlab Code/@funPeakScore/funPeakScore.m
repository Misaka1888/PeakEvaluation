classdef funPeakScore < handle
    % 峰型得分函数类
    properties
        cvPI;   % peak intensity 数据
        cvRT;   % peak time
        nPoint; % 峰的数据点数
        nPointPad;

        cvPaddingPI;
        cvSmoothPI;
        cvNormMaxPI;
        cvNormSumPI;

        dbMax;
        dbMin;
        dbMean;
        dbStd;
        dbSum;

        iPosMax;
    end

    methods
        function obj = funPeakScore(cvPI,cvRT,nPoint)
            if ~exist('cvRT','var'),  cvRT   = []; end
            if ~exist('nPoint','var'),nPoint = -1; end
            
            obj.cvPI = cvPI;
            
            if nPoint == -1
                obj.nPoint = length(cvPI);
            else
                obj.nPoint = nPoint;
            end
            
            if ~isempty(cvRT)
                obj.cvRT = cvRT;
            else
                obj.cvRT = (1:obj.nPoint)';
            end
            obj.cvPI = reshape(cvPI,obj.nPoint,1);
            obj.cvRT = reshape(obj.cvRT,obj.nPoint,1);

            obj.cvPI(obj.cvPI<0.0001) = 0.0001; % 最低值

            [obj.dbMax,obj.iPosMax] = max(obj.cvPI);
            obj.dbMin  = min(obj.cvPI(obj.cvPI>0.0001));
            obj.dbMean = mean(obj.cvPI(obj.cvPI>0.001));
            obj.dbStd  = std(obj.cvPI(obj.cvPI>0.001));
            obj.dbSum  = sum(obj.cvPI);
            
            obj.cvSmoothPI  = conv(obj.cvPI,ones(3,1)/3,'same');
            obj.cvNormMaxPI = obj.cvPI/obj.dbMax;
            obj.cvNormSumPI = obj.cvPI/obj.dbSum;

            [obj.nPointPad,idx] = max(2*[obj.nPoint-obj.iPosMax+1,obj.iPosMax]);
            obj.cvPaddingPI = zeros(obj.nPointPad,1);
            if idx==1
                obj.cvPaddingPI(1:nPoint) = obj.cvNormSumPI;
            else
                obj.cvPaddingPI((obj.nPointPad-obj.nPoint+1):obj.nPointPad) = obj.cvNormSumPI;
            end
            clear idx;
        end
    end

    methods
        cvFitPI = GaussianFit(obj);    % 对 ROI 数据进行高斯拟合

        % 以下是 ROI 的峰形判断指标
        [dbSNR,dbCV,dbABRatio] = SNR_CV_ABRatio(obj);% Peak 信噪比\变异系数\计算峰顶Apex和峰沿 Boundray 的比例
        
        dbSymmetry = Symmetry(obj);       % 计算对称性
        dbGaussSim = GaussSimilar(obj);   % 计算高斯拟合前后的相似性。
        dbTPASR    = TPASR(obj);          % 计算三角形和实际峰面积的比，胖瘦程度        
        
        [dbFWHM,dbFWHM2Base] = FWHM(obj); % 计算半高宽

        dbJaggedness = Jaggedness(obj,dbBaseline); % 计算粗糙度
        [dbZZ,dbDeltaZZ] = Zigzag(obj); % 计算平滑前后的Zigzag差
        dbPCC_Smooth    = PCC_Smooth(obj);  % 计算平滑前后的相关系数        
        dbSharpness     = Sharpness(obj);   % 计算陡峭程度

        % 时域统计特征
        dbSkewness = Skewness(obj); % 偏度
        dbKurtosis = Kurtosis(obj); % 峰度
        dbRMS      = RMS(obj);      % 计算 root-mean-square 均方误差
        dbSlope_ecdf = Slope_ecdf(obj); % 计算经验分布函数斜率

        % 频域统计特征
        [dbMeanFFT,dbStdFFT]         = FFT_Stat(obj);     % 计算傅里叶变换系数的均值和标准差
        [dbMeanWavelet,dbStdWavelet] = Wavelet_Stat(obj); % 计算小波变换的绝对均值和标准差

        % 计算基于时域的时序特征
        cvAutoCorr      = AutoCorrelation(obj); % 自相关函数
        dbCentroidRatio = CentroidRatio(obj);   % 质心与中心的比
        dbMean2Diff     = Mean2Diff(obj);       % 计算差分均值 与 均值 之比
        dbEntropy       = Entropy(obj);         % 计算信号分布的熵

        [dbEntropySignal,dbEntropyStd] = EntropySignal(obj);     % 计算信号的熵        
        [dbUniformity,dbUniformityStd] = Uniformity(obj,nBin); % 计算信号分布的均匀性
        [dbMean,dbMedian,dbMAE]        = MeanIntensity(obj);

        dbEnergy   = Energy(obj);          % 计算信号的能量
        dbModality = Modality(obj, dbBaseline); % 计算模态

        qScore = NormalTest(obj); % 正态性检验
        dbRatio = SimpsonRule(obj); % 根据 Simpson's rule 计算的峰面积与峰高总和的比例

        [cvScore,nScore] = AllScore(obj);    % 一次行计算所有的 score
    end
end