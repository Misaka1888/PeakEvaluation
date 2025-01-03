function obj = R2Y(obj)
if obj.nComp<=0,return;end

obj.cvR2Y = zeros(obj.nComp,1);
for i=1:obj.nComp
    YRecon = obj.matScoreX(:,i) * obj.matLoadingY(:,i)';
    obj.cvR2Y(i) = sum(sum(YRecon.*YRecon)) / obj.dbTotalVarY;
end

clear YRecon i;