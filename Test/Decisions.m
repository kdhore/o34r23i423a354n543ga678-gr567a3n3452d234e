classdef Decisions
    % This is the decision class.  The input to this class is all the
    % YearData objects as well as the OJGame object.  It then sets the
    % properties values of this class to the decisions. This can obviously
    % call other functions or have other inputs from other functions as
    % we deem fit. It can also take as input any sort of metrics and such
    % that we have calculated from any other function or class.
    
    properties
        % The decisions
        year;
        proc_plant_dec;
        tank_car_dec;
        storage_dec;
        purchase_spotmkt_dec;
        quant_mult_dec;
        future_mark_dec_ORA;
        future_mark_dec_FCOJ;
        arr_future_dec_ORA;
        arr_future_dec_FCOJ;
        ship_grove_dec;
        manufac_proc_plant_dec = zeros(2,10);
        futures_ship_dec = zeros(71,1);
        ship_proc_plant_storage_dec = struct([]);
        reconst_storage_dec = zeros(71,12);
        pricing_ORA_dec;
        pricing_ORA_weekly_dec;
        pricing_POJ_dec;
        pricing_POJ_weekly_dec;
        pricing_FCOJ_dec;
        pricing_FCOJ_weekly_dec;
        pricing_ROJ_dec;
        pricing_ROJ_weekly_dec;
        
        demandStorageORA;
        demandStoragePOJ;
        demandStorageROJ;
        demandStorageFCOJ;
        
        demandProcPlantORA;
        demandProcPlantPOJ;
        demandProcPlantFCOJ;
        
        demandStorageTotalFCOJ;
        demandGroveORA;
        
        monthlyDemandORA;
        
        monthlyDemandFCOJ;
        
    end
    
    methods
        % Constructor where you update each of the properties of the
        % decision in the Decision file inputted
        function Decision = Decisions(filename,OJ_object,pricesORA,...
                pricesPOJ, pricesROJ, pricesFCOJ)
            
            
            
            % For now this needs to be MANUALLY updated
            % Load the year data objects
            yr2004 = load('yr2004.mat');
            yr2004temp = genvarname('yr2004');
            yr2004 = yr2004.(yr2004temp);
            
            yr2005 = load('yr2005.mat');
            yr2005temp = genvarname('yr2005');
            yr2005 = yr2005.(yr2005temp);
            
            yr2006 = load('yr2006.mat');
            yr2006temp = genvarname('yr2006');
            yr2006 = yr2006.(yr2006temp);
            
            yr2007 = load('yr2007.mat');
            yr2007temp = genvarname('yr2007');
            yr2007 = yr2007.(yr2007temp);
            
            yr2008 = load('yr2008.mat');
            yr2008temp = genvarname('yr2008');
            yr2008 = yr2008.(yr2008temp);
            
            yr2009 = load('yr2009.mat');
            yr2009temp = genvarname('yr2009');
            yr2009 = yr2009.(yr2009temp);
            
            yr2010 = load('yr2010.mat');
            yr2010temp = genvarname('yr2010');
            yr2010 = yr2010.(yr2010temp);
            
            yr2011 = load('yr2011.mat');
            yr2011temp = genvarname('yr2011');
            yr2011 = yr2011.(yr2011temp);
            
            yr2012 = load('yr2012.mat');
            yr2012temp = genvarname('yr2012');
            yr2012 = yr2012.(yr2012temp);
            
            yr2013 = load('yr2013.mat');
            yr2013temp = genvarname('yr2013');
            yr2013 = yr2013.(yr2013temp);
            
            yr2014 = load('yr2014.mat');
            yr2014temp = genvarname('yr2014_orianga');
            yr2014 = yr2014.(yr2014temp);
            
            YearDataRecord = [yr2004, yr2005, yr2006, yr2007, yr2008,...
                yr2009, yr2010, yr2011, yr2012, yr2013, yr2014];
            plants_open = find(OJ_object.proc_plant_cap);
            stor_open = find(OJ_object.storage_cap);
            
            
            if nargin > 0
                
                %prices inputted 7(regions) by 12(months)
                %                 Decision.pricing_ORA_dec = yr2014.pricing_ORA_dec - 0.5;
                %                 Decision.pricing_POJ_dec = yr2014.pricing_POJ_dec - 0.5;
                %                 Decision.pricing_ROJ_dec = yr2014.pricing_ROJ_dec - 0.5;
                %                 Decision.pricing_FCOJ_dec = yr2014.pricing_FCOJ_dec - 0.5;
                
                Decision.pricing_ORA_dec = zeros(7,12);
                Decision.pricing_POJ_dec = zeros(7,12);
                Decision.pricing_ROJ_dec = zeros(7,12);
                Decision.pricing_FCOJ_dec = zeros(7,12);
                
