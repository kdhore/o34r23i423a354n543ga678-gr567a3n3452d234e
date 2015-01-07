function [x, fval, purchase, percentpoj, percentroj, ship_from_grove, ship_from_plants] = linearProgram(ojObject, plant2storage_avgcost, YearDataRecord, ORA_demand, POJ_demand, ROJ_demand, FCOJ_demand, ORA_arr_futures, FCOJ_arr_futures)
    
    plants_open = find(ojObject.proc_plant_cap);
    numPlantsOpen = length(plants_open);
    stor_open = find(ojObject.storage_cap);
    numStorOpen = length(stor_open);
    storCapacities = ojObject.storage_cap(stor_open);
    procCapacities = ojObject.proc_plant_cap(plants_open);
    
    % get grove prices
    mean_grove_prices = zeros(6,1);
    for j = 1:6
        for i = 1:length(YearDataRecord)
            mean_grove_prices(j) = mean_grove_prices(j) + ...
                mean(YearDataRecord(i).us_price_spot_res(j,:));
        end
        mean_grove_prices(j) = 2000*mean_grove_prices(j)/length(YearDataRecord);
    end
          
    % rows are plant/storage, columns are grove
    grove2ps = load('Distance Data/grove2processing_storage.mat');
    g2ps = genvarname('grove2processing_storage_dist');
    grove2ps = cell2mat(grove2ps.(g2ps));
    
    % matrix of unit cost from groves to open storages
    grove2storage_unitcost = zeros(6,length(stor_open));
    for i = 1:4
        for j = 1:numStorOpen
            grove2storage_unitcost(i, j) = 0.22*grove2ps(10+stor_open(j),i);
        end
    end
    grove2storage_unitcost(5,:) = grove2storage_unitcost(1,:);
    grove2storage_unitcost(6,:) = grove2storage_unitcost(1,:);
    
    for i = 1:6
        grove2storage_unitcost(i,:) = grove2storage_unitcost(i,:)+mean_grove_prices(i);
    end
    
    % matrix of unit costs from groves to open processing plants
    grove2plant_unitcost = zeros(6,numPlantsOpen);
    for i = 1:4
        for j = 1:numPlantsOpen
            grove2plant_unitcost(i, j) = 0.22*grove2ps(plants_open(j),i);
        end
    end
    grove2plant_unitcost(5,:) = grove2plant_unitcost(1,:);
    grove2plant_unitcost(6,:) = grove2plant_unitcost(1,:);
    
    for i = 1:6
        grove2plant_unitcost(i,:) = grove2plant_unitcost(i,:)+mean_grove_prices(i);
    end
    
    % matrix of distances from open plants to open storage
%     plant2stor = zeros(numPlantsOpen, length(stor_open));
%     for i = 1:numPlantsOpen
%         for j = 1:length(stor_open)
%             plant2stor(i,j) = plant2stor_dist(plants_open(i), stor_open(j));
%         end
%     end
    
    % unit cost of plants to storage is passed in
    
    % get percent roj (using demands from first month because that's what
    % we optimize over in the linear program)
    percentroj = zeros(71,12);
    for i = 1:numStorOpen
        if (ROJ_demand(i,1)+FCOJ_demand(i,1) == 0)
            percentroj(stor_open(i),:) = zeros(1,12);
        else
            percentroj(stor_open(i),:) = 100*ones(1,12)*ROJ_demand(i,1)/(ROJ_demand(i,1)+FCOJ_demand(i,1));
        end
    end
    
    
    x0 = zeros(6,numPlantsOpen*numStorOpen*2+numStorOpen);
    
    a = @(x)cost_obj_func(x, grove2plant_unitcost, grove2storage_unitcost,...
        plant2storage_avgcost, plants_open, stor_open, ORA_arr_futures, mean_grove_prices);
    b = @(x)all_constraints(x, storCapacities, procCapacities,...
        numPlantsOpen,numStorOpen,POJ_demand(:,1),FCOJ_demand(:,1), ROJ_demand(:,1), ORA_demand(:,1),ORA_arr_futures,FCOJ_arr_futures);
    % here send FCOJ_demand - futures arriving... deal with futures, need
    % to include them in the total storage in constraints but not in the
    % demand
    
    lb = zeros(size(x0)); %lower bounds on soln

    options = optimoptions(@fmincon,'Algorithm','sqp','Display','iter');
    [x, fval] = fmincon(a,x0,[],[],[],[],lb,[],b,options);
    
    % from x get purchasing matrix
    purchasing_col = sum(x,2);
    purchase_temp = repmat(purchasing_col,1,12);
    purchasing_col(1) = purchasing_col(1) - ORA_arr_futures;
    purchase = repmat(purchasing_col,1,12);
    
    % shipping matrix from grove
    percent_to_plant = zeros(6, numPlantsOpen);
    for i = 1:numPlantsOpen
        amountToPlant = zeros(6,1);
        for j = 1:numStorOpen
            amountToPlant = amountToPlant + x(:,numStorOpen*(i-1)+j) + x(:,numStorOpen*numPlantsOpen + numStorOpen*(i-1)+j);
        end
        percent_to_plant(:,i) = 100*amountToPlant./purchase_temp(:,1);
    end
    percent_to_plant(isnan(percent_to_plant)) = 0;
    
    percent_to_stor = zeros(6, numStorOpen);
    for i = 1:numStorOpen
        percent_to_stor(:,i) = 100*x(:,numStorOpen*numPlantsOpen*2+i)./purchase_temp(:,1);
    end
    
    percent_to_stor(isnan(percent_to_stor)) = 0;
    
    ship_from_grove = horzcat(percent_to_plant, percent_to_stor);
    
    % get fcoj/poj percentage to each storage unit from each plant
    matrixLength = numStorOpen*numPlantsOpen;
    ship_from_plants = zeros(numStorOpen,numPlantsOpen*2);
    for i = 1:numPlantsOpen
        start1 = numStorOpen*(i-1);
        start2 = numStorOpen*(i-1) + matrixLength;
        totalSentPOJ = sum(sum(x(:,(start1+1:start1+numStorOpen))));
        totalSentFCOJ = sum(sum(x(:,(start2+1:start2+numStorOpen))));
        for j = 1:numStorOpen
            ship_from_plants(j,2*(i-1)+1) = 100*sum(x(:,start1+j))/totalSentPOJ;
            ship_from_plants(j,2*(i-1)+2) = 100*sum(x(:,start2+j))/totalSentFCOJ;
        end
    end
    ship_from_plants(isnan(ship_from_plants)) = 0;
    
    % percentpoj
    percentpoj = zeros(2,10);
    for i = 1:numPlantsOpen
        start1 = numStorOpen*(i-1);
        start2 = numStorOpen*(i-1) + matrixLength;
        poj = sum(sum(x(:,start1+1:start1+numStorOpen)));
        fcoj = sum(sum(x(:,start2+1:start2+numStorOpen)));
        totalpojfcoj = poj + fcoj;
        percentpoj(1,plants_open(i)) = 100*poj/totalpojfcoj;
    end
    percentpoj(isnan(percentpoj)) = 0;
    percentpoj(2,:) = 100*ones(1,10)-percentpoj(1,:);

end

