function dbCentroidRatio = CentroidRatio(obj)

% 计算质心与中心的比
dbCentroidRatio = sum(obj.cvRT .* obj.cvNormSumPI)/mean(obj.cvRT);
if dbCentroidRatio>0
    dbCentroidRatio = log10(dbCentroidRatio);
end