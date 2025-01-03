function dbModality = Modality(obj, dbBaseline)

%' Compute modality scores for transition peaks in a peak group of class peakObj.
%'
% Modality score is defined as the largest unexpected dip in the peak, normalized
% by peak height. For high quality peaks, the modality score is expected
% to be close to 0.
%'
%' @param peak A peak group of class peakObj
%' @param flatness.factor A numeric parameter between 0 and 1 that determines
% the sensitivity of the modality score to low levels of noise. To avoid high
% modality scores due to small levels of noise, near-flat ranges in the peak
% are artificially flattened before calculating the modality score. A range
% is defined as near-flat and thus flattened when the difference between 
% intensities of adjacent time points is smaller than flatness.factor times
% the peak maximum intensity.
%'
%' @return A list with the following objects:
%'               r.modality: A numeric vector of modality scores for each
% transition in the peak group.
%'               peak.modality: Mean of the r.modality vector. This score
% represents the overall modality of all the transitions in the peak group.
%' @export
%'
%' @examples
%'
%' peak <- data.CSF$data$PeakGroup[[196]]
%' peak.group.modality <- CalculateModality(peak)
%' PlotChromPeak(peak,transition.list = c("y6","y8"))

if nargin < 2
    dbBaseline = 0.01;
end

diff_sig = diff(obj.cvPI); % 计算差分

% 将低于 dbBaseline * peak_max 的差值设为 0
diff_sig(abs(diff_sig) < dbBaseline * obj.dbMax) = 0;

first_fall = find(diff_sig < 0, 1, 'first');
last_rise = find(diff_sig > 0, 1, 'last');

if isempty(first_fall)
    first_fall = obj.nPoint + 1;
end

if isempty(last_rise)
    last_rise = -1;
end

if first_fall < last_rise
    max_dip = max(abs(diff_sig(first_fall:last_rise)));
else
    % max_dip = 0; % 大部分为 0 ，所以改成以下这句 ---- 2024-08-23
    max_dip = max(abs(diff_sig));
end

dbModality = max_dip / obj.dbMax;

clear diff_sig first_fall last_rise max_dip;