%This is the objective function for processing plant shipping to storages
%(POJ or FCOJ)
function [f] = proc_plant_ship_network(x, decision_Distances_1,...
    decision_Distances_2, tankNums, mean_grove_prices,...
    length_plants_open,length_stor_open)

%x -- grove x (#plants * #stor) [2 of them]
%distances -- grove x (#plants * #stor)
%tankNums -- 1 x #proc
%mean_grove_prices -- 6 x 1


xtemp = zeros(size(x));
for i = 1:6
    xtemp(i,:) = mean_grove_prices(i,:);
end
%xtemp now same dimensions as x, and thus can multiply x

totalProd = zeros(6,length_plants_open*length_stor_open);
for i = 1:6
    for j = 1:length_plants_open*length_stor_open
        totalProd(i,j) = x(i,j) + x(i,j+length_plants_open*length_stor_open);
    end
end

transpo_Cost = zeros(1, length_plants_open*length_stor_open);
for i = 1:length_plants_open
    for j = 1:length_stor_open
        % Check if the tons of FCOJ+POJ sent from this proc plant to some 
        % stor j is less than #tons that can be carried by available tanks
        % cars
        if sum(totalProd(:,j+(i-1)*length_stor_open)) <= tankNums(i)/2*30
            % In this case all of the FCOJ+POJ in this proc plant/stor
            % combination can be transported using tank cars
            transpo_Cost(1,j+(i-1)*length_stor_open) = ...
                floor((sum(totalProd(:,j+(i-1)*length_stor_open)))...
                /30)*36*decision_Distances_2(1,j+(i-1)*length_stor_open);
            % Term 1: # of cars needed to transport the FCOJ+POJ
            % Term 2: # $36/car/mile cost
            % Term 3: # of miles from proc plant i to stor j
            
            % Update number of tank cars left at this proc plant 
            tankNums(i) = tankNums(i) - ...
                floor((sum(totalProd(:,j+(i-1)*length_stor_open)))/30);
        else
            % In this case all of the FCOJ+POJ in this proc plant/stor
            % combination CANNOT be transported using tank cars
            % Independent carriers are needed
            transpo_Cost(1,j+(i-1)*length_stor_open) = ...
                tankNums(i)/2*36*...
                decision_Distances_2(1,j+(i-1)*length_stor_open)+...
                0.65*decision_Distances_2(1,j+(i-1)*length_stor_open)*...
                (sum(totalProd(:,j+(i-1)*length_stor_open))-tankNums(i)/2*30);
            % 1st summed term: # of remaining cars (can be
            % zero)*$36/car/mile * miles from proc plant i to stor j
            % 2nd summed term: $0.65/mile * miles from proc plant i to
            % stor j * tonnage of FCOJ+POJ that cannot be served by
            % tank cars
        end
    end
end

xtemp2 = sum(totalProd,1);


f = sum(sum(xtemp.*x)) + sum(sum(0.22*(x.*decision_Distances_1))) + sum(xtemp2.*transpo_Cost);
%objective function is the product of each of the decisions (aka
%the amount to allocate to each place) by the distance to each
%respective storage unit from each processing plant

end

