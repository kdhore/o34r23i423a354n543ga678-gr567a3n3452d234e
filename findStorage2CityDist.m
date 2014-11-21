function [dist] = findStorage2CityDist(storage,city,storage_units,cities,storage2market_dist)
    j = -1;
    k = -1;
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