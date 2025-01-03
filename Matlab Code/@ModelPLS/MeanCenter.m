function result=MeanCenter(X)
%
%�÷���
%   result=MeanCenter(X)
%
%���룺
%   X��    ��������ÿһ��һ��������ÿһ��Ϊһ��������
%
%�����
%   result: ��С��X��ͬ�ľ���
%
%********************************************************************
result=[];

% �������X�ǿվ����������ʾ������
if isempty(X), return; end;

% �������X�а����������򲻼���
if isreal(X)==0
    disp('ֻ�ܶ�ʵ������б�׼����Not Real Matrix Input!')
    return
end

% ��ȡ����������
nSample=size(X,1);

% ���Ļ���ÿһ��Ԫ�ؼ�ȥ���е�ƽ��ֵ
result = X - repmat(mean(X,1),nSample,1);
% result = X - ones(nSample,1)*mean(X,1);

clear nSample;