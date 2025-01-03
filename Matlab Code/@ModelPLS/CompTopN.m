function obj = CompTopN(obj,nComp,bQ2Y)

if ~exist('bQ2Y','var'),  bQ2Y  = 1; end % 是否计算 Q2Y
if ~exist('nComp','var'), nComp = 1; end

% 先清理数据
obj = ModelReset(obj);

% 数据赋值
obj.matResX = obj.matRawX;
obj.matResY = obj.matRawY;

if nComp>min(obj.nSample,obj.nVariable)
    disp('too Big nComp');
    return;
end

for i=1:nComp
    obj = CompNext(obj,bQ2Y);
end

clear i;