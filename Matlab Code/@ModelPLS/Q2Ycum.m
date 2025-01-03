function obj = Q2Ycum(obj)
% 计算 obj.cvQ2Ycum
if obj.nComp == 1
    obj.cvQ2Ycum(1) = obj.cvQ2Y(1);
else
    cvTemQ = zeros(obj.nComp,1);
    cvTemQ(1) = 1- obj.cvQ2Y(1);
    for i=2:obj.nComp
        cvTemQ(i) = cvTemQ(i-1) * (1 - obj.cvQ2Y(i));
    end
    obj.cvQ2Ycum = 1 - cvTemQ;
    clear cvTemQ i;
end