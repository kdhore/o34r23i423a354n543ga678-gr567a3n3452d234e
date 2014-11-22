function [storage] = matchRegiontoStorage(region,OJgameobj,distances)
    storage_open = find(OJgameobj.storage_cap);
    if strcmp(region, 'NE')
        cities = [1:14];
    elseif strcmp(region, 'MA')
        cities = [15:31];
    elseif strcmp(region, 'SE')
        cities = [32:43];
    elseif strcmp(region, 'MW')
        cities = [44:65];
    elseif strcmp(region, 'DS')
        cities = [66:81];
    elseif strcmp(region, 'NW')
        cities = [82:89];
    elseif strcmp(region, 'SW')
        cities = [90:100];
    else
        display('region not inputted correctly');
    end
    storageFacilities = matchStoragetoCity(cities, storage_open, distances);
    [storages, ~, indices] = unique(storageFacilities);
    numOfEachStorage = accumarray(indices(:),1);
    [~, index] = max(numOfEachStorage);
    storage = storages(index);        
end