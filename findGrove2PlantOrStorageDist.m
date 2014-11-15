function [dist] = findGrove2PlantOrStorageDist(grove,endpoint)
    j = -1;
    k = -1;
    [~,~, grove2processing_storage_dist] = xlsread('StaticData','G2PS','B2:E82');
    grove2processing_storage_dist = cell2mat(cellNaNReplace(grove2processing_storage_dist,0)); 
    [~,~, processing_and_storage_values] = xlsread('StaticData','G2PS','A2:A82');
    [~,~, grove_names] = xlsread('StaticData','G2PS','B1:E1');
    for i = 1:length(grove_names)
        if strcmp(grove_names(i), grove)
            j = i;   
        end
    end
    for i = 1:length(processing_and_storage_values)
        if strcmp(processing_and_storage_values(i), endpoint)
            k = i;   
        end
    end
    dist = distdim(grove2processing_storage_dist(j,k),'km','mi');
end