%                 %Michelle's most recent prices for 2015
%                 Decision.pricing_ORA_dec(1,:) = 2;
%                 Decision.pricing_ORA_dec(2,:) = 2.5;
%                 Decision.pricing_ORA_dec(3,:) = 2.7;
%                 Decision.pricing_ORA_dec(4,:) = 2.7;
%                 Decision.pricing_ORA_dec(5,:) = 2.5;
%                 Decision.pricing_ORA_dec(6,:) = 2.6;
%                 Decision.pricing_ORA_dec(7,:) = 2.7;
%                 
%                 Decision.pricing_POJ_dec(1,:) = 3.3;
%                 Decision.pricing_POJ_dec(2,:) = 3.3;
%                 Decision.pricing_POJ_dec(3,:) = 3.3;
%                 Decision.pricing_POJ_dec(4,:) = 3.3;
%                 Decision.pricing_POJ_dec(5,:) = 3.3;
%                 Decision.pricing_POJ_dec(6,:) = 3.2;
%                 Decision.pricing_POJ_dec(7,:) = 3.2;
%                 
%                 Decision.pricing_ROJ_dec(1,:) = 3.1;
%                 Decision.pricing_ROJ_dec(2,:) = 3.1;
%                 Decision.pricing_ROJ_dec(3,:) = 3.1;
%                 Decision.pricing_ROJ_dec(4,:) = 3.3;
%                 Decision.pricing_ROJ_dec(5,:) = 3.1;
%                 Decision.pricing_ROJ_dec(6,:) = 3.1;
%                 Decision.pricing_ROJ_dec(7,:) = 3.1;
%                 
%                 Decision.pricing_FCOJ_dec(1,:) = 2.7;
%                 Decision.pricing_FCOJ_dec(2,:) = 2.4;
%                 Decision.pricing_FCOJ_dec(3,:) = 2.3;
%                 Decision.pricing_FCOJ_dec(4,:) = 2.5;
%                 Decision.pricing_FCOJ_dec(5,:) = 2.6;
%                 Decision.pricing_FCOJ_dec(6,:) = 2.8;
%                 Decision.pricing_FCOJ_dec(7,:) = 2.6;
                
                Decision.pricing_ORA_dec = pricesORA;
                Decision.pricing_FCOJ_dec = pricesFCOJ;
                Decision.pricing_ROJ_dec = pricesROJ;
                Decision.pricing_POJ_dec = pricesPOJ;
                
                Decision.pricing_ORA_weekly_dec = zeros(7,48);
                Decision.pricing_POJ_weekly_dec = zeros(7,48);
                Decision.pricing_ROJ_weekly_dec = zeros(7,48);
                Decision.pricing_FCOJ_weekly_dec = zeros(7,48);
                
                
                for i = 1:7
                    for j = 1:12
                        Decision.pricing_ORA_weekly_dec(i,(4*j-3):(4*j)) = Decision.pricing_ORA_dec(i,j);
                        Decision.pricing_POJ_weekly_dec(i,(4*j-3):(4*j)) = Decision.pricing_POJ_dec(i,j);
                        Decision.pricing_ROJ_weekly_dec(i,(4*j-3):(4*j)) = Decision.pricing_ROJ_dec(i,j);
                        Decision.pricing_FCOJ_weekly_dec(i,(4*j-3):(4*j)) = Decision.pricing_FCOJ_dec(i,j);
                    end
                end
                
                Decision.demandStorageORA = zeros(length(stor_open),12);
                Decision.demandStoragePOJ = zeros(length(stor_open),12);
                Decision.demandStorageROJ = zeros(length(stor_open),12);
                Decision.demandStorageFCOJ = zeros(length(stor_open),12);
                
                storage2market_dist = load('storage2market_dist.mat');
                storage2market_dist_temp = genvarname('storage2market_dist');
                storage2market_dist = cell2mat(storage2market_dist.(storage2market_dist_temp));
                
                cellDist = cell(7);
                cellDist{1} = 'NE';
                cellDist{2} = 'MA';
                cellDist{3} = 'SE';
                cellDist{4} = 'MW';
                cellDist{5} = 'DS';
                cellDist{6} = 'NW';
                cellDist{7} = 'SW';
                
                
                for month = 1:12
                    for  i = 1:7
                        for j = 1:length(stor_open)
                            if(strcmp(matchRegiontoStorage(cellDist(i),OJ_object,storage2market_dist),...
                                    storageNamesInUse(stor_open(j))) == 1)
                                Decision.demandStorageORA(j, month) = ...
                                    Decision.demandStorageORA(j, month) + ...
                                    getDemand(1,i,Decision.pricing_ORA_dec(i,month));
                                Decision.demandStoragePOJ(j, month) = ...
                                    Decision.demandStoragePOJ(j, month) + ...
                                    getDemand(2,i,Decision.pricing_POJ_dec(i,month));
                                Decision.demandStorageROJ(j, month) = ...
                                    Decision.demandStorageROJ(j, month) + ...
                                    getDemand(3,i,Decision.pricing_ROJ_dec(i,month));
                                Decision.demandStorageFCOJ(j, month) = ...
                                    Decision.demandStorageFCOJ(j, month) + ...
                                    getDemand(4,i,Decision.pricing_FCOJ_dec(i,month));
                            end
                        end
                    end
                end
                
                
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Reading in shipping_manufacturing tab
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                % Enter the futures shipping to storage decisions
                % enter the percent to ship to each storage
                CumDemandoverStorageFCOJ = 0;
                
                for i = 1:length(stor_open)
                    CumDemandoverStorageFCOJ = CumDemandoverStorageFCOJ + ...
                        sum(Decision.demandStorageFCOJ(i, :));
                end
                
                for j = 1:length(stor_open)
                    Decision.futures_ship_dec(stor_open(j),1)...
                        =sum(Decision.demandStorageFCOJ(j, :))/...
                        CumDemandoverStorageFCOJ;
                end
                
                
                % Enter the shipping POJ and FCOJ to storage
                % decisions
                ship_break = struct('POJ', nan, 'FCOJ', nan);
                Decision.ship_proc_plant_storage_dec = ship_break;
                for i=1:71
                    for j =1:10
                        Decision.ship_proc_plant_storage_dec(i,j) = ship_break;
                    end
                end
                
                
                plant2storage = load('plant2storage_dist.mat');
                p2s = genvarname('processing2storage_dist');
                plant2storage = plant2storage.(p2s);
                % rows are storage, columns are plants
                plant2storage = cell2mat(plant2storage);
                
                % Set the percent of ORA to ship from groves to
                % either processing or storage plants. Each row is one of
                % the grove locations (FLA, CAL, TEX, ARZ,
                %  BRA, SPA) and the columns represent each processing plan
                %  and each storage unit that is currently open
                % Find the storage and processing plants currently open
                % from the OJ object.
                
                grove2processing_storage = load('grove2processing_storage.mat');
                g2ps = genvarname('grove2processing_storage_dist');
                grove2processing_storage = grove2processing_storage.(g2ps);
                grove2processing_storage = cell2mat(grove2processing_storage);
                grove2processing_storage = [grove2processing_storage, ...
                    grove2processing_storage(:,1),...
                    grove2processing_storage(:,1)];
                
                Dist_Grove_Storage = zeros(length(stor_open),6);
                Dist_Grove_Proc_Plant = zeros(length(plants_open),6);
                
                for i = 1:6
                    for j = 1:length(stor_open)
                        Dist_Grove_Storage(j, i) =...
                            grove2processing_storage(10+stor_open(j), i);
                    end
                end
                
                fcojCurrentTotalFutures = 0;
                for i = 1:5
                    fcojCurrentTotalFutures = fcojCurrentTotalFutures +...
                        OJ_object.fcoj_futures_current(1,i*2);
                end
                
                
                % Distances rows are 71 storage units and 10 proc plant
                % columns
                Dist_Total = plant2storage;
                
                Dist_Total = transpose(Dist_Total);
                %dimensioned 10 x 71 for consistency with rows = origin,
                %columns = destination. procs to storage
                
                storCapacities = OJ_object.storage_cap(stor_open); %storages x 1
                procCapacities = OJ_object.proc_plant_cap(plants_open); %plants x 1
                
                tankNums = OJ_object.tank_cars_num(plants_open); %plants x 1
                
                Dist_Grove_Proc_Plant = zeros(length(plants_open),6);
                for i = 1:6
                    for j = 1:length(plants_open)
                        Dist_Grove_Proc_Plant(j, i) =...
                            grove2processing_storage(plants_open(j), i);
                    end
                end
                Dist_Grove_Proc_Plant = transpose(Dist_Grove_Proc_Plant);
                %shrunk. Dist_Grove_Proc_Plant is 6 x procs
                
                %shrink the distances to procs x storages
                procStorageDist = zeros(length(plants_open), length(stor_open));
                for i = 1:length(plants_open)
                    for j = 1:length(stor_open)
                        procStorageDist(i,j) = ...
                            Dist_Total(plants_open(i),stor_open(j));
                    end
                end
                
                %only groves to proc plants
                decision_Distances_1 = zeros(6, length(plants_open)*length(stor_open));
                %only proc plants to storages
                decision_Distances_2 = zeros(6, length(plants_open)*length(stor_open));
                
                
                %make the storage demand = average of the demands
                stor_POJ_demand = zeros(1,length(stor_open));
                stor_FCOJ_demand = zeros(1,length(stor_open));
                for i = 1:length(stor_open)
                    stor_POJ_demand(1,i) = ...
                        mean(Decision.demandStoragePOJ(i,:));
                    stor_FCOJ_demand(1,i) = ...
                        max((mean(Decision.demandStorageFCOJ(i,:))+...
                        mean(Decision.demandStorageROJ(i,:))-...
                        fcojCurrentTotalFutures*Decision.futures_ship_dec(stor_open(i),1)),0);
                end
                
                
                for i = 1:6
                    for j = 1:length(plants_open)
                        for k = 1:length(stor_open)
                            
                            decision_Distances_1(i,k+(j-1)*length(stor_open)) = ...
                                Dist_Grove_Proc_Plant(i,j);
                            
                            decision_Distances_2(i,k+(j-1)*length(stor_open)) = ...
                                procStorageDist(j,k);
                        end
                    end
                end
                decision_Distances_1 = horzcat(decision_Distances_1,decision_Distances_1);
                decision_Distances_2 = horzcat(decision_Distances_2,decision_Distances_2);
                
                %{
                %NEED ACCURATE PRICE FORECASTS. Using mean prices over the
                %years (as below) won't really cut it
                mean_grove_prices = zeros(6,1);
                
                for j = 1:6
                    for i = 1:length(YearDataRecord)
                        mean_grove_prices(j) = mean_grove_prices(j) + ...
                            mean(YearDataRecord(i).us_price_spot_res(j,:));
                    end
                    mean_grove_prices(j) = mean_grove_prices(j)...
                        /length(YearDataRecord);
                end
                
                mean_grove_prices = horzcat(mean_grove_prices);
                
                %Dimensioned groves x (procs * storages)
                x0 = zeros(size(decision_Distances_1));
                
                a = @(x)proc_plant_ship_network(x, decision_Distances_1,...
                    decision_Distances_2, tankNums, mean_grove_prices,...
                    length(plants_open),length(stor_open));
                b = @(x)constraints_proc_plants_ship(x, storCapacities, procCapacities,...
                    length(plants_open),length(stor_open),stor_POJ_demand,stor_FCOJ_demand);
                
                lb = zeros(size(x0)); %lower bounds on soln
                
                options = optimoptions(@fmincon,'Algorithm','sqp');
                [x, fval] = fmincon(a,x0,[],[],[],[],lb,[],b,options);
                fminPOJFCOJ = fval; %the total cost of the so%lution
                xminPOJFCOJ = x; %the solution of shipping what to where
                
                denomPOJ = zeros(length(plants_open),1);
                denomFCOJ = zeros(length(plants_open),1);
                
                for i = 1:length(plants_open)
                    for j = 1:length(stor_open)
                        denomPOJ(i,1) = denomPOJ(i,1) + ...
                            sum(xminPOJFCOJ(:,j+(i-1)*length(stor_open)));
                        denomFCOJ(i,1) = denomFCOJ(i,1) + ...
                            sum(xminPOJFCOJ(:,...
                            length(plants_open)*length(stor_open)+...
                            j+(i-1)*length(stor_open)));
                        
                    end
                end
               
                %expand the decisions to the original 71x10 matrix below
                for i = 1:length(plants_open)
                    for j = 1:length(stor_open)
                        %the plant and storage decisions
                        Decision.ship_proc_plant_storage_dec(stor_open(j),...
                            plants_open(i)).POJ = ...
                            sum(xminPOJFCOJ(:,j+(i-1)*length(stor_open)))...
                            /denomPOJ(i,1);
                        Decision.ship_proc_plant_storage_dec(stor_open(j),...
                            plants_open(i)).FCOJ = ...
                            sum(xminPOJFCOJ(:,...
                            length(plants_open)*length(stor_open)+...
                            j+(i-1)*length(stor_open)))...
                            /denomFCOJ(i,1);
                        
                        if Decision.ship_proc_plant_storage_dec(stor_open(j),...
                                plants_open(i)).POJ < 0.0000001
                            Decision.ship_proc_plant_storage_dec(stor_open(j),...
                                plants_open(i)).POJ = 0;
                        end
                        
                        if Decision.ship_proc_plant_storage_dec(stor_open(j),...
                                plants_open(i)).FCOJ < 0.0000001
                            Decision.ship_proc_plant_storage_dec(stor_open(j),...
                                plants_open(i)).FCOJ = 0;
                        end
                    end
                    
                end
                %expressed in percentages
               %} 
                
                Decision.demandProcPlantORA = zeros(length(plants_open),12);
                Decision.demandProcPlantPOJ = zeros(length(plants_open),12);
                Decision.demandProcPlantFCOJ = zeros(length(plants_open),12);
                
                
                fcojCurrentTotalFutures = 0;
                for i = 1:5
                    fcojCurrentTotalFutures = fcojCurrentTotalFutures +...
                        OJ_object.fcoj_futures_current(1,i*2);
                end
                
                for month = 1:12
                    for i = 1:length(plants_open)
                        for k = 1:length(stor_open)
                            
                            if (Decision.ship_proc_plant_storage_dec(stor_open(k),plants_open(i)).POJ ~= 0)
                                % Find the first non-zero % of POJ sent
                                % from storage to proc. plant
                                index = k;
                                Decision.demandProcPlantPOJ(i, month) = ...
                                    Decision.demandStoragePOJ(index, month)/...
                                    Decision.ship_proc_plant_storage_dec(stor_open(index),plants_open(i)).POJ;
                            else
                                % If no POJ was shipped from this proc
                                % plant to this storage unit
                                
                                % If this proc plant's POJ demand is
                                % already assigned leave it as is
                                if (Decision.demandProcPlantPOJ(i, month) > 0)
                                    Decision.demandProcPlantPOJ(i, month) = ...
                                        Decision.demandProcPlantPOJ(i, month);
                                else
                                    % If this proc plant's POJ demand is not
                                    % already assigned ensure it remains 0
                                    Decision.demandProcPlantPOJ(i, month) = 0;
                                end
                            end
                            if (Decision.ship_proc_plant_storage_dec(stor_open(k),plants_open(i)).FCOJ ~= 0)
                                index = k;
                                Decision.demandProcPlantFCOJ(i, month) = ...
                                    max((Decision.demandStorageFCOJ(index, month)+...
                                    Decision.demandStorageROJ(index, month)-...
                                    fcojCurrentTotalFutures*Decision.futures_ship_dec(stor_open(index),1)),0)/...
                                    Decision.ship_proc_plant_storage_dec(stor_open(index),plants_open(i)).FCOJ;
                            else
                                % If no FCOJ was shipped from this proc
                                % plant to this storage unit
                                
                                % If this proc plant's FCOJ demand is
                                % already assigned leave it as is
                                if (Decision.demandProcPlantFCOJ(i, month) > 0)
                                    Decision.demandProcPlantFCOJ(i, month) = ...
                                        Decision.demandProcPlantFCOJ(i, month);
                                else
                                    % If this proc plant's FCOJ demand is not
                                    % already assigned ensure it remains 0
                                    Decision.demandProcPlantFCOJ(i, month) = 0;
                                end
                            end
                        end
                    end
                    
                end
                
                
                
                for month = 1:12
                    for i = 1:length(plants_open)
                        Decision.demandProcPlantORA(i, month) = ...
                            Decision.demandProcPlantPOJ(i, month)+ ...
                            Decision.demandProcPlantFCOJ(i, month);
                    end
                end
                
                
                
                Decision.ship_grove_dec = zeros(6, length(plants_open) + ...
                    length(stor_open));
                
                % Set the decisions for the storage units
                
                
                %all the distances, with processing plant distances first
                %dimensions 6 x (# procs + # storages)
                Dist_Total_Grove_Storage = transpose(Dist_Grove_Storage);
                
                stor_ORA_demand = zeros(1,length(stor_open));
                for i = 1:length(stor_open)
                    stor_ORA_demand(1,i) = ...
                        mean(Decision.demandStorageORA(i,:));
                end
                
                totalORAdemand = stor_ORA_demand;
                %sized 1 x (#stor)
                
                
                %NEED ACCURATE PRICE FORECASTS. Using mean prices over the
                %years (as below) won't really cut it
                mean_grove_prices = zeros(6,1);
                
                for j = 1:6
                    for i = 1:length(YearDataRecord)
                        mean_grove_prices(j) = mean_grove_prices(j) + ...
                            mean(YearDataRecord(i).us_price_spot_res(j,:));
                    end
                    mean_grove_prices(j) = mean_grove_prices(j)...
                        /length(YearDataRecord);
                end
                
                %{
                %initial allocation
                x0 = zeros(6, length(stor_open)); %6 x (#stor)
                a = @(x)grove_ship_network(x, mean_grove_prices,...
                    Dist_Total_Grove_Storage);
                b = @(x)constraints_grove_ship(x, totalORAdemand,...
                    storCapacities);
                
                lb = zeros(size(x0)); %lower bounds on soln
                
                
                options = optimoptions(@fmincon,'Algorithm','sqp');
                [x, fval] = fmincon(a,x0,[],[],[],[],lb,[],b,options);
                fminORA = fval; %the total cost of the solution
                xminORA = x; %the solution of shipping what to where
                
                Decision.purchase_spotmkt_dec = zeros(6,12);
                
                for i = 1:6
                    for j = 1:12
                        Decision.purchase_spotmkt_dec(i,j) = ...
                            (sum(xminPOJFCOJ(i,:)) + sum(xminORA(i,:)))/12/4;
                    end
                end
                
                for k = 1:6
                    for i = 1:length(plants_open)
                        for j = 1:length(stor_open)
                            Decision.ship_grove_dec(k,i) = ...
                                Decision.ship_grove_dec(k,i) + ...
                                xminPOJFCOJ(k, j+(i-1)*length(stor_open)) + ...
                                xminPOJFCOJ(k, ...
                                length(plants_open)*length(stor_open)+j+(i-1)*length(stor_open));
                        end
                    end
                end
                
                for i = 1:6
                    for j = length(plants_open)+1:length(plants_open)+length(stor_open)
                        Decision.ship_grove_dec(i,j) = xminORA(i,j-length(plants_open));
                    end
                end
                
                
                
                %x is dimensioned 6 x (# procs + # storages)
                for i = 1:6
                    denom = sum(Decision.ship_grove_dec(i,:));
                    for j = 1:length(plants_open) + length(stor_open)
                        %the plant and storage decisions
                        Decision.ship_grove_dec(i,j) = ...
                            Decision.ship_grove_dec(i,j)/denom;
                        if Decision.ship_grove_dec(i,j) < 0.0000001
                            Decision.ship_grove_dec(i,j) = 0;
                        end
                    end
                end
                %expressed in percentages
                
                
                % Processing plants manufacturing decisions
                
                denom = zeros(length(plants_open), 1);
                for i = 1:length(plants_open)
                    for j = 1:length(stor_open)
                        denom(i,1) = denom(i,1) + sum(xminPOJFCOJ(:,j+(i-1)*length(stor_open))) + ...
                            sum(xminPOJFCOJ(:,j+(i-1)*length(stor_open)+length(plants_open)*length(stor_open)));
                    end
                end
                
                for i = 1:length(plants_open)
                    for j = 1:length(stor_open)
                        % 1st row is POJ
                        Decision.manufac_proc_plant_dec(1, plants_open(i)) = ...
                            Decision.manufac_proc_plant_dec(1, plants_open(i)) + ...
                            sum(xminPOJFCOJ(:, j + (i-1)*length(stor_open)));
                    end
                    Decision.manufac_proc_plant_dec(1, plants_open(i)) = ...
                        Decision.manufac_proc_plant_dec(1, plants_open(i))/denom(i,1);
                    
                    %the below is FCOJ
                    Decision.manufac_proc_plant_dec(2, plants_open(i)) = ...
                        1 - Decision.manufac_proc_plant_dec(1, plants_open(i));
                end
                
                %}
                
                % Set the % of FCOJ to reconstitute to ROJ at each
                % storage unit each month where each row is an open storage
                % unit and each column is a month from Sep-Aug
                Decision.demandStorageTotalFCOJ = zeros(length(stor_open),12);
                
                for i = 1:12
                    for j = 1:length(stor_open)
                        Decision.demandStorageTotalFCOJ(j,i) = ...
                            Decision.demandStorageFCOJ(j,i) + ...
                            Decision.demandStorageROJ(j,i);
                    end
                end
                
                Decision.reconst_storage_dec = zeros(71, 12);
                for i = 1:12
                    for j = 1:length(stor_open)
                        Decision.reconst_storage_dec(stor_open(j), i) = ...
                            Decision.demandStorageROJ(j,i)/...
                            Decision.demandStorageTotalFCOJ(j,i);
                    end
                end
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Reading in raw_materials tab
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %  Manually set the spot market prices equal to matrix
                %  where each row is grove location (FLA, CAL, TEX, ARZ,
                %  BRA, SPA respectively) and each column is a month of the
                %  year starting in September
                
                % assign the buying quantity (tons per week in a month)
                % either manually or by looping through locations/months
                
                
                
                %  Set the multipliers equal to matrix
                %  where each row is grove location (FLA, CAL, TEX, ARZ,
                %  BRA, SPA respectively) and each column alternates
                %  between being the "multiplier value" and the "price"
                Decision.quant_mult_dec = zeros(6,6);
                mean_grove_prices = zeros(6,1);
                stdev_grove_prices = zeros(6,1);
                
                for j = 1:6
                    for i = 1:length(YearDataRecord)
                        mean_grove_prices(j) = mean_grove_prices(j) + ...
                            mean(YearDataRecord(i).us_price_spot_res(j,:));
                        stdev_grove_prices(j) = stdev_grove_prices(j) + ...
                            var(YearDataRecord(i).us_price_spot_res(j,:));
                    end
                    mean_grove_prices(j) = mean_grove_prices(j)...
                        /length(YearDataRecord);
                    stdev_grove_prices(j) = sqrt(stdev_grove_prices(j)...
                        /length(YearDataRecord));
                end
                
                % These are the parameters to determine the price
                % boundaries
                phi1 = -1;
                phi2 = 1;
                phi3 = 3;
                
                for i = 1:6
                    Decision.quant_mult_dec(i,2) = mean_grove_prices(i)+...
                        phi1*stdev_grove_prices(i);
                    Decision.quant_mult_dec(i,4) = mean_grove_prices(i)+...
                        phi2*stdev_grove_prices(i);
                    Decision.quant_mult_dec(i,6) = mean_grove_prices(i)+...
                        phi3*stdev_grove_prices(i);
                end
                
                % Set multipler values (for now manually set - could be tuned)
                for i = 1:6
                    Decision.quant_mult_dec(i,1) = 1.2;
                    Decision.quant_mult_dec(i,3) = 1;
                    Decision.quant_mult_dec(i,5) = 0.8;
                end
                
                %  Set the amount (in tons) of ORA futures to
                %  purchase in each year from the year after the current to
                %  5 years after the current
%                 theta1 = [0.90,0.85,0.81,0.78,0.76, 1.1];
                theta1 = 0.76;
                theta2 = 1;
                
                cumDemand = 0;
                for i = 1:7 %iterate over all regions
                    averagePrice = mean(Decision.pricing_ORA_dec(i,:));
                    cumDemand = cumDemand + getDemand(1,i,averagePrice);
                end
                %cumDemand is the total demand for all regions for ORA over
                %months
                
                %Find number of futures until this year
                %Total Futures maturing in decision year + 1
                FuturesMaturing1 = 0;
                for i = 1:4
                    FuturesMaturing1 = FuturesMaturing1 + ...
                        OJ_object.ora_futures_current1(1,2*i);
                end
                
                %Total Futures maturing in decision year + 2
                FuturesMaturing2 = 0;
                for i = 1:3
                    FuturesMaturing2 = FuturesMaturing2 + ...
                        OJ_object.ora_futures_current2(1,2*i);
                end
                
                %Total Futures maturing in decision year + 3
                FuturesMaturing3 = 0;
                for i = 1:2
                    FuturesMaturing3 = FuturesMaturing3 + ...
                        OJ_object.ora_futures_current3(1,2*i);
                end
                
                %Total Futures maturing in decision year + 4
                FuturesMaturing4 = 0;
                FuturesMaturing4 = FuturesMaturing4 + ...
                    OJ_object.ora_futures_current4(1,2);
                
                % Current decision year is first chance to buy for year 5
                FuturesMaturing5 = 0;
                
                FuturesMaturing = [FuturesMaturing1, FuturesMaturing2,...
                    FuturesMaturing3, FuturesMaturing4, FuturesMaturing5];
                
                
                [~, ~, Decision.future_mark_dec_ORA] = xlsread(filename,'raw_materials','N31:O35');
                Decision.future_mark_dec_ORA = cell2mat(cellNaNReplace(Decision.future_mark_dec_ORA,0));
                
                for i = 1:5
                    
                    if Decision.future_mark_dec_ORA(i,1) < theta2
                        Decision.future_mark_dec_ORA(i,2) = max(theta1*(cumDemand - FuturesMaturing(1,i)),0);
                        
                    else
                        Decision.future_mark_dec_ORA(i,2) = 0;
                        
                    end
                end
                
                
                %  Set the amount (in tons) of FCOJ futures to
                %  purchase in each year from the year after the current to
                %  5 years after the current
                
%                 theta3 = [1.05,1.00,0.96,0.93,0.91];
                theta3 = 1;
                theta4 = 1;
                
                cumDemandFCOJ = 0;
                for i = 1:7 %iterate over all regions
                    averagePrice = mean(Decision.pricing_FCOJ_dec(i,:));
                    cumDemandFCOJ = cumDemandFCOJ + getDemand(4,i,averagePrice);
                end
                %cumDemand is the total demand for all regions for ORA over
                %months
                
                %Find number of futures until this year
                %Total Futures maturing in decision year + 1
                FCOJFuturesMaturing1 = 0;
                for i = 1:4
                    FCOJFuturesMaturing1 = FCOJFuturesMaturing1 + ...
                        OJ_object.fcoj_futures_current1(1,2*i);
                end
                
                %Total Futures maturing in decision year + 2
                FCOJFuturesMaturing2 = 0;
                for i = 1:3
                    FCOJFuturesMaturing2 = FCOJFuturesMaturing2 + ...
                        OJ_object.fcoj_futures_current2(1,2*i);
                end
                
                %Total Futures maturing in decision year + 3
                FCOJFuturesMaturing3 = 0;
                for i = 1:2
                    FCOJFuturesMaturing3 = FCOJFuturesMaturing3 + ...
                        OJ_object.fcoj_futures_current3(1,2*i);
                end
                
                %Total Futures maturing in decision year + 4
                FCOJFuturesMaturing4 = 0;
                FCOJFuturesMaturing4 = FCOJFuturesMaturing4 + ...
                    OJ_object.fcoj_futures_current4(1,2);
                
                % Current decision year is first chance to buy for year 5
                FCOJFuturesMaturing5 = 0;
                
                FCOJFuturesMaturing = [FCOJFuturesMaturing1, FCOJFuturesMaturing2,...
                    FCOJFuturesMaturing3, FCOJFuturesMaturing4, FCOJFuturesMaturing5];
                
                
                [~, ~, Decision.future_mark_dec_FCOJ] = xlsread(filename,'raw_materials','N37:O41');
                Decision.future_mark_dec_FCOJ = cell2mat(cellNaNReplace(Decision.future_mark_dec_FCOJ,0));
                
                for i = 1:5
                    
                    if Decision.future_mark_dec_FCOJ(i,1) < theta4
                        Decision.future_mark_dec_FCOJ(i,2) = theta3*max((cumDemandFCOJ - FCOJFuturesMaturing(1,i)),0);
                        
                    else
                        Decision.future_mark_dec_FCOJ(i,2) = 0;
                        
                    end
                end
                
                
                % Set the percent of futures of ORA or FCOJ
                % to arrive in month Sep-Aug
                Decision.arr_future_dec_ORA = zeros(1, 12);
                Decision.monthlyDemandORA = zeros(1,12);
                
                for i = 1:12
                    Decision.monthlyDemandORA(1, i) = ...
                        sum(Decision.demandStorageORA(:,i));
                end
                
                for i = 1:12
                    Decision.arr_future_dec_ORA(1, i) = ...
                        Decision.monthlyDemandORA(1, i)/...
                        sum(Decision.monthlyDemandORA(1, :));
                end
                
                Decision.arr_future_dec_FCOJ = zeros(1, 12);
                Decision.monthlyDemandFCOJ = zeros(1,12);
                
                for i = 1:12
                    Decision.monthlyDemandFCOJ(1, i) = ...
                        sum(Decision.demandStorageFCOJ(:,i));
                end
                
                for i = 1:12
                    Decision.arr_future_dec_FCOJ(1, i) = ...
                        Decision.monthlyDemandFCOJ(1, i)/...
                        sum(Decision.monthlyDemandFCOJ(1, :));
                end
                
                
                
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Assigning decisions to the facilities tab
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % For processing plants, the decision is the capacity to
                % buy/sell in each plant: [P01;P02;...;P10]
                
                %Add a certain processing plant if:
                %capacity sold + transportation savings > price of new
                %plant + price of upgrading capacity + cost of tossing out
                %current product
                
                %Add capacity if:
                %capacity add cost + transportation add cost < total
                %revenue gain + opp. cost of product tossed out
                %(include parameters to set for certain # of years)
                
                %Reduce capacity if:
                %excess capacity not being used, and there is no projected
                %increase in demand or delivery
                Decision.proc_plant_dec = zeros(10,1);% enter matrix manually here
                
                %                 rho1 = 1.01; %parameter > 1 for buffer of processing plant
                %                 for i = 1:length(plants_open)
                %                     Decision.proc_plant_dec(plants_open(i),1) = ...
                %                         rho1*mean(Decision.demandProcPlantORA(i,:))/4 - ...
                %                         OJ_object.proc_plant_cap(plants_open(i),1);
                %                     %can be positive or negative number
                %                 end
                
                
                
                % For tank car, the decision is #. of tank cars to buy/sell
                % at each proc. plant: [P01;P02;...;P10]
                Decision.tank_car_dec = zeros(10,1); % enter matrix manually here
                
                %                 rho2 = 0.5;
                %                 %number of tank cars as a percentage for transport between
                %                 %processing plant and storage unit is parameterized by
                %                 %rho2
                %                 rho3 = 0.75; %percentage of max to use
                %                 for i = 1:length(plants_open)
                %                     Decision.tank_car_dec(plants_open(i),1) = ...
                %                         rho2*rho3*mean(Decision.demandProcPlantORA(i,:))/4 - ...
                %                         OJ_object.tank_cars_num(plants_open(i),1);
                %                 end
                %
                
                
                % For storage, the decision is the capacity to buy/sell
                % capacity at each of the storage units
                Decision.storage_dec = zeros(71,1);
                % Manually define the storage units in use to have some
                % capacity to buy/sell. For example, for index i:
                % yr.storage_dec(i) = capacity;
                %                 Decision.storage_dec(4,1) = -31000;
                %                 Decision.storage_dec(stor_open(3),1) = -20000;
                
                %Add a storage unit if:
                %capacity sold + transportation savings > price of new
                %plant + price of upgrading capacity + cost of tossing out
                %current product
                
                %For capacity, always want some buffer between the
                %projected demand and above because we don't want
                %additional (unforseen) factors to throw out a lot of our
                %product
                
                %                 rho4 = 1.01; %parameter > 1 for buffer space of storage unit
                %                 for i = 1:length(stor_open)
                %                     Decision.storage_dec(stor_open(i),1) = ...
                %                         rho4*(mean(Decision.demandStorageORA(i,:))/4 + ...
                %                         mean(Decision.demandStoragePOJ(i,:))/4 + ...
                %                         mean(Decision.demandStorageROJ(i,:))/4 + ...
                %                         mean(Decision.demandStorageFCOJ(i,:))/4) - ...
                %                         OJ_object.storage_cap(stor_open(i),1);
                %                     %can be positive or negative number
                %                 end
                %
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Correct formatting for percent decisions               %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Convert all percents to 100 times decimal
                
                Decision.arr_future_dec_ORA = ...
                    100.*Decision.arr_future_dec_ORA;
                Decision.arr_future_dec_FCOJ = ...
                    100.*Decision.arr_future_dec_FCOJ;
                Decision.ship_grove_dec = 100.*Decision.ship_grove_dec;
                Decision.manufac_proc_plant_dec = ...
                    100.*Decision.manufac_proc_plant_dec;
                Decision.futures_ship_dec = 100.*Decision.futures_ship_dec;
                Decision.reconst_storage_dec = ...
                    100.*Decision.reconst_storage_dec;
                
                for i=1:71
                    for j =1:10
                        Decision.ship_proc_plant_storage_dec(i,j).POJ = ...
                            100*Decision.ship_proc_plant_storage_dec(i,j).POJ;
                        Decision.ship_proc_plant_storage_dec(i,j).FCOJ = ...
                            100*Decision.ship_proc_plant_storage_dec(i,j).FCOJ;
                    end
                end
                
                
                
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Code to be written to write these updates decisions in %
                % to Excel decision file                                 %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
            end
            
        end
        
    end
end
