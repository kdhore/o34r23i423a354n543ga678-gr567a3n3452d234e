%This is the objective function for processing plant shipping to storages
%(POJ or FCOJ)
function [f] = proc_plant_ship_network(x, procStorageDist)


%procStorageDist #plants x #storages
%x -- #plants x #storages


f = sum(sum(x.*procStorageDist));
%objective function is the product of each of the decisions (aka
%the amount to allocate to each place) by the distance to each
%respective storage unit from each processing plant

end

