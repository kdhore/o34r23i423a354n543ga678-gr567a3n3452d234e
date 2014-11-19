function [ region ] = getRegion( city )
%Returns region of city
if sum(strcomp(city,{'ANY';'BOS';'CLP';'KEE';'LAK';'MBK';'MVY';'PGH';'PHI';'PVD';'RER';'SCR';'SMS';'SUP'})) == 1
    region = 1;
end
if sum(strcomp(city,{'CRS';'CVE';'CWV';'DTN';'FRY';'HIP';'JTC';'LXK';'MAO';'MAY';'MSD';'MSP';'MTH';'RCH';'RRN';'SHK';'TIL'})) == 1
    region = 2;
end
if sum(strcomp(city,{'CRS';'CVE';'CWV';'DTN';'FRY';'HIP';'JTC';'LXK';'MAO';'MAY';'MSD';'MSP';'MTH';'RCH';'RRN';'SHK';'TIL'})) == 1
    region = 2;
end

end

