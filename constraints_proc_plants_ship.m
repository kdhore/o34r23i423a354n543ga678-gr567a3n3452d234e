%constraints for the grove shipping to proc plants and storages, and from
%proc plants to storages as well
function [c, ceq] = constraints_proc_plants_ship(x, storCapacities, procCapacities,...
    length_plants_open,length_stor_open,stor_POJ_demand,stor_FCOJ_demand)

%x -- 6 x (# storages * # plants) concatenated on itself horizontally
% storCapacities / procCapacities -- stor_open x 1, plants_open x 1
% storDemands -- 1 x stor_open


storCapacities = transpose(storCapacities);
procCapacities = transpose(procCapacities);

%shrink to sum both the products
totalProd = zeros(6,length_plants_open*length_stor_open);
for i = 1:6
    for j = 1:length_plants_open*length_stor_open
        totalProd(i,j) = x(i,j) + x(i,j+length_plants_open*length_stor_open);
    end
end
totalProd = sum(totalProd,1); %sum across columns for total product in each branch


procsAmts = zeros(1,length_plants_open);
for i = 1:length_plants_open
    for j = 1:length_stor_open
        procsAmts(1,i) = procsAmts(1,i) + totalProd(1,j+(i-1)*length_stor_open);
    end
end


storAmts = zeros(1,length_stor_open);
for i = 1:length_stor_open
    for j = 1:length_plants_open
        storAmts(1,i) = storAmts(1,i) + totalProd(1,i+(j-1)*length_stor_open);
    end
end

%this is where we actually set each half of the concatenated array
storAmtsPOJ = zeros(1,length_stor_open);
for i = 1:length_stor_open
    for j = 1:length_plants_open
        storAmtsPOJ(1,i) = storAmtsPOJ(1,i) + x(1,i+(j-1)*length_stor_open);
    end
end

storAmtsFCOJ = zeros(1,length_stor_open);
for i = 1:length_stor_open
    for j = length_plants_open+1:2*length_plants_open
        storAmtsFCOJ(1,i) = storAmtsFCOJ(1,i) + x(1,i+(j-1)*length_stor_open);
    end
end


%all storages <= capacities
%all procs <= capacities
%all x POJ >= demand
%all x FCOJ >= demand
c = [storAmts(1,:) - storCapacities(1,:); ...
    stor_POJ_demand(1,:) - storAmtsPOJ(1,:);...
    stor_FCOJ_demand(1,:) - storAmtsFCOJ(1,:)]; 
ceq = [procsAmts(1,:) - procCapacities(1,:)];
end

