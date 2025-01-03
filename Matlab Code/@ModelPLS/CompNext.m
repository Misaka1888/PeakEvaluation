function obj = CompNext(obj,bQ2Y)

% 计算下一个成分 

% [XS,XL,YL,XRes,YRes,W,C]

% 输入
%  matX        数据矩阵 X
%  matY        类别矩阵 Y
%  nComp       成分个数
%  strType     PLS算法类型：缺省为王惠文书上的算法，'matlab'表示matlab自带算法

if ~exist('bQ2Y','var'), bQ2Y=1; end % 是否计算 Q2Y

if obj.nComp == min(obj.nSample,obj.nVariable)
    disp('too Big nComp');
    return;
end

if isempty(obj.matResX) % 尚未开始计算 component
    obj.matResX = obj.matRawX;
    obj.matResY = obj.matRawY;
end

if bQ2Y==1
    dbQ2Y = Q2Y_Next(obj);
    obj.cvQ2Y = [obj.cvQ2Y;dbQ2Y];
    clear dbQ2Y;
end

if isequal(obj.strType,'matlab')
    [cvScoreX,cvLoadingX,cvLoadingY,obj.matResX,obj.matResY,...
        cvBasisX,cvBasisY] = ModelPLS.pls_matlab(obj.matResX,obj.matResY,1);    
else
    [cvScoreX,cvLoadingX,cvLoadingY,obj.matResX,obj.matResY,...
        cvBasisX,cvBasisY] = ModelPLS.pls_book(obj.matResX,obj.matResY,1);  
end

obj.nComp       = obj.nComp + 1;
obj.matScoreX   = [obj.matScoreX,cvScoreX];
obj.matLoadingX = [obj.matLoadingX,cvLoadingX];
obj.matLoadingY = [obj.matLoadingY,cvLoadingY];      
obj.matBasisX   = [obj.matBasisX,cvBasisX];
obj.matBasisY   = [obj.matBasisY,cvBasisY];

obj.matScoreY = obj.matScoreX * obj.matLoadingY';

clear cvScoreX cvLoadingX cvLoadingY cvBasisX cvBasisY;
end