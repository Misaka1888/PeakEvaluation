function dbRatio = SimpsonRule(obj)

cvPI = conv(obj.cvPI,[1/6;2/3;1/6],'same'); % 平滑

iLeft = find(sign(diff(cvPI(1:obj.iPosMax)))==-1,1,'last');
if isempty(iLeft),iLeft = 0;end
iLeft = iLeft + 1;

iRight = find(sign(diff(cvPI(obj.iPosMax:end)))==1,1,'first');
if isempty(iRight)
    iRight = length(cvPI);
else
    iRight = obj.iPosMax + iRight;
end

% 根据 Simpson's rule 计算的峰面积
dbArea = (iRight - iLeft + 1)*(obj.cvPI(iLeft)+4*obj.dbMax+obj.cvPI(iRight))/6;

dbRatio = -log10(abs(dbArea-sum(obj.cvPI))/dbArea);
if dbRatio>3,dbRatio=3;end
if isinf(dbRatio),dbRatio = 3;end

clear cvPI dbMax iLeft iRight dbArea;