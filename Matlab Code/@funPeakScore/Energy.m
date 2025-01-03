function dbEnergy = Energy(obj)

dbEnergy = sum(obj.cvNormSumPI.*obj.cvNormSumPI);
%dbEnergy = sum(obj.cvNormMaxPI.*obj.cvNormMaxPI)/obj.nPoint; % 这个会降低性能