function [c, ceq] = all_constraints(x, storCapacities, procCapacities,...
    numPlantsOpen,numStorOpen,stor_POJ_demand,stor_FCOJ_demand, stor_ROJ_demand, stor_ORA_demand, ORA_arr_futures, FCOJ_arr_futures)
% let x be like the excel spreadsheet: groves as rows and then columns are
% as follows: first POJ shipped to processing plant-storage (go through
% processing plants first), then FCOJ shipped to processing plant-storage
% (through plants first), then ORA to each storage unit
% i.e. three matrices concatenated

% get amount in each storage unit by product
poj_storage = zeros(1,numStorOpen);
fcoj_storage = zeros(1,numStorOpen);
ora_storage = zeros(1,numStorOpen);
lengthMatrix = numPlantsOpen*numStorOpen;

for j = 1:numStorOpen
    temp_sum = zeros(6,1);
    temp_sum_2 = zeros(6,1);
    for i = 1:numPlantsOpen
        temp_sum = temp_sum + x(:,j+(numStorOpen)*(i-1)); 
        temp_sum_2 = temp_sum_2 + x(:,lengthMatrix+j+(numStorOpen)*(i-1));    
    end
    poj_storage(j) = sum(temp_sum);
    fcoj_storage(j) = sum(temp_sum_2);
    ora_storage(j) = sum(x(:,lengthMatrix*2+j));
end
fcoj_storage = fcoj_storage + FCOJ_arr_futures';
% total amount in each storage unit
tot_storage = poj_storage + fcoj_storage + ora_storage;

% total amount in each processing plant
poj_plant = zeros(1,numPlantsOpen);
fcoj_plant = zeros(1,numPlantsOpen);
for j = 1:numPlantsOpen
    start = numStorOpen*(j-1);
    poj_plant(j) = sum(sum(x(:,start+1:(start+numStorOpen))));
    start = start + lengthMatrix;
    fcoj_plant(j) = sum(sum(x(:,start+1:(start+numStorOpen))));
end
tot_plant = poj_plant + fcoj_plant;
tot_plant_temp = tot_plant;
procCapacities_temp = procCapacities;
for i = length(tot_plant)+1:numStorOpen
    tot_plant_temp = [tot_plant_temp tot_plant_temp(1)];
    procCapacities_temp = [procCapacities_temp; procCapacities_temp(1)];
end

ora_FLA = sum(x(1,:));
ORA_futures_const = ones(1,numStorOpen)*(ORA_arr_futures-ora_FLA);
stor_FCOJ_demand_temp = stor_FCOJ_demand - FCOJ_arr_futures;
c = [stor_POJ_demand'-poj_storage;(stor_FCOJ_demand_temp+stor_ROJ_demand)'-(fcoj_storage-FCOJ_arr_futures');...
    stor_ORA_demand'-ora_storage;tot_storage-storCapacities';tot_plant_temp-procCapacities_temp';ORA_futures_const];
ceq = [];
end

