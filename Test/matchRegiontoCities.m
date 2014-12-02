function [cities] = matchRegiontoCities(region)
if strcmp(region, 'NE')
    cities = {'ANY';'BOS';'CLP';'KEE';'LAK';'MBK';'MVY';'PGH';'PHI';'PVD';'RER';'SCR';'SMS';'SUP'};
elseif strcmp(region, 'MA')
    cities = {'CRS';'CVE';'CWV';'DTN';'FRY';'HIP';'JTC';'LXK';'MAO';'MAY';'MSD';'MSP';'MTH';'RCH';'RRN';'SHK';'TIL'};
elseif strcmp(region, 'SE')
    cities = {'CHR';'DAY';'FPR';'FSC';'GRN';'HVA';'JFL';'MTG';'OCL';'PAN';'WPB';'YEM'};
elseif strcmp(region, 'MW')
    cities = {'ABL';'BYO';'CED';'CUP';'ELK';'FWA';'GBW';'GEE';'GFK';'HER';'JAC';'LSL';'MAS';'MND';'NLW';'OWT';'SDL';'SHL';'SJF';'STP';'SWI';'TRV'};
elseif strcmp(region, 'DS')
    cities = {'BST';'DEL';'ELP';'FTW';'GRL';'LAF';'LRO';'MCX';'MKO';'MRE';'PRA';'RSW';'SGE';'SME';'SNA';'TYE'};
elseif strcmp(region, 'NW')
    cities = {'BTT';'DIM';'EUG';'LEW';'PCO';'RSP';'TWF';'YKM'};
elseif strcmp(region, 'SW')
    cities = {'BKR';'DOZ';'FSO';'GRU';'HUL';'LOS';'RFE';'RNE';'SCM';'SFC';'TCY'};
else
    display('region not inputted correctly');
end
end