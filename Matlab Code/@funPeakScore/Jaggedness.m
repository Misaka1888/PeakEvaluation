function dbJaggedness = Jaggedness(obj,dbBaseline)

% 计算 ROI (peak) 的起伏次数，变号次数，粗糙度，越小越好
% Captures shape quality by calculating the number of changes in direction over length of intensity vector


if ~exist('dbBaseline','var'),dbBaseline = 0.001;end

% changes in the sign of differential of the peak is used to quantify the jaggedness of the peak
diff_sig = diff(obj.cvPI);

% the near-flat ranges of peak are assumed to be flat
diff_sig(abs(diff_sig) < dbBaseline * obj.dbMax) = 0;

% jaggedness is calculated
dbJaggedness = (sum(abs(diff(sign(diff_sig))) > 1) - 1) / (length(diff_sig) - 1);

% if jaggedness is negative return zero
% dbJaggedness = max(0, dbJaggedness);  % *** 太多 0 了，改成以下这句 2024-08-23

dbJaggedness = abs(dbJaggedness);

clear diff_sig;
