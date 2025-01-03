function obj = W_star(obj)

% 计算权重系数 W*
% 计算时，nComp 的数目可以选择，不一定是全部的成分

if obj.nComp == 0,return;end

obj.matWstar = zeros(obj.nVariable,obj.nComp);

I = eye(obj.nVariable,obj.nVariable);
for h = 1:obj.nComp
    obj.matWstar(:,h) = obj.matBasisX(:,h);
    if h == 1
        Wh = I - obj.matBasisX(:,h) * obj.matLoadingX(:,h)';
    else
        obj.matWstar(:,h) = Wh * obj.matWstar(:,h); % Wh-1
        Wh = Wh - Wh * obj.matBasisX(:,h) * obj.matLoadingX(:,h)'; % Wh
    end    
end

clear h Wh I;