function dbSlope_ecdf = Slope_ecdf(obj)
% 计算经验分布函数斜率

cvSlope_ecdf = gradient(ecdf(obj.cvPI), range(obj.cvPI)/numel(obj.cvPI));

% dbSlope_ecdf = cvSlope_ecdf(1);  %**** 大部分非常小，所以改成以下这句 2024-08-23

dbSlope_ecdf = abs(cvSlope_ecdf(1));
if dbSlope_ecdf > 0
    dbSlope_ecdf = -log(cvSlope_ecdf(1));
end

clear cvSlope_ecdf;