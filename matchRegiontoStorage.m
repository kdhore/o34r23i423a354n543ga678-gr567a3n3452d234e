function [storage] = matchRegiontoStorage(region,OJgameobj)
    storage_open = find(OJgameobj.storage_cap);
    cities = matchRegiontoCities(region);
    storageFacilities = matchStoragetoCity(cities, storage_open);
    [storages, ~, indices] = unique(storageFacilities);
    numOfEachStorage = accumarray(indices(:),1);
    [~, index] = max(numOfEachStorage);
    storage = storages(index);        
end