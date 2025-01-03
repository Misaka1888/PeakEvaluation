function obj = CompAutoFit(obj)

% 先清理数据
obj = ModelReset(obj);

% 数据赋值
obj.matResX = obj.matRawX;
obj.matResY = obj.matRawY;

nMaxComp = min(obj.nSample,obj.nVariable);
obj.cvQ2Y = zeros(nMaxComp,1);
for i=1:nMaxComp
    dbQ2Y = Q2Y_Next(obj);
    if dbQ2Y<=0,break;end

    obj.cvQ2Y(i) = dbQ2Y;
    obj = CompNext(obj,0);  % 不重复计算 Q2Y
end
obj.cvQ2Y(obj.nComp+1:end) = [];

clear i nMaxComp dbQ2Y;