function obj = R2X(obj)
if obj.nComp<=0,return;end

obj.cvR2X = zeros(obj.nComp,1);
for i=1:obj.nComp
    XRecon = obj.matScoreX(:,i) * obj.matLoadingX(:,i)';
    obj.cvR2X = sum(sum(XRecon.*XRecon)) / obj.dbTotalVarX;
end
clear XRecon i;