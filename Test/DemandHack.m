% Hacky script to get demands for storage unit based for different products

decisions = YearDataforDecisions('Decisions/oriangagrande2017test.xlsm', ojObject);
%decisions = YearDataforDecisions('Decisions/oriangagrande2017test_pousch.xlsm', ojObject);
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

storage_open = find(ojObject.storage_cap);
ORA_demand = zeros(length(storage_open),1);
POJ_demand = zeros(length(storage_open),1);
FCOJ_demand = zeros(length(storage_open),1);
ROJ_demand = zeros(length(storage_open),1);
cities_match_storage = matchCitiestoStorage(storage_open, storage2market.(s2m));
for j = 1:length(storage_open)
    indicies = strcmp(char(storageNamesInUse(storage_open(j))),cities_match_storage(:,2));
    cities = cities_match_storage(indicies,:);
    [ORA_demand(j), POJ_demand(j), FCOJ_demand(j), ROJ_demand(j), ~, ~] = drawDemand(decisions,cities,1, demand_city_ORA, demand_city_POJ, demand_city_ROJ, demand_city_FCOJ);
end
FCOJ_futures = 0;
for i=2:2:length(decisions.future_mark_dec_FCOJ_current)
    FCOJ_futures = decisions.future_mark_dec_FCOJ_current(i) + FCOJ_futures;
end
FCOJ_futures_week = (FCOJ_futures*0.0833333)/4;
ORA_demand = transpose(ORA_demand);
POJ_demand = transpose(POJ_demand);
FCOJ_demand = transpose(FCOJ_demand);
ROJ_demand = transpose(ROJ_demand);

solver = 'Excel Files Orianga/Solver for POJ_grove to storagev2.xlsx';
xlswrite(solver,ORA_demand,'U43:W43');
xlswrite(solver,POJ_demand,'C43:E43');
xlswrite(solver,ROJ_demand,'M45:O45');
% percent_S61 = FCOJ_demand(3)/(FCOJ_demand(1)+FCOJ_demand(3));
% percent_S15 = 1 - percent_S61;
% FCOJ_demand(1) = FCOJ_demand(1)- percent_S15*FCOJ_futures_week;
FCOJ_demand(3) = FCOJ_demand(3)- FCOJ_futures_week;
xlswrite(solver,FCOJ_demand,'M44:O44');
