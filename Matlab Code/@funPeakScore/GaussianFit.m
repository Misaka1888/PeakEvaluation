function cvFitPI = GaussianFit(obj)

% 对 ROI 进行高斯拟合

fGaussFit = fit(obj.cvRT, obj.cvPI, 'gauss1','StartPoint',[],...
    'Lower',[0,0,0],'Upper',[obj.dbMax,obj.cvRT(end),obj.cvRT(end)]);
cvFitPI   = fGaussFit(obj.cvRT);

clear fGaussFit;