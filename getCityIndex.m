function [ index ] = getCityIndex(city)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
cities = {'ANY';'BOS';'CLP';'KEE';'LAK';'MBK';'MVY';'PGH';'PHI';'PVD';'RER';'SCR';'SMS';'SUP';'CRS';'CVE';'CWV';'DTN';'FRY';'HIP';'JTC';'LXK';'MAO';'MAY';'MSD';'MSP';'MTH';'RCH';'RRN';'SHK';'TIL';'CHR';'DAY';'FPR';'FSC';'GRN';'HVA';'JFL';'MTG';'OCL';'PAN';'WPB';'YEM';'ABL';'BYO';'CED';'CUP';'ELK';'FWA';'GBW';'GEE';'GFK';'HER';'JAC';'LSL';'MAS';'MND';'NLW';'OWT';'SDL';'SHL';'SJF';'STP';'SWI';'TRV';'BST';'DEL';'ELP';'FTW';'GRL';'LAF';'LRO';'MCX';'MKO';'MRE';'PRA';'RSW';'SGE';'SME';'SNA';'TYE';'BTT';'DIM';'EUG';'LEW';'PCO';'RSP';'TWF';'YKM';'BKR';'DOZ';'FSO';'GRU';'HUL';'LOS';'RFE';'RNE';'SCM';'SFC';'TCY'};
arr = find(strcmp(city,cities));
index = arr(1);

end

