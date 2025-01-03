function [dbEntropySignal,dbEntropyStd] = EntropySignal(obj)

dbEntropySignal = -1.0 * sum(obj.cvNormSumPI.*log2(obj.cvNormSumPI));

cvPI   = obj.cvNormSumPI/obj.nPoint;
dbEntropyStd = -1.0 * sum(cvPI.*log2(cvPI));

clear cvPI;