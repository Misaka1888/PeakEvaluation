classdef ModelPLS < handle

    properties
        strType = 'book'; % 按王惠文书上的公式分解, 'matlab' 表示matlab自带公式
        nFold   = 7;  % 计算 Q2 时的交叉折数
        isZeroMeanX = 1; % 是否对 X 进行中心化

        % 以下模型初始化时，会自动计算
        matRawX = []; % 原始的中心化后的 Y 矩阵
        matRawY = []; % 原始的中心化后的 Y 矩阵
        rvMeanX = []; % X 均值矢量，若 matResX 没有预处理，rvMeanX 为 0 矢量        
        rvMeanY = []; % Y 均值矢量

        nSample     = 0; % 样本数 (matRes 的行数)
        nVariable   = 0; % 变量数 (matRes 的列数)
        nDimY       = 0; % Y 的变量数(列数)
        dbTotalVarX = 0;
        dbTotalVarY = 0;        

        % 以下改变成分数时，会自动计算更新
        nComp       = 0;  % 成分个数
        matResX     = []; % 残差，matResX 初始值为输入数据
        matResY     = []; % 残差，matResY 初始值为输入数据        
        matScoreX   = []; % X得分矩阵        
        matLoadingX = []; % X负载矩阵        
        matBasisX   = []; % W

        matScoreY   = []; % Y得分矩阵        
        matLoadingY = []; % Y负载矩阵
        matBasisY   = []; % Y分解的基

        cvR2X    = []; % R2X
        cvR2Y    = []; % R2Y
        cvQ2Y    = []; % Q2Y
        cvQ2Ycum = [];
       
        % 以下改变成分数时，需要手动计算更新
        matWstar    = []; % W*,
        matBeta     = []; % 不考虑均值影响：Y = X * Beta + E
        matBetaExt  = []; % 考虑 X 的均值和 Y 均值在内的，Y = X * BetaExt + E
        cvVIP       = [];
    end
    
    methods       
        function obj = ModelPLS(matX,matY,isZeroMeanX,strType) % 构造函数

            % 如果矩阵X中包含复数，则不计算
            if ~isreal(matX) || ~isreal(matY)
                disp('只能对实矩阵进行标准化，Not Real Matrix Input!')
                return;
            end

            % 如果 matRes 是空矩阵，则返回
            if isempty(matX) || isempty(matY)
                disp('Warning: Input zero matrix!')
                return;
            end
            
            if size(matX,1)~= size(matY,1)
                disp('Warning: Sample number dismatch!')
                return;
            end
            
            % PLS 分解算法选择
            if ~exist('strType','var')
                obj.strType ='book'; % 按王惠文书上的公式分解
            else
                obj.strType = lower(strType);
            end
            if isequal(lower(obj.strType),'book')
                obj.strType = 'book';
            else
                obj.strType = 'matlab';  % matlab 自带的函数
            end

            if ~exist('isZeroMeanX','var')
                obj.isZeroMeanX = 1;
            else
                obj.isZeroMeanX = isZeroMeanX;
            end
            
            [obj.nSample,obj.nVariable] = size(matX);
            if obj.isZeroMeanX==1      % X 可以不中心化
                obj.rvMeanX = mean(matX,1);
                obj.matRawX = matX - repmat(obj.rvMeanX,obj.nSample,1);
            else
                obj.matRawX = matX;
            end
            obj.nDimY   = size(matY,2); % Y 一定要中心化
            obj.rvMeanY = mean(matY,1);
            obj.matRawY = matY - repmat(obj.rvMeanY,obj.nSample,1); 

            obj.dbTotalVarX = sum(sum(obj.matRawX .* obj.matRawX)); % 计算 X 总方差
            obj.dbTotalVarY = sum(sum(obj.matRawY .* obj.matRawY)); % 计算 Y 总方差
        end
    end
    methods(Access=private)  % 声明为私有函数, 内部调用
        obj = ModelReset(obj);  % 改变 X, Y 数据、或者改变 X 的中心化时，清晰数据
        obj = ModelChange(obj); % 改变 X, Y 数据、或者改变 X 的中心化时，清晰数据
    end

    methods(Static) % 静态方法的访问，不管是类内还是其它地方，均用 [] = ModelPLS.pls_book()
        [XS,XL,YL,XRes,YRes,W,C] = pls_book(X,Y,nComp);
        [XS,XL,YL,XRes,YRes,W,C] = pls_matlab(X,Y,nComp);
        result = MeanCenter(X);
    end

    % 单独文件实现的方法：
    methods  % 先声明一个方法(函数)，不能在前面加 function
        obj = CompTopN(obj,nComp,bQ2Y) % 计算前 nComp 个PCs
        obj = CompNext(obj,bQ2Y);      % 计算下一个成分        
        obj = CompAutoFit(obj);        % 根据最小比例，自适应计算成分

        obj = R2X(obj);
        obj = R2Y(obj);
        
        obj = VIP(obj);
        obj = W_star(obj);
        obj = Beta(obj);

        dbQ2Y = Q2Y(obj,nComp);        
        dbQ2Y = Q2Y_Next(obj);   % 计算下一个成分的 Q2Y
        obj   = Q2Ycum(obj);

        [matPreY0,matPreY]    = PredictY(obj,matNewX);
        [matXScore,matXRecon] = PredictX(obj,matNewX);

        [cvDModX,cvDModY,cvDModX_adj,cvDModY_adj] = DistanceToModel(obj);% 计算样本到模型的距离
    end
end