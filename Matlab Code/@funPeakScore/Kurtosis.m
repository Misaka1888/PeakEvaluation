function dbKurtosis = Kurtosis(obj)

dbKurtosis = kurtosis(obj.cvPI);

if dbKurtosis > 0
    dbKurtosis = log10(dbKurtosis);
end