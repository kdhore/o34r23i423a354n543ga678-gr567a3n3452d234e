%This is the objective function for processing plant shipping to storages
%(POJ or FCOJ)
function [f] = cost_obj_func(x, grove_plant_cost, grove_storage_cost,...
    plant_storage_cost, numPlantsOpen, numStorOpen, ORA_arr_futures, mean_grove_prices)

% let x be like the excel spreadsheet: groves as rows and then columns are
% as follows: first POJ shipped to processing plant-storage (go through
% processing plants first), then FCOJ shipped to processing plant-storage
% (through plants first), then ORA to each storage unit
% i.e. three matrices concatenated

% grove_plant_cost is unit trans cost from each grove to each open plant
% (groves as rows)
% grove_storage_cost is unit trans cost from each grove to each open
% storage unit
% plant_storage_cost is unit trans cost from plant to storage
matrixLength = numPlantsOpen*numStorOpen;
poj_cost = zeros(6,1);
fcoj_cost = zeros(6,1);
for i = 1:numPlantsOpen
    for j = 1:numStorOpen
        poj_cost = poj_cost + grove_plant_cost(:,i).*x(:,numStorOpen*(i-1)+j)...
            + plant_storage_cost(i,j)*x(:,numStorOpen*(i-1)+j);
        fcoj_cost = fcoj_cost + ...
            grove_plant_cost(:,i).*x(:,matrixLength + numStorOpen*(i-1)+j)...
            + plant_storage_cost(i,j)*x(:,matrixLength + numStorOpen*(i-1)+j);
    end
end
% dont count the cost of purchase (grove price) for the futures
ora_cost = zeros(6,1);
for i = 1:numStorOpen
    ora_cost = ora_cost + grove_storage_cost(:,i).*x(:,matrixLength*2+i);
    %ora_cost(2:6) = ora_cost(2:6) + grove_storage_cost(2:6,i).*x(2:6,matrixLength*2+i);
    %ora_cost(1) = ora_cost(1) + grove_storage_cost(1,i).*(x(1,matrixLength*2+i)-ORA_arr_futures)...
    %    + ORA_arr_futures*(grove_storage_cost(1,i)-mean_grove_prices(1));
end

f = sum(fcoj_cost) + sum(poj_cost) + sum(ora_cost); %+ purchase_cost;

end

