%This is the objective function for processing plant shipping to storages
%(POJ or FCOJ)
function [f] = cost_obj_func_2(x, grove_plant_cost, grove_storage_cost,...
    plant_storage_cost, plants_open, stor_open, ORA_arr_futures, mean_grove_prices, percentroj, FCOJ_arr_futures, ojObject)

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
matrixLength = length(plants_open)*length(stor_open);
poj_cost = zeros(6,1);
fcoj_cost = zeros(6,1);
for i = 1:length(plants_open)
    for j = 1:length(stor_open)
        poj_cost = poj_cost + grove_plant_cost(:,i).*x(:,length(stor_open)*(i-1)+j)...
            + plant_storage_cost(plants_open(i),stor_open(j))*x(:,length(stor_open)*(i-1)+j);
        fcoj_cost = fcoj_cost + ...
            grove_plant_cost(:,i).*x(:,matrixLength + length(stor_open)*(i-1)+j)...
            + plant_storage_cost(plants_open(i),stor_open(j))*x(:,matrixLength + length(stor_open)*(i-1)+j);
    end
end
% dont count the cost of purchase (grove price) for the futures
ora_cost = zeros(6,1);
for i = 1:length(stor_open)
    ora_cost = ora_cost + grove_storage_cost(:,i).*x(:,matrixLength*2+i);
    %ora_cost(2:6) = ora_cost(2:6) + grove_storage_cost(2:6,i).*x(2:6,matrixLength*2+i);
    %ora_cost(1) = ora_cost(1) + grove_storage_cost(1,i).*(x(1,matrixLength*2+i)-ORA_arr_futures)...
    %    + ORA_arr_futures*(grove_storage_cost(1,i)-mean_grove_prices(1));
end

% manufacturing costs
poj_man_cost = 0;
for i = 1:matrixLength
    poj_man_cost = poj_man_cost + 2000*sum(x(:,i));
end

fcoj_man_cost = 0;
for i = matrixLength+1:2*matrixLength
    fcoj_man_cost = fcoj_man_cost + 1000*sum(x(:,i));    
end

fcoj_storage = zeros(1,numStorOpen);
for j = 1:numStorOpen
    temp_sum = 0;
    for i = 1:numPlantsOpen
        temp_sum = temp_sum + sum(x(:,lengthMatrix+j+(numStorOpen)*(i-1))); 
    end
    fcoj_storage(j) = sum(temp_sum);
end
fcoj_storage = fcoj_storage + FCOJ_arr_futures';

roj_man_cost = 0;
for i = 1:length(stor_open)
    roj_man_cost = roj_man_cost + 650*fcoj_storage(i)*percentroj(i)/100;
end

cost = sum(fcoj_cost) + sum(poj_cost) + sum(ora_cost) + fcoj_man_cost + poj_man_cost + roj_man_cost; 

demand_city_ORA = load('Demand Data/demand_city_ORA.mat');
dc_ora = genvarname('ORA_means_by_city');
demand_city_ORA = demand_city_ORA.(dc_ora);
demand_city_POJ = load('Demand Data/demand_city_POJ.mat');
dc_poj = genvarname('POJ_means_by_city');
demand_city_POJ = demand_city_POJ.(dc_poj);
demand_city_ROJ = load('Demand Data/demand_city_ROJ.mat');
dc_roj = genvarname('ROJ_means_by_city');
demand_city_ROJ = demand_city_ROJ.(dc_roj);
demand_city_FCOJ = load('Demand Data/demand_city_FCOJ.mat');
dc_fcoj = genvarname('FCOJ_means_by_city');
demand_city_FCOJ = demand_city_FCOJ.(dc_fcoj);

ORA_demand = zeros(length(stor_open),1);
POJ_demand = zeros(length(stor_open),1);
FCOJ_demand = zeros(length(stor_open),1);
ROJ_demand = zeros(length(stor_open),1);
cities_match_storage = matchCitiestoStorage(stor_open, storage2market.(s2m));
%decisions = YearDataforDecisions('decisions (Excel)/oriangagrande2017_305m.xlsm', OJ_object);
%decisions = YearDataforDecisions('decisions (Excel)/z-oriangagrande2017futures.xlsm', OJ_object);
%for i = 1:12
for j = 1:length(stor_open)
    indicies = strcmp(char(storageNamesInUse(stor_open(j))),cities_match_storage(:,2));
    cities = cities_match_storage(indicies,:);
    [ORA_demand(j), POJ_demand(j), FCOJ_demand(j), ROJ_demand(j), ~, ~] = drawDemand(decision,cities,4*(i-1)+1, demand_city_ORA, demand_city_POJ, demand_city_ROJ, demand_city_FCOJ, pricesORA, pricesPOJ, pricesROJ, pricesFCOJ);
end
matchRegiontoStorage(region,ojObject,
rev = 
f = -(cost);
end

