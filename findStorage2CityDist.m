function [dist] = findStorage2CityDist(storage,city)
    j = -1;
    k = -1;
    [~,~, storage2market_dist] = xlsread('StaticData','S2M','C2:BU101');
    storage2market_dist = cell2mat(cellNaNReplace(storage2market_dist,0)); 
    [~,~, cities] = xlsread('StaticData','S2M','B2:B101');
    [~,~, storage_units] = xlsread('StaticData','P2S','A2:A72');
    for i = 1:length(storage_units)
        if strcmp(storage_units(i), storage)
            j = i;   
        end
    end
    for i = 1:length(cities)
        if strcmp(cities(i), city)
            k = i;   
        end
    end
    dist = storage2market_dist(k,j);
end