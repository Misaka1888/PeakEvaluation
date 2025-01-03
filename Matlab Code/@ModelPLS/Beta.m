function obj = Beta(obj)

if obj.nComp == 0,return;end

obj  = W_star(obj);

obj.matBeta = obj.matWstar * obj.matLoadingY';

if obj.nComp < 3  % 此处可能是 2
   obj.matBetaExt = [zeros(1,obj.nDimY); obj.matBeta];
else
    if isempty(obj.rvMeanX)
        obj.matBetaExt =[obj.rvMeanY; obj.matBeta];
    else
        obj.matBetaExt =[obj.rvMeanY - obj.rvMeanX * obj.matBeta; obj.matBeta];
    end
end