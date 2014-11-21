function [ region, region_ind ] = matchCitytoRegion( city )
%Returns region of city
if sum(strcmp(city,{'ANY';'BOS';'CLP';'KEE';'LAK';'MBK';'MVY';'PGH';'PHI';'PVD';'RER';'SCR';'SMS';'SUP'})) == 1
    region = 'NE';
    region_ind = 1;
end
if sum(strcmp(city,{'CRS';'CVE';'CWV';'DTN';'FRY';'HIP';'JTC';'LXK';'MAO';'MAY';'MSD';'MSP';'MTH';'RCH';'RRN';'SHK';'TIL'})) == 1
    region = 'MA';
    region_ind = 2;
end
if sum(strcmp(city,{'CHR';'DAY';'FPR';'FSC';'GRN';'HVA';'JFL';'MTG';'OCL';'PAN';'WPB';'YEM'})) == 1
    region = 'SE';
    region_ind = 3;
end
if sum(strcmp(city,{'ABL';'BYO';'CED';'CUP';'ELK';'FWA';'GBW';'GEE';'GFK';'HER';'JAC';'LSL';'MAS';'MND';'NLW';'OWT';'SDL';'SHL';'SJF';'STP';'SWI';'TRV'})) == 1
    region = 'MW';
    region_ind = 4;
end
if sum(strcmp(city,{'BST';'DEL';'ELP';'FTW';'GRL';'LAF';'LRO';'MCX';'MKO';'MRE';'PRA';'RSW';'SGE';'SME';'SNA';'TYE'})) == 1
    region = 'DS';
    region_ind = 5;
end
if sum(strcmp(city,{'BTT';'DIM';'EUG';'LEW';'PCO';'RSP';'TWF';'YKM'})) == 1
    region = 'NW';
    region_ind = 6;
end
if sum(strcmp(city,{'BKR';'DOZ';'FSO';'GRU';'HUL';'LOS';'RFE';'RNE';'SCM';'SFC';'TCY'})) == 1
    region = 'SW';
    region_ind = 7;
end
end

