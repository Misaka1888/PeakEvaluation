function [cvCorr,cvR2Y_PT,cvQ2Y_PT,cvIntercept,cvSlop] = PermutationTest(matX,cvIndexClass,nComp,nPerm,nFold)

cvR2Y_PT  = zeros(nPerm+1,1);
cvQ2Y_PT  = zeros(nPerm+1,1);
cvCorr = ones(nPerm+1,1);

nSample = size(matX,1);
T = ModelPLSDA(matX,cvIndexClass,1,'book');
T.nFold = nFold;
T.CompTopN(nComp,1);
T.R2Y();
T.Q2Ycum();
dbR2Y1 = sum(T.cvR2Y);
dbQ2Y1 = T.cvQ2Ycum(end);

for iPerm=1:nPerm
    
    % 产生随机置换矢量
    cvPermutation = randperm(nSample);
    
    % 计算置换后的相关系数，置换后的因子水平, 及类别
    matPermY = cvIndexClass(cvPermutation);
    cvCorr(iPerm)=abs(corr(cvIndexClass,matPermY)); % 打乱
    
    if cvCorr(iPerm)==1.0
        cvR2Y_PT(iPerm) = dbR2Y1;
        cvQ2Y_PT(iPerm) = dbQ2Y1;
        continue;
    else
        % 再计算R2，Q2
        T1 = ModelPLSDA(matX,matPermY,1,'book');
        T1.nFold = nFold;
        T1.CompTopN(nComp,1);
        T1.R2Y();
        T1.Q2Ycum();
        cvR2Y_PT(iPerm) = sum(T1.cvR2Y);
        cvQ2Y_PT(iPerm) = T1.cvQ2Ycum(end);
    end
    
    % 把整数部分去掉让 Q2 取值在(-1.0,1.0)之间
    if cvQ2Y_PT(iPerm)<-1.0
        cvQ2Y_PT(iPerm)=cvQ2Y_PT(iPerm)-ceil(cvQ2Y_PT(iPerm));
    elseif cvQ2Y_PT(iPerm)>1.0
        cvQ2Y_PT(iPerm)=cvQ2Y_PT(iPerm)-floor(cvQ2Y_PT(iPerm));
    else
        cvQ2Y_PT(iPerm)=cvQ2Y_PT(iPerm);
    end
end

cvR2Y_PT(end)  = dbR2Y1;
cvQ2Y_PT(end)  = dbQ2Y1;
cvCorr(end) = 1;

cvIntercept = [Intercept(cvCorr,cvR2Y_PT,dbR2Y1);Intercept(cvCorr,cvQ2Y_PT,dbQ2Y1)];
cvSlop      = [dbR2Y1;dbQ2Y1]-cvIntercept;

clear R2cum Q2cum matPermY cvPermutation nSample dbR2Y1 dbQ2Y1 XL YL W;


function dbA=Intercept(cvCorr,cvR2Q2,dbTrueR2Q2)
cvR2Q2(cvCorr==1)=[];
cvCorr(cvCorr==1)=[];
dbA = (sum(cvR2Q2) - dbTrueR2Q2* sum(cvCorr))/sum(1-cvCorr);