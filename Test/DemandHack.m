% Hacky script to get demands for storage unit based for different products


initial_str = 'Excel Files Orianga/oriangagrande2014Results.xlsm';
yearFiles = dir('YearData Orianga/*.mat');
ojObject = OJGame(initial_str);
for i = 1:(length(yearFiles))
    year = load(strcat('YearData Orianga/',yearFiles(i).name));
    yearVar = genvarname(strrep(yearFiles(i).name,'.mat',''));
    ojObject = ojObject.update(year.(yearVar));
end
decisions = YearDataforDecisions('Excel Files Orianga/oriangagrande2016.xlsm', ojObject);
storage2market = load('Distance Data/storage2market_dist.mat');
s2m = genvarname('storage2market_dist');
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

storage_open = find(OJgameobj.storage_cap);
ORA_demand = zeros(length(storage_open),1);
POJ_demand = zeros(length(storage_open),1);
FCOJ_demand = zeros(length(storage_open),1);
ROJ_demand = zeros(length(storage_open),1);
cities_match_storage = matchCitiestoStorage(storage_open, storage2market.(s2m));
for j = 1:length(storage_open)
    indicies = strcmp(char(storageNamesInUse(storage_open(j))),cities_match_storage(:,2));
    cities = cities_match_storage(indicies,:);
    [ORA_demand(j), POJ_demand(j), FCOJ_demand(j), ROJ_demand(j), ~, ~] = drawDemandPousch(decisions,cities,1, demand_city_ORA, demand_city_POJ, demand_city_ROJ, demand_city_FCOJ);
end
