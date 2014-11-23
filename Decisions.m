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
    end
    
    methods
        % Constructor where you update each of the properties of the
        % decision in the Decision file inputted
        function Decisions = Decision(filename,OJ_object)
            if nargin > 0
                
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
                
                YearDataRecord = [yr2004, yr2005, yr2006, yr2007, yr2008,...
                    yr2009, yr2010, yr2011, yr2012, yr2013];
                plants_open = find(OJ_object.proc_plant_cap);
                stor_open = find(OJ_object.storage_cap);
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Reading in pricing tab
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Manually enter the market price for each product where
                % each row is a region (NE, MA, SE, MW, DS, NW, SW) and the
                % columns are months Sep-Aug
                Decisions.pricing_ORA_dec = zeros(7,12);
                Decisions.pricing_POJ_dec = zeros(7, 12);
                Decisions.pricing_ROJ_dec = zeros(7, 12);
                Decisions.pricing_FCOJ_dec = zeros(7, 12);
                
                % Set the prices of each product either manually or by
                % looping through the regions and the months
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
               
                
                Decisions.demandStorageORA = zeros(length(stor_open),12);
                Decisions.demandStoragePOJ = zeros(length(stor_open),12);
                Decisions.demandStorageROJ = zeros(length(stor_open),12);
                Decisions.demandStorageFCOJ = zeros(length(stor_open),12);
                
                for month = 1:12
                    for  i = 1:7
                        for j = 1:length(stor_open)
                            if(strcmp(matchRegiontoStorage(i,OJ_Object),...
                                    storageNamesInUse(stor_open(j))) == 1)
                                Decisions.demandStorageORA(j, month) = ...
                                    Decisions.demandStorageORA(j, month) + ...
                                    getDemand(1,i,Decisions.pricing_ORA_dec(i,month));
                                Decisions.demandStoragePOJ(j, month) = ...
                                    Decisions.demandStoragePOJ(j, month) + ...
                                    getDemand(1,i,Decisions.pricing_POJ_dec(i,month));
                                Decisions.demandStorageROJ(j, month) = ...
                                    Decisions.demandStorageROJ(j, month) + ...
                                    getDemand(1,i,Decisions.pricing_ROJ_dec(i,month));
                                Decisions.demandStorageFCOJ(j, month) = ...
                                    Decisions.demandStorageFCOJ(j, month) + ...
                                    getDemand(1,i,Decisions.pricing_FCOJ_dec(i,month));
                            end
                        end
                    end
                end
                
               
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Reading in shipping_manufacturing tab
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                % Enter the futures shipping to storage decisions
                Decisions.futures_ship_dec = zeros(length(stor_open),1);
                % enter the percent to ship to each storage
                CumDemandoverStorageFCOJ = 0;                
                
                for i = 1:length(stor_open)
                    CumDemandoverStorageFCOJ = CumDemandoverStorageFCOJ + ...
                        sum(Decisions.demandStorageFCOJ(i, :));
                end

                for j = 1:length(stor_open)
                    Decisions.futures_ship_dec(j,1)...
                        =sum(Decisions.demandStorageFCOJ(j, :))/...
                        CumDemandoverStorageFCOJ;
                end

                                
                % Enter the shipping POJ and FCOJ to storage
                % decisions
                ship_break = struct('POJ', nan, 'FCOJ', nan);
                Decisions.ship_proc_plant_storage_dec = ship_break;
                for (i=1:71)
                    for(j =1:10)
                        Decisions.ship_proc_plant_storage_dec(i,j) = ship_break;
                    end
                end
                
                AverageProcPlantPOJPercent = zeros(71,10);
                AverageProcPlantFCOJPercent = zeros(71,10);
                
                % Calculate average of these percentages over the past
                % years
                for i = 71
                    for j = 10
                        for k = 1:length(YearDataRecord)
                            AverageProcPlantPOJPercent(i,j) ...
                                = AverageProcPlantPOJPercent(i,j)...
                                +YearDataRecord(k).ship_proc_plant_storage_dec(i,j).POJ;
                            AverageProcPlantFCOJPercent(i,j) ...
                                = AverageProcPlantFCOJPercent(i,j)...
                                +YearDataRecord(k).ship_proc_plant_storage_dec(i,j).FCOJ;
                            
                        end
                    end
                end
                
                for i = 71
                    for j = 10
                        AverageProcPlantPOJPercent(i,j) = ...
                            AverageProcPlantPOJPercent(i,j)/...
                            length(YearDataRecord);
                        AverageProcPlantFCOJPercent(i,j) = ...
                            AverageProcPlantFCOJPercent(i,j)/...
                            length(YearDataRecord);
                    end
                end
                
                plant2storage = load('plant2storage_dist.mat');
                p2s = genvarname('processing2storage_dist');
                plant2storage = plant2storage.(p2s);
                % rows are storage, columns are plants
                plant2storage = cell2mat(plant2storage);
                
                
                epsilon1 = 1;
                epsilon2 = 1/10000;
                epsilon3 = 1;
                epsilon4 = 1/10000;
                        
                CumDemandoverStoragePOJ = 0;                
                for i = 1:length(stor_open)
                    CumDemandoverStoragePOJ = CumDemandoverStoragePOJ + ...
                        sum(Decisions.demandStoragePOJ(i, :));
                end
                
                %%%% NEED TO MAKE SURE THE PERCENT OVER ALL STORAGE UNITS
                %%%% IS 1 in a more efficient way
                for j = 1:length(plants_open)
                    for i = 1:length(stor_open)-1
                        Decisions.ship_proc_plant_storage_dec(stor_open(i),plants_open(j)).POJ = ...
                            AverageProcPlantPOJPercent(stor_open(i),plants_open(j)) + ...
                            epsilon1*(sum(Decisions.demandStoragePOJ(i,:))/...
                            CumDemandoverStoragePOJ -  ...
                            AverageProcPlantPOJPercent(stor_open(i),plants_open(j)))...
                            + epsilon2*(plant2storage(stor_open(i),plants_open(j)));
                        
                        Decisions.ship_proc_plant_storage_dec(stor_open(i),plants_open(j)).FCOJ = ...
                            AverageProcPlantFCOJPercent(stor_open(i),plants_open(j)) + ...
                            epsilon3*(sum(Decisions.demandStorageFCOJ(i,:))/...
                            CumDemandoverStorageFCOJ -  ...
                            AverageProcPlantFCOJPercent(stor_open(i),plants_open(j)))...
                            + epsilon4*(plant2storage(stor_open(i),plants_open(j)));
                    
                    end
                    % at this point i = length(stor_open)
                    Decisions.ship_proc_plant_storage_dec(stor_open(i),plants_open(j)).POJ = ...
                        1 - sum(Decisions.ship_proc_plant_storage_dec(:,plants_open(j)).POJ);
                    Decisions.ship_proc_plant_storage_dec(stor_open(i),plants_open(j)).FCOJ = ...
                        1 - sum(Decisions.ship_proc_plant_storage_dec(:,plants_open(j)).FCOJ);
                 end
                
                
                Decisions.demandProcPlantORA = zeros(length(plants_open),12);
                Decisions.demandProcPlantPOJ = zeros(length(plants_open),12);
                Decisions.demandProcPlantFCOJ = zeros(length(plants_open),12);
                index = 0;
                
                for month = 1:12
                    for i = 1:length(plants_open)
                        for k = 1:length(stor_open)
                            if (Decisions.ship_proc_plant_storage_dec(k,i).POJ ~= 0)
                                % Find the first non-zero % of POJ sent
                                % from storage to proc. plant
                                index = k;
                            end
                            Decisions.demandProcPlantPOJ(i, month) = ...
                                Decisions.demandStoragePOJ(index, month)/...
                                Decisions.ship_proc_plant_storage_dec(index,i).POJ;
                            Decisions.demandProcPlantFCOJ(i, month) = ...
                                (Decisions.demandStorageFCOJ(index, month)+...
                                Decisions.demandStorageROJ(index, month)-OJ_Object.fcoj_futures_current)/...
                                Decisions.ship_proc_plant_storage_dec(index,i).FCOJ;
                            if (Decisions.manufac_proc_plant_dec(1,i).POJ ~= 0)
                                Decisions.demandProcPlantORA(i, month) = ...
                                    Decisions.demandProcPlantPOJ(i, month)/...
                                    Decisions.manufac_proc_plant_dec(1,i).POJ;
                            elseif (Decisions.manufac_proc_plant_dec(1,i).FCOJ ~= 0)
                                Decisions.demandProcPlantORA(i, month) = ...
                                    Decisions.demandProcPlantFCOJ(i, month)/...
                                    Decisions.manufac_proc_plant_dec(1,i).FCOJ;
                            end
                        end
                    end
                end
                
                          
                % Do this for a 71 x 10 matrix as well
                
                % For stor_fac = each storage unit in stor_open
                % For proc_plant = each processing plant in plants_open
                % yr.ship_proc_plant_storage_dec(% for each stor_fac,% for each proc_plant).POJ = % enter the percent to ship to each storage
                % yr.ship_proc_plant_storage_dec(% for each stor_fac,% for each proc_plant).FCOJ = % enter the percent to ship to each storage
                              
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
                
                for i = 1:6
                    for j = 1:length(plants_open)
                       Dist_Grove_Proc_Plant(j, i) =...
                           grove2processing_storage(plants_open(j), i);
                    end
                end
                
                theta5 = 1;
                theta6 = -1;
                theta7 = 1;
                theta8 = -1;
                
                Decisions.ship_grove_dec = zeros(6, length(plants_open) +...
                    length(stor_open));

                % Set the decisions for the storage units
                
                CumDemandoverStorageORA = 0;
                CumDemandoverProcPlantORA = 0;
                TotalCurrentFutures = 0;
                
                for i = 1:5
                    TotalCurrentFutures = TotalCurrentFutures + ...
                        OJ_Object.ora_current_futures(1,2*i);
                end
                
                for i = 1:length(stor_open)
                    CumDemandoverStorageORA = CumDemandoverStorageORA + ...
                        sum(Decisions.demandStorageORA(i, :));
                end
                
                for i = 1:6
                    for j = 1:length(stor_open)
                        Decisions.ship_grove_dec(i, lengths(plants_open)+j)...
                            =(sum(Decisions.demandStorageORA(j, :)) - ...
                            Decisions.futures_ship_dec(j,1)*TotalCurrentFutures)/...
                            CumDemandoverStorageORA;
                    end
                end
                
                                
                for i = 1:6
                    for j = 1:length(stor_open)
                       Decisions.ship_grove_dec(i,lengths(plants_open)+j)= ...
                           theta5*(Decisions.ship_grove_dec(i,lengths(plants_open)+j))...
                           +theta6*(Dist_Grove_Storage(j, i));
                    end
                end
                
                for i = 1:length(plants_open)
                    CumDemandoverProcPlantORA = CumDemandoverProcPlantORA + ...
                        sum(Decisions.demandProcPlantORA(i, :));
                end
                        
                for i = 1:6
                    for j = 1:length(plants_open)
                        Decisions.ship_grove_dec(i, j)...
                            =(sum(Decisions.demandProcPlantORA(j, :)))/...
                            CumDemandoverProcPlantORA;
                    end
                end
                
                                
                for i = 1:6
                    for j = 1:length(plants_open)
                       Decisions.ship_grove_dec(i,j)= ...
                           theta7*(Decisions.ship_grove_dec(i,j))...
                           +theta8*(Dist_Grove_Proc_Plant(j, i));
                    end
                end
                
                Decisions.demandProcPlantPOJ = zeros(length(plants_open),12);
                Decisions.demandProcPlantFCOJ = zeros(length(plants_open),12);
                
                % Processing plants manufacturing decisions
                Decisions.manufac_proc_plant_dec =...
                    struct('POJ', nan, 'FCOJ', nan);
                for i = 1:length(plants_open)
                    Decisions.manufac_proc_plant_dec(1,i).POJ = ...
                         sum(Decisions.demandProcPlantPOJ(i,:))/...
                         sum(Decisions.demandProcPlantORA(i,:));
                     Decisions.manufac_proc_plant_dec(1,i).FCOJ = ...
                         sum(Decisions.demandProcPlantFCOJ(i,:))/...
                         sum(Decisions.demandProcPlantORA(i,:));
                end
                
                % Set the % of FCOJ to reconstitute to ROJ at each
                % storage unit each month where each row is an open storage
                % unit and each column is a month from Sep-Aug
                Decisions.demandStorageTotalFCOJ = zeros(length(stor_open),12);
                
                for i = 1:12
                    for j = 1:length(stor_open)
                        Decisions.demandStorageTotalFCOJ(j,i) = ...
                            Decisions.demandStorageFCOJ(j,i) + ...
                            Decisions.demandStorageROJ(j,i);
                    end
                end
                
                Decisions.reconst_storage_dec = zeros(length(stor_open), 12);
                for i = 1:12
                    for j = 1:length(stor_open)
                        Decisions.reconst_storage_dec(j, i) = ...
                            Decisions.demandStorageROJ(j,i)/...
                            Decisions.demandStorageTotalFCOJ(j,i);
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
                Decisions.purchase_spotmkt_dec = zeros(6,12);
                % assign the buying quantity (tons per week in a month)
                % either manually or by looping through locations/months
                
                Decisions.demandGroveORA = zeros(6,12);
                index1 = 0;
                index2 = 0;
                for month = 1:12
                    for grove = 1:6
                        for i = 1:length(plants_open)
                            if (Decisions.ship_grove_dec(grove,i) ~= 0)
                                % Find the first non-zero % of POJ sent
                                % from storage to proc. plant
                                index1 = i;
                            end
                        end
                        Demand.demandGroveORA(grove,month) = ...
                            Demand.demandGroveORA(grove,month) + ...
                            (Decisions.demandProcPlantORA(index1, month)/...
                            Decisions.ship_grove_dec(grove,index1));
                        for j = 1:length(stor_open)
                            if (Decisions.ship_grove_dec(grove, length(plants_open)+j) ~= 0)
                                % Find the first non-zero % of POJ sent
                                % from storage to proc. plant
                                index2 = j;
                            end
                        end
                        Demand.demandGroveORA(grove,month) = ...
                            Demand.demandGroveORA(grove,month) + ...
                            (Decisions.demandStorageORA(index2, month)/...
                            Decisions.ship_grove_dec(grove, length(plants_open)+index2));
                    end
                end
                
                % Finally, set the value of the decisions
                for i = 1:6
                    for j = 1:12
                        Decisions.purchase_spotmkt_dec(i,j) = ...
                            Decisions.demandGroveORA(i,j);
                    end
                end
                
                %  Set the multipliers equal to matrix
                %  where each row is grove location (FLA, CAL, TEX, ARZ,
                %  BRA, SPA respectively) and each column alternates
                %  between being the "multiplier value" and the "price"
                Decisions.quant_mult_dec = zeros(6,6);
                mean_grove_prices = zeros(6,1);
                stdev_grove_prices = zeros(6,1);
                
                for j = 1:6
                    for i = 1:length(YearDataRecord)
                        mean_grove_prices(j) = mean_grove_price(j) + ...
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
                    Decisions.quant_mult_dec(i,2) = mean_grove_prices(i)+...
                        phi1*stdev_grove_prices(i);
                    Decisions.quant_mult_dec(i,4) = mean_grove_prices(i)+...
                        phi2*stdev_grove_prices(i);
                    Decisions.quant_mult_dec(i,6) = mean_grove_prices(i)+...
                        phi3*stdev_grove_prices(i);
                end              
                
                % Set multipler values (for now manually set - could be tuned)
                for i = 1:6
                    Decisions.quant_mult_dec(i,1) = 1.2;
                    Decisions.quant_mult_dec(i,3) = 1;
                    Decisions.quant_mult_dec(i,5) = 0.8;
                end
                
                %  Set the amount (in tons) of ORA futures to
                %  purchase in each year from the year after the current to
                %  5 years after the current
                theta1 = 0;
                theta2 = 0;
                
                cumDemand = 0;
                for i = 1:7 %iterate over all regions
                    averagePrice = mean(Decisions.pricing_ORA_dec(i,:));
                    cumDemand = cumDemand + getDemand(1,i,averagePrice);
                end
                %cumDemand is the total demand for all regions for ORA over
                %months
                
                %Find number of futures until this year
                %Total Futures maturing in decision year + 1
                FuturesMaturing1 = 0;
                for i = 1:4
                    FuturesMaturing1 = FuturesMaturing1 + ...
                        OJ_Object.ora_futures_current1(1,2*i);
                end
                
                %Total Futures maturing in decision year + 2
                FuturesMaturing2 = 0;
                for i = 1:3
                    FuturesMaturing2 = FuturesMaturing2 + ...
                        OJ_Object.ora_futures_current2(1,2*i);
                end
                
                %Total Futures maturing in decision year + 3
                FuturesMaturing3 = 0;
                for i = 1:2
                    FuturesMaturing3 = FuturesMaturing3 + ...
                        OJ_Object.ora_futures_current3(1,2*i);
                end
                
                %Total Futures maturing in decision year + 4
                FuturesMaturing4 = 0;
                FuturesMaturing4 = FuturesMaturing4 + ...
                    OJ_Object.ora_futures_current4(1,2);
                
                % Current decision year is first chance to buy for year 5
                FuturesMaturing5 = 0;
                
                FuturesMaturing = [FuturesMaturing1, FuturesMaturing2,...
                    FuturesMaturing3, FuturesMaturing4, FuturesMaturing5];
                
                
                [~, ~, Decisions.future_mark_dec_ORA] = xlsread(filename,'raw_materials','N31:O35');
                Decisions.future_mark_dec_ORA = cell2mat(cellNaNReplace(Decisions.future_mark_dec_ORA,0));
                
                for i = 1:5
                    
                    if Decisions.future_mark_dec_ORA(i,1) < theta2
                        Decisions.future_mark_dec_ORA(i,2) = theta1*(cumDemand - FuturesMaturing(1,i));
                        
                    else
                        Decisions.future_mark_dec_ORA(i,2) = 0;
                        
                    end
                end
                
                
                %  Set the amount (in tons) of FCOJ futures to
                %  purchase in each year from the year after the current to
                %  5 years after the current
                
                theta3 = 0;
                theta4 = 0;
                
                cumDemandFCOJ = 0;
                for i = 1:7 %iterate over all regions
                    averagePrice = mean(Decisions.pricing_FCOJ_dec(i,:));
                    cumDemandFCOJ = cumDemandFCOJ + getDemand(4,i,averagePrice);
                end
                %cumDemand is the total demand for all regions for ORA over
                %months
                
                %Find number of futures until this year
                %Total Futures maturing in decision year + 1
                FCOJFuturesMaturing1 = 0;
                for i = 1:4
                    FCOJFuturesMaturing1 = FCOJFuturesMaturing1 + ...
                        OJ_Object.fcoj_futures_current1(1,2*i);
                end
                
                %Total Futures maturing in decision year + 2
                FCOJFuturesMaturing2 = 0;
                for i = 1:3
                    FCOJFuturesMaturing2 = FCOJFuturesMaturing2 + ...
                        OJ_Object.fcoj_futures_current2(1,2*i);
                end
                
                %Total Futures maturing in decision year + 3
                FCOJFuturesMaturing3 = 0;
                for i = 1:2
                    FCOJFuturesMaturing3 = FCOJFuturesMaturing3 + ...
                        OJ_Object.fcoj_futures_current3(1,2*i);
                end
                
                %Total Futures maturing in decision year + 4
                FCOJFuturesMaturing4 = 0;
                FCOJFuturesMaturing4 = FCOJFuturesMaturing4 + ...
                    OJ_Object.fcoj_futures_current4(1,2);
                
                % Current decision year is first chance to buy for year 5
                FCOJFuturesMaturing5 = 0;
                
                FCOJFuturesMaturing = [FCOJFuturesMaturing1, FCOJFuturesMaturing2,...
                    FCOJFuturesMaturing3, FCOJFuturesMaturing4, FCOJFuturesMaturing5];
                
                
                [~, ~, Decisions.future_mark_dec_FCOJ] = xlsread(filename,'raw_materials','N37:O41');
                Decisions.future_mark_dec_FCOJ = cell2mat(cellNaNReplace(Decisions.future_mark_dec_FCOJ,0));
                
                for i = 1:5
                    
                    if Decisions.future_mark_dec_FCOJ(i,1) < theta4
                        Decisions.future_mark_dec_FCOJ(i,2) = theta3*(cumDemandFCOJ - FCOJFuturesMaturing(1,i));
                        
                    else
                        Decisions.future_mark_dec_FCOJ(i,2) = 0;
                        
                    end
                end
                

                % Set the percent of futures of ORA or FCOJ
                % to arrive in month Sep-Aug
                Decisions.arr_future_dec_ORA = zeros(1, 12);
                Decisions.monthlyDemandORA = zeros(1,12);
                 
                for i = 1:12
                    Decisions.monthlyDemandORA(1, i) = ...
                       sum(Decisions.demandStorageORA(:,i));
                end
                
                for i = 1:12
                     Decisions.arr_future_dec_ORA(1, i) = ...
                       Decisions.monthlyDemandORA(1, i)/...
                       sum(Decisions.monthlyDemandORA(1, :));
                end
                
                Decisions.arr_future_dec_FCOJ = zeros(1, 12);
                Decisions.monthlyDemandFCOJ = zeros(1,12);

                for i = 1:12
                    Decisions.monthlyDemandFCOJ(1, i) = ...
                       sum(Decisions.demandStorageFCOJ(:,i));
                end
                
                for i = 1:12
                     Decisions.arr_future_dec_FCOJ(1, i) = ...
                       Decisions.monthlyDemandFCOJ(1, i)/...
                       sum(Decisions.monthlyDemandFCOJ(1, :));
                end
 
                
                
                
                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Assigning decisions to the facilities tab
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % For processing plants, the decision is the capacity to
                % buy/sell in each plant: [P01;P02;...;P10]
                Decisions.proc_plant_dec = zeros(10,1);% enter matrix manually here

                %currently nothing changed in capacity
                
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
                
                % For tank car, the decision is #. of tank cars to buy/sell
                % at each proc. plant: [P01;P02;P03;P04;P05;P06;P07]
                Decisions.tank_car_dec = zeros(10,1); % enter matrix manually here
                
                % For storage, the decision is the capacity to buy/sell
                % capacity at each of the storage units
                Decisions.storage_dec = zeros(71,1);
                % Manually define the storage units in use to have some
                % capacity to buy/sell. For example, for index i:
                % yr.storage_dec(i) = capacity;
                
                %Add a storage unit if:
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
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                
                
                
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Code to be written to write these updates decisions in %
                % to Excel decision file                                 %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
            end
            
        end
        
    end
end
