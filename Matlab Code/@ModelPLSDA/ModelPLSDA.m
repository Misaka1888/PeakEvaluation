classdef ModelPLSDA < ModelPLS & handle

    properties
        cvMarker     = [];
        cvIndexClass = [];
    end

    methods % 定义构造函数
        function obj = ModelPLSDA(matX,cvIndexClass,isZeroMeanX,strType)
            
            if ~exist('strType','var')
                strType ='book'; % 按王惠文书上的公式分解
            else
                strType = lower(strType);
            end
            if isequal(lower(strType),'book')
                strType = 'book';
            else
                strType = 'matlab';  % matlab 自带的函数
            end
            if ~exist('isZeroMeanX','var'), isZeroMeanX = 1; end

            obj = obj@ModelPLS(matX,cvIndexClass,isZeroMeanX,strType);

            if size(cvIndexClass,2)~=1
                disp('For Class Index Only');
                return;
            end

            [obj.cvMarker,~,obj.cvIndexClass] = unique(cvIndexClass);
            obj.nDimY = length(obj.cvMarker);
            obj.matRawY = zeros(obj.nSample,obj.nDimY);
            for i=1:obj.nDimY
                obj.matRawY(obj.cvIndexClass==i,i) = 1;
            end
            obj.rvMeanY = mean(obj.matRawY,1);
            obj.matRawY = obj.matRawY - repmat(obj.rvMeanY,obj.nSample,1);

            obj.dbTotalVarY = sum(sum(obj.matRawY.*obj.matRawY));
        end
    end
    methods(Static=true)
        [cvCorr,cvR2Y_PT,cvQ2Y_PT,cvIntercept,cvSlop] = PermutationTest(matX,cvIndexClass,nComp,nPerm,nFold);
    end
end