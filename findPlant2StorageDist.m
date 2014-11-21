function [dist] = findPlant2StorageDist(plant,storage)
    j = -1;
    k = -1;
    [~,~, processing2storage_dist] = xlsread('StaticData','P2S','B2:K72');
    processing2storage_dist = cell2mat(cellNaNReplace(processing2storage_dist,0)); 
    [~,~, storage_units] = xlsread('StaticData','P2S','A2:A72');
    [~,~, processing_units] = xlsread('StaticData','P2S','B1:K1');
    for i = 1:length(processing_units)
        if strcmp(processing_units(i), plant)
            j = i;   
        end
    end
    for i = 1:length(storage_units)
        if strcmp(storage_units(i), storage)
            k = i;   
        end
    end
    dist = processing2storage_dist(k,j);
end