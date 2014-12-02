function [output] = matchStoragetoCity(cities, storage_open, distances)
output = cell(length(cities),1);
for i = 1:length(cities)
    short_dist = 9999999999;
    for j = 1:length(storage_open)
        distance = distances(cities(i),storage_open(j));
        %distance = findStorage2CityDist(char(storageNamesInUse(storage_open(j))),cities{i});
        if (distance < short_dist)
            short_dist = distance;
            closest_storage = char(storageNamesInUse(storage_open(j)));
        end
        output{i} = closest_storage;
    end
end
end