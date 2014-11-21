function [ output ] = matchCitiestoStorage( storage_open, bam )
cities = {'ANY';'BOS';'CLP';'KEE';'LAK';'MBK';'MVY';'PGH';'PHI';'PVD';'RER';'SCR';'SMS';'SUP';'CRS';'CVE';...
    'CWV';'DTN';'FRY';'HIP';'JTC';'LXK';'MAO';'MAY';'MSD';'MSP';'MTH';'RCH';'RRN';'SHK';'TIL';'CHR';...
    'DAY';'FPR';'FSC';'GRN';'HVA';'JFL';'MTG';'OCL';'PAN';'WPB';'YEM';'ABL';'BYO';'CED';'CUP';'ELK';...
    'FWA';'GBW';'GEE';'GFK';'HER';'JAC';'LSL';'MAS';'MND';'NLW';'OWT';'SDL';'SHL';'SJF';'STP';'SWI';...
    'TRV';'BST';'DEL';'ELP';'FTW';'GRL';'LAF';'LRO';'MCX';'MKO';'MRE';'PRA';'RSW';'SGE';'SME';'SNA';...
    'TYE';'BTT';'DIM';'EUG';'LEW';'PCO';'RSP';'TWF';'YKM';'BKR';'DOZ';'FSO';'GRU';'HUL';'LOS';'RFE';...
    'RNE';'SCM';'SFC';'TCY'};
output = cell(100,3);
for i = 1:numel(cities)
    output{i,1} = cities{i};
    closest_storage = '';
    short_dist = 9999999999;
    for j = 1:length(storage_open)
        distance = cell2mat(bam(i, storage_open(j)));
        if (distance(1) < short_dist)
            short_dist = distance(1);
            closest_storage = char(storageNamesInUse(storage_open(j)));
        end
        output{i,2} = closest_storage;
        output{i,3} = short_dist;
    end
end

end